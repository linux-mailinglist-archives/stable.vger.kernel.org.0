Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA293353F6
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfFDX3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:29:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727499AbfFDXYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:24:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C346920863;
        Tue,  4 Jun 2019 23:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690648;
        bh=rRUFUgu6RWhpeSUjD5nxuxTr0jklZ0IlhGg0Xfzv4SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agG2kUwNmsBbYORsbRMYbACzTQu1ZC6NKZ5qu9nPEX8lrNa1ut0ERNMVoLLsKx1jg
         36lrac/qG3r74xERzF8e9QxPTUIdkvBr5uKUQSq3mnonFTThs6KNrxqLSOtJLvCjOF
         MH5Yb7xAS8g1mlMVTBI9a/hafwAOcsJrlFf/xlRQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yufen Yu <yuyufen@huawei.com>, Keith Busch <keith.busch@intel.com>,
        David Milburn <dmilburn@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 21/36] nvme: fix memory leak for power latency tolerance
Date:   Tue,  4 Jun 2019 19:23:16 -0400
Message-Id: <20190604232333.7185-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232333.7185-1-sashal@kernel.org>
References: <20190604232333.7185-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yufen Yu <yuyufen@huawei.com>

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

