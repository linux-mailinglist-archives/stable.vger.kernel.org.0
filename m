Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7248A409047
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbhIMNvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244526AbhIMNtd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF5FD6152B;
        Mon, 13 Sep 2021 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539993;
        bh=lzVwAXKN3WGnht6ENogvCiF5d2VbewTF7MCfwouzSps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DPscJqfEupnJGbE6QRTUEnazo9gPy4CWgsI3iJIcqNwG/HwXJMzfWMkfINqwFBuP
         MgP+j4GaMBPZgXdl0zYYa9gIrtvqrwZRoOXsv6psdRQ7UVZu+Tm9Qn3neScMBGeVKJ
         hifngnmBKi3weNrvFPicuc/evH3uYsAldVFqGaO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/236] octeontx2-af: Fix static code analyzer reported issues
Date:   Mon, 13 Sep 2021 15:15:17 +0200
Message-Id: <20210913131107.587604223@linuxfoundation.org>
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

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit 698a82ebfb4b2f2014baf31b7324b328a2a6366e ]

This patch fixes the static code analyzer reported issues
in rvu_npc.c. The reported errors are different sizes of
operands in bitops and returning uninitialized values.

Fixes: 651cd2652339 ("octeontx2-af: MCAM entry installation support")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 7767b1111944..a8a515ba1700 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -27,7 +27,7 @@
 #define NIXLF_PROMISC_ENTRY	2
 
 #define NPC_PARSE_RESULT_DMAC_OFFSET	8
-#define NPC_HW_TSTAMP_OFFSET		8
+#define NPC_HW_TSTAMP_OFFSET		8ULL
 
 static const char def_pfl_name[] = "default";
 
@@ -1318,7 +1318,7 @@ static void npc_unmap_mcam_entry_and_cntr(struct rvu *rvu,
 					  int blkaddr, u16 entry, u16 cntr)
 {
 	u16 index = entry & (mcam->banksize - 1);
-	u16 bank = npc_get_bank(mcam, entry);
+	u32 bank = npc_get_bank(mcam, entry);
 
 	/* Remove mapping and reduce counter's refcnt */
 	mcam->entry2cntr_map[entry] = NPC_MCAM_INVALID_MAP;
@@ -1879,8 +1879,8 @@ int rvu_mbox_handler_npc_mcam_shift_entry(struct rvu *rvu,
 	struct npc_mcam *mcam = &rvu->hw->mcam;
 	u16 pcifunc = req->hdr.pcifunc;
 	u16 old_entry, new_entry;
+	int blkaddr, rc = 0;
 	u16 index, cntr;
-	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
 	if (blkaddr < 0)
-- 
2.30.2



