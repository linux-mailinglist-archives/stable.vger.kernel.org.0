Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5642B226550
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbgGTPwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:52:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731131AbgGTPwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B292064B;
        Mon, 20 Jul 2020 15:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260363;
        bh=fZGipVGofuM807ctGi+1eX5Vtc+LSPRJ04BE7yKx4co=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuVP2A3B43sfHRt8diAMK4X3BlgTQcEXBkP7r0GK8LvJ/vV5KGVrdCouyIAIKcqip
         o7WUnD+xv8lUHo9yF61CD1zjUL4aM+SsFBNBR2cVtVdJOT2XXkmEBKxxvj6oyhLvky
         EA9XypXwDqxUZDYhJmbr0ALE0da+p4jZ+SG1VXUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 4.19 076/133] mtd: rawnand: timings: Fix default tR_max and tCCS_min timings
Date:   Mon, 20 Jul 2020 17:37:03 +0200
Message-Id: <20200720152807.370380312@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 4d8ec041d9c454029f6cd90622f6d81eb61e781c upstream.

tR and tCCS are currently wrongly expressed in femtoseconds, while we
expect these values to be expressed in picoseconds. Set right
hardcoded values.

Fixes: 6a943386ee36 mtd: rawnand: add default values for dynamic timings
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-mtd/20200428094302.14624-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/nand_timings.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/nand_timings.c
+++ b/drivers/mtd/nand/raw/nand_timings.c
@@ -331,10 +331,9 @@ int onfi_fill_data_interface(struct nand
 		/* microseconds -> picoseconds */
 		timings->tPROG_max = 1000000ULL * ONFI_DYN_TIMING_MAX;
 		timings->tBERS_max = 1000000ULL * ONFI_DYN_TIMING_MAX;
-		timings->tR_max = 1000000ULL * 200000000ULL;
 
-		/* nanoseconds -> picoseconds */
-		timings->tCCS_min = 1000UL * 500000;
+		timings->tR_max = 200000000;
+		timings->tCCS_min = 500000;
 	}
 
 	return 0;


