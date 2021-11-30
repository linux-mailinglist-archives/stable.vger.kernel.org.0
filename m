Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA62463895
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 16:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbhK3PFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 10:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243777AbhK3O6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:58:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF4C06139C;
        Tue, 30 Nov 2021 06:51:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8E80CE1A58;
        Tue, 30 Nov 2021 14:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C81C53FCD;
        Tue, 30 Nov 2021 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283893;
        bh=71CGjOfUIb3TjUWIc4RjZNQ40Lhywk3KLg33jW+fqjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWU5Qq+6+BdZ6fIpgGAECSYY4Tqpl2tFeYIw34hs2nd7IlH8N1CShwcCDEKf5J5Vy
         iL10V7Cxc4qRJexqrSCqsbDwYLyry8DXA1BABy45Nvt4l786uhxkLAnkT8Cs854hda
         z5tI6Ogxl+o3ySAeklWQ8/xHtaA8Sxjg2aIjqLCr4QRMAbklBdxdLEXIxI9MIp5OIR
         I0lxywa8m8wRCsBswx9MjIK//f5bVyW3jVp1dwteZr95+7c9eiI8WrpAzcTLIYqHyV
         aJJ/M3pyZd2VyB/QOmMlzaLAjAtdUhuVYOb8vzKw5DvdFVVpzCVWRgcfVlbaeIYCB4
         fkBrB8byi3ttg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Klaus Jensen <k.jensen@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 33/43] nvme: fix write zeroes pi
Date:   Tue, 30 Nov 2021 09:50:10 -0500
Message-Id: <20211130145022.945517-33-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Klaus Jensen <k.jensen@samsung.com>

[ Upstream commit 00b33cf3da726757aef636365bb52e9536434e9a ]

Write Zeroes sets PRACT when block integrity is enabled (as it should),
but neglects to also set the reftag which is expected by reads. This
causes protection errors on reads.

Fix this by setting the reftag for type 1 and 2 (for type 3, reads will
not check the reftag).

Signed-off-by: Klaus Jensen <k.jensen@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c76f3a7fb1d18..9b57a9db8f1dc 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -750,10 +750,19 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 		cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
 	cmnd->write_zeroes.length =
 		cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
-	if (nvme_ns_has_pi(ns))
+
+	if (nvme_ns_has_pi(ns)) {
 		cmnd->write_zeroes.control = cpu_to_le16(NVME_RW_PRINFO_PRACT);
-	else
-		cmnd->write_zeroes.control = 0;
+
+		switch (ns->pi_type) {
+		case NVME_NS_DPS_PI_TYPE1:
+		case NVME_NS_DPS_PI_TYPE2:
+			cmnd->write_zeroes.reftag =
+				cpu_to_le32(t10_pi_ref_tag(req));
+			break;
+		}
+	}
+
 	return BLK_STS_OK;
 }
 
-- 
2.33.0

