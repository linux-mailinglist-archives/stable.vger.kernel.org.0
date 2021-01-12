Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF94D2F30D6
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbhALNL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404377AbhALM6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 372D02311E;
        Tue, 12 Jan 2021 12:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456221;
        bh=4EXJ9FjI9Q58WkL4jW9JUC85Feb9KFA1cmbxyhtMWzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tRCpp8vD/YcJUoVArIJb/UYsK2fFylz3qyc+Fv8jui2XBBun/fR7zBt+DzGqHgy1+
         24TEXV31kVr0On3vHB/Ge0M8+eVRo3jDLhNpoQ2YIdJllyXLlVEpRi5qAEA9QP63r/
         0ZOmthEo7VbGGEyUNItgtbWLs3n/A6zhMRJILeyXNz+a8vpUMxd0kGdoTEQPNUwYkt
         H1mD9BBpaVUDYVl1DMkCsMS/6lwTp6y0tNyL9yjerU24bNiDmqmV9gaBSpIJwi3GO1
         DiQqGzWyRjdPBfwj7q7awEnisL0M6Z3w1n/HgLx3otYXYvETKlCTKblnB7aoFh69uT
         b/2/4pxrQywcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 12/28] habanalabs: Fix memleak in hl_device_reset
Date:   Tue, 12 Jan 2021 07:56:28 -0500
Message-Id: <20210112125645.70739-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
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
 drivers/misc/habanalabs/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index 3eeb1920ddb43..3486bf33474d9 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -959,6 +959,7 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 						GFP_KERNEL);
 		if (!hdev->kernel_ctx) {
 			rc = -ENOMEM;
+			hl_mmu_fini(hdev);
 			goto out_err;
 		}
 
@@ -970,6 +971,7 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 				"failed to init kernel ctx in hard reset\n");
 			kfree(hdev->kernel_ctx);
 			hdev->kernel_ctx = NULL;
+			hl_mmu_fini(hdev);
 			goto out_err;
 		}
 	}
-- 
2.27.0

