Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F463408FFD
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242636AbhIMNsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242222AbhIMNql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CA760FC1;
        Mon, 13 Sep 2021 13:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539916;
        bh=fT292m/SNxuzLY1t+SCsCQsUexxhcXIKN/bPLzBAUks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LacpkuUiwfoNHiNbwhIT8pszVtDWQhMNevtbzNLyr8e6wIborkzUSBfs3TbSoogV2
         Orl88soTVXaQeP9gfdSUdX71m+Cu+d3NM73LmrXWOkQ1XTDubV4pRSps8thaCUGq1Y
         6SZsCJnOaZm6mhF8yY3WNR4DcnywZwSWJJAb+dhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 213/236] octeontx2-af: Set proper errorcode for IPv4 checksum errors
Date:   Mon, 13 Sep 2021 15:15:18 +0200
Message-Id: <20210913131107.617928931@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

[ Upstream commit 1e4428b6dba9b683dc2ec0a56ed7879de3200cce ]

With current config, for packets with IPv4 checksum errors,
errorcode is being set to UNKNOWN. Hence added a separate
errorcodes for outer and inner IPv4 checksum and changed
NPC configuration accordingly.

Also turn on L2 multicast address check in NPC protocol check block.

Fixes: 6b3321bacc5a ("octeontx2-af: Enable packet length and csum validation")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index a8a515ba1700..6fa9358e6db4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1171,14 +1171,15 @@ int rvu_npc_init(struct rvu *rvu)
 
 	/* Enable below for Rx pkts.
 	 * - Outer IPv4 header checksum validation.
-	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2M].
+	 * - Detect outer L2 broadcast address and set NPC_RESULT_S[L2B].
+	 * - Detect outer L2 multicast address and set NPC_RESULT_S[L2M].
 	 * - Inner IPv4 header checksum validation.
 	 * - Set non zero checksum error code value
 	 */
 	rvu_write64(rvu, blkaddr, NPC_AF_PCK_CFG,
 		    rvu_read64(rvu, blkaddr, NPC_AF_PCK_CFG) |
-		    BIT_ULL(32) | BIT_ULL(24) | BIT_ULL(6) |
-		    BIT_ULL(2) | BIT_ULL(1));
+		    ((u64)NPC_EC_OIP4_CSUM << 32) | (NPC_EC_IIP4_CSUM << 24) |
+		    BIT_ULL(7) | BIT_ULL(6) | BIT_ULL(2) | BIT_ULL(1));
 
 	/* Set RX and TX side MCAM search key size.
 	 * LA..LD (ltype only) + Channel
-- 
2.30.2



