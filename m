Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9867C33E378
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCQA4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230398AbhCQA4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585DF64FB1;
        Wed, 17 Mar 2021 00:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942578;
        bh=aHHX94pO+/nv5v+FslfTPdu/pYAxmkK4mU+H8BMjvnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPIIZ6NYlP+pefbatH32XXrR8Ccd+dOd61mHFy7XVy8cliTsyUC6v3OFpbsn7XWK+
         TS84OGze8Fi2QfbEnubMtlskEH1yEA0jIEdNgpqefv8yaXkBRns+fU78UbHXF3kRVU
         AY0cbwXO2ceZArHlbX5SsPa8QKpe+yXl16mIkJ/a2Q3u74GYeFZd+nt1AQnB/1KI7y
         PlcOfXMFI4OpyRY6GiHoEikCeojih4HnSsknkEdRcRThY0eauZ3oTc2+R5bLJn9QsG
         Yv/bWWdUunev1VmvmBjD8o1WScTZvwahwCS4jTCd+HDsSgA0gAvuj/VwfRINFBzd+3
         eDsCflVLVvcfg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomer Tayar <ttayar@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 35/61] habanalabs: Call put_pid() when releasing control device
Date:   Tue, 16 Mar 2021 20:55:09 -0400
Message-Id: <20210317005536.724046-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
 drivers/misc/habanalabs/common/device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 69d04eca767f..6785329eee27 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -117,6 +117,8 @@ static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
 	list_del(&hpriv->dev_node);
 	mutex_unlock(&hdev->fpriv_list_lock);
 
+	put_pid(hpriv->taskpid);
+
 	kfree(hpriv);
 
 	return 0;
-- 
2.30.1

