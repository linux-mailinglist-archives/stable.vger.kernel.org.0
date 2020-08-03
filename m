Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8682423A50D
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgHCMcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbgHCMct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:32:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7CA2054F;
        Mon,  3 Aug 2020 12:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457968;
        bh=5rkRIb3U+cgcQZ4kmQQZEzU4H5D2wfdrv2LhgBPwlHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vmMEHxlkIrZv31mynTOrgTuK3HC2Z46tIeT0LkwpGvEbECD4tbh6axrWQxshLdekX
         izBAM3uKuGY+8AnFJgmU3F3AxDjtDOBFxOrpay3Kc8jYiOEnOFoOgblEHoQmYXgU6C
         PjKdb3770fK5oR/Ok7ZSvR7kRroAyO0zL3Uju0R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence Oberman <loberman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/56] qed: Disable "MFW indication via attention" SPAM every 5 minutes
Date:   Mon,  3 Aug 2020 14:20:02 +0200
Message-Id: <20200803121852.618349390@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurence Oberman <loberman@redhat.com>

[ Upstream commit 1d61e21852d3161f234b9656797669fe185c251b ]

This is likely firmware causing this but its starting to annoy customers.
Change the message level to verbose to prevent the spam.
Note that this seems to only show up with ISCSI enabled on the HBA via the
qedi driver.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index f9e475075d3ea..61d5d76545687 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1015,7 +1015,8 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
+			   "MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
2.25.1



