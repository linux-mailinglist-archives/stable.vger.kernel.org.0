Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3372FA2D1
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392909AbhAROUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390634AbhARLot (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9E0A22EBF;
        Mon, 18 Jan 2021 11:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970262;
        bh=1UwYPHIN+XsqkoL8HpXjhfR+u7ZkRRf92QTTfBQRS+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2NYUcjSYPe5fcFohc/g4MA6PwdN/Qm7hrjyPtfYqiuV213wrWzforjNezsojcs2B
         Y9t24/cA7HxyaeNaFPAyqTcwu09weP2sQA9QNg0TUzk95HKWHR/hEBqluFrrQkl7Z1
         /r+Iav5iot1datSpTKdl/hCf8s1tDqaKjGp+L5s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/152] habanalabs: Fix memleak in hl_device_reset
Date:   Mon, 18 Jan 2021 12:34:09 +0100
Message-Id: <20210118113356.338421524@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1027,6 +1027,7 @@ again:
 						GFP_KERNEL);
 		if (!hdev->kernel_ctx) {
 			rc = -ENOMEM;
+			hl_mmu_fini(hdev);
 			goto out_err;
 		}
 
@@ -1038,6 +1039,7 @@ again:
 				"failed to init kernel ctx in hard reset\n");
 			kfree(hdev->kernel_ctx);
 			hdev->kernel_ctx = NULL;
+			hl_mmu_fini(hdev);
 			goto out_err;
 		}
 	}
-- 
2.27.0



