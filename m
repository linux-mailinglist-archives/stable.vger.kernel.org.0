Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAAA33E492
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhCQBAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231721AbhCQA6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4197A64FEA;
        Wed, 17 Mar 2021 00:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942713;
        bh=ItLjE4viB/f14ALVxn9paBIewkdAwI3h4BY5cpp8Z6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVTsR+2W6UJf1bLSjdMAAmmINr9oIeiPYLH4GqEJPXApDQsfPPqSOqUavpwwVtN5V
         mFEJzKMAj0+t0aPix/nCQvYHzsfKkVSqzNmjzhNr3tAC6DFhFAOgRkbcuCyrZfkm5E
         nasS3EKRFtEezVwvbClzOcVMlE4Kq2MbY1BT1NoWJnNN/84kFPKr7p9jT8XpyipTQX
         gB9g6wiR1UvxuHY/VqFLEG0Dka19Z2l4FsuxsANwJktXYHbypmn9tE+XKhyhBWi3fC
         M1JszI12zv6RkENn5GDCjf0kFw5C7WNAm9EwSClc6S055PZLF+GmSPw2zvDG93+fkd
         kwPzqaBFGDG9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomer Tayar <ttayar@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 25/37] habanalabs: Call put_pid() when releasing control device
Date:   Tue, 16 Mar 2021 20:57:50 -0400
Message-Id: <20210317005802.725825-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomer Tayar <ttayar@habana.ai>

[ Upstream commit 27ac5aada024e0821c86540ad18f37edadd77d5e ]

The refcount of the "hl_fpriv" structure is not used for the control
device, and thus hl_hpriv_put() is not called when releasing this
device.
This results with no call to put_pid(), so add it explicitly in
hl_device_release_ctrl().

Signed-off-by: Tomer Tayar <ttayar@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/device.c b/drivers/misc/habanalabs/device.c
index 3486bf33474d..e3d943c65419 100644
--- a/drivers/misc/habanalabs/device.c
+++ b/drivers/misc/habanalabs/device.c
@@ -108,6 +108,8 @@ static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
 	list_del(&hpriv->dev_node);
 	mutex_unlock(&hdev->fpriv_list_lock);
 
+	put_pid(hpriv->taskpid);
+
 	kfree(hpriv);
 
 	return 0;
-- 
2.30.1

