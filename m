Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A52D2F3107
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbhALNPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404017AbhALM5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7137C23137;
        Tue, 12 Jan 2021 12:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456168;
        bh=EKV0Dyv7gFKZuV0H1Cqw919fkN1mFZ/fCQF3bI7x1zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLJeS1uvPU2UZ2cF+cV/BDmNWt+f4wPJne99pOfR0bmffCrVHx6b3OvFerGrx0TfG
         NDCaAIf6STaWQ57zTAHvGl1SrykaNElzepDoEh85WsJ3V0/W5jHZFEL70gwPdpm7iw
         9ZipKW5X/e+8pSfm2M032eOqy+2PFwYjvRzusT8cmgXfmxUMKzuNKw6KOg6046Udzl
         p+08nIWsR83+c/31UGsQVxvbzTuwLflcu6s/r6DGQWwxdO94csCcqQd/YVNqJyjUgq
         sQKdGk9T1Mq1iftVuV5iR9zFanzyv2qSw/WzsG4Ez55+/zUqCywQoT6oJcgNDCSpTV
         vuQ6vwc9eo1Rw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 25/51] habanalabs: Fix memleak in hl_device_reset
Date:   Tue, 12 Jan 2021 07:55:07 -0500
Message-Id: <20210112125534.70280-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit b000700d6db50c933ce8b661154e26cf4ad06dba ]

When kzalloc() fails, we should execute hl_mmu_fini()
to release the MMU module. It's the same when
hl_ctx_init() fails.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 783bbdcb1e618..09c328ee65da8 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1027,6 +1027,7 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 						GFP_KERNEL);
 		if (!hdev->kernel_ctx) {
 			rc = -ENOMEM;
+			hl_mmu_fini(hdev);
 			goto out_err;
 		}
 
@@ -1038,6 +1039,7 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 				"failed to init kernel ctx in hard reset\n");
 			kfree(hdev->kernel_ctx);
 			hdev->kernel_ctx = NULL;
+			hl_mmu_fini(hdev);
 			goto out_err;
 		}
 	}
-- 
2.27.0

