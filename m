Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737432A165E
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgJaLou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbgJaLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539E620739;
        Sat, 31 Oct 2020 11:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144688;
        bh=RGwWFbdTSeMYnT/6ONWYsBZIACDMa+Zj1OA7PoJPVqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQZn0kJGYKTSHOg5+IEYCXJQPhbVZgTiKfDxHf+ffr3R6EHdVgEUSKcqSii/MXqd1
         hmIIRSVKJCAdo9kjQ/9Uaj4eUqyVfQzD08+GdgVGy2CtEyW/pwFNYQkL965odOnO6Q
         bZelAbVVBmlp3fLVklwFM44slRsV1l9IDLZ6D8Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 43/74] net: ipa: command payloads already mapped
Date:   Sat, 31 Oct 2020 12:36:25 +0100
Message-Id: <20201031113502.109878819@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit df833050cced27e1b343cc8bc41f90191b289334 ]

IPA transactions describe actions to be performed by the IPA
hardware.  Three cases use IPA transactions:  transmitting a socket
buffer; providing a page to receive packet data; and issuing an IPA
immediate command.  An IPA transaction contains a scatter/gather
list (SGL) to hold the set of actions to be performed.

We map buffers in the SGL for DMA at the time they are added to the
transaction.  For skb TX transactions, we fill the SGL with a call
to skb_to_sgvec().  Page RX transactions involve a single page
pointer, and that is recorded in the SGL with sg_set_page().  In
both of these cases we then map the SGL for DMA with a call to
dma_map_sg().

Immediate commands are different.  The payload for an immediate
command comes from a region of coherent DMA memory, which must
*not* be mapped for DMA.  For that reason, gsi_trans_cmd_add()
sort of hand-crafts each SGL entry added to a command transaction.

This patch fixes a problem with the code that crafts the SGL entry
for an immediate command.  Previously a portion of the SGL entry was
updated using sg_set_buf().  However this is not valid because it
includes a call to virt_to_page() on the buffer, but the command
buffer pointer is not a linear address.

Since we never actually map the SGL for command transactions, there
are very few fields in the SGL we need to fill.  Specifically, we
only need to record the DMA address and the length, so they can be
used by __gsi_trans_commit() to fill a TRE.  We additionally need to
preserve the SGL flags so for_each_sg() still works.  For that we
can simply assign a null page pointer for command SGL entries.

Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20201022010029.11877-1-elder@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ipa/gsi_trans.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -398,15 +398,24 @@ void gsi_trans_cmd_add(struct gsi_trans
 
 	/* assert(which < trans->tre_count); */
 
-	/* Set the page information for the buffer.  We also need to fill in
-	 * the DMA address and length for the buffer (something dma_map_sg()
-	 * normally does).
+	/* Commands are quite different from data transfer requests.
+	 * Their payloads come from a pool whose memory is allocated
+	 * using dma_alloc_coherent().  We therefore do *not* map them
+	 * for DMA (unlike what we do for pages and skbs).
+	 *
+	 * When a transaction completes, the SGL is normally unmapped.
+	 * A command transaction has direction DMA_NONE, which tells
+	 * gsi_trans_complete() to skip the unmapping step.
+	 *
+	 * The only things we use directly in a command scatter/gather
+	 * entry are the DMA address and length.  We still need the SG
+	 * table flags to be maintained though, so assign a NULL page
+	 * pointer for that purpose.
 	 */
 	sg = &trans->sgl[which];
-
-	sg_set_buf(sg, buf, size);
+	sg_assign_page(sg, NULL);
 	sg_dma_address(sg) = addr;
-	sg_dma_len(sg) = sg->length;
+	sg_dma_len(sg) = size;
 
 	info = &trans->info[which];
 	info->opcode = opcode;


