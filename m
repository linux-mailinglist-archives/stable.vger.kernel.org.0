Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B363F46375D
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbhK3OxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57400 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242555AbhK3Ow3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5D8ECE1A5B;
        Tue, 30 Nov 2021 14:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B67C53FD1;
        Tue, 30 Nov 2021 14:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283744;
        bh=lT/20zaKCiSCBeJ0jORGKZ/l29y9w6y6dHCRyITHpLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bhvGJRf4gsOcv65vZ5fGH8Camyg2HCVYfWGq3QhvUGASa1rlXiVWg0m2oaPV2FlmM
         DpKnXUZradXm4lmju0s7+nwM56EMe3qhPSGQdgHbA+haxbAl8Iu2ur8kpdx5XCGQ4V
         zwEl3YMgTSRFR6d1XPZNjn1XAVEYv/pJJcN2D33C/djivUQyQurs8aADih2NUXhIG5
         0RgdkWhvkn9lUvuGhEF7Li9DyScXwa+p+/gNGglCtnACFetEtgWIKHkydIxJWWZs8s
         NLaOjJvuAgzePLXW3UOQjxSJ05MMRYBcaV31/O9lus+NpV17KSp7vD/WTelAydbeYr
         jcvLzTFBCMimA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Klaus Jensen <k.jensen@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kbusch@kernel.org,
        axboe@fb.com, sagi@grimberg.me, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 47/68] nvme: fix write zeroes pi
Date:   Tue, 30 Nov 2021 09:46:43 -0500
Message-Id: <20211130144707.944580-47-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
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
index 4ff75d7031110..cb795f99f0fcd 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -898,10 +898,19 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
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

