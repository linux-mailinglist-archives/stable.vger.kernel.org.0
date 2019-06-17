Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E03492F5
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbfFQVZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbfFQVZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C805820657;
        Mon, 17 Jun 2019 21:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806744;
        bh=JvB79mR2s+I88HNbw4piHuEnw9TVf9QkjAeU8oSnRNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouw92B/JXEM3pCc0Pa9ytZjdhLp7NVq/50p0xYzRCJOF9cBwjWswbEj6BiN6yJktc
         xfuQx/xJMU4xeMFYfeS8iLp01wfmOSQKsbVunOMQ0Ew6gHkhF5jf6GEN4zWqZU8eJc
         RMWGpuD8LVGW87ShmN6OKAPyple1NW9+fTLyOv5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Busch <keith.busch@intel.com>,
        David Milburn <dmilburn@redhat.com>,
        Yufen Yu <yuyufen@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 43/75] nvme: fix memory leak for power latency tolerance
Date:   Mon, 17 Jun 2019 23:09:54 +0200
Message-Id: <20190617210754.423281311@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 510a405d945bc985abc513fafe45890cac34fafa ]

Unconditionally hide device pm latency tolerance when uninitializing
the controller to ensure all qos resources are released so that we're
not leaking this memory. This is safe to call if none were allocated in
the first place, or were previously freed.

Fixes: c5552fde102fc("nvme: Enable autonomous power state transitions")
Suggested-by: Keith Busch <keith.busch@intel.com>
Tested-by: David Milburn <dmilburn@redhat.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
[changelog]
Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 818788275406..a867a139bb35 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3525,6 +3525,7 @@ EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
 void nvme_uninit_ctrl(struct nvme_ctrl *ctrl)
 {
+	dev_pm_qos_hide_latency_tolerance(ctrl->device);
 	cdev_device_del(&ctrl->cdev, ctrl->device);
 }
 EXPORT_SYMBOL_GPL(nvme_uninit_ctrl);
-- 
2.20.1



