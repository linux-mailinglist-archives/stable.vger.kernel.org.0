Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61E333E41D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhCQA6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhCQA5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09D064FCF;
        Wed, 17 Mar 2021 00:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942656;
        bh=/SitrvpyUyCwRki7AuWdCq+gcKpng8J8SHWwEbrfjJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZ6QUDB9WOPuN2l7+eCFehhTWQ7Ll0xLN1p1E1BsAczOM0VGLLmPuUoVUxql2IehN
         2FARxgwbHTd6XAv/fbryJo9yui4gbAbrCxTkiXS0xb67gWQYySxTrAsVgt7u47Q3jM
         SWTLozlEKjenoJxvGKrtgnuFID39oair7sPzHmaj1QSQWMvE+HiawwIEP+E3jo4tmH
         9qFUuLXKIQ5wGE6xQUWMiFBSawa5tW36fsnhx8Ke+VkFoQY5YVRn1oFdZEiOHfoxdh
         Jkommr3CvWoXKsdU5z27srP3w+LA0j3KQuJtKDwY5Wp2z4mTMIclxStp+5uv+Nk5F2
         /VwWzRY0vOJiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomer Tayar <ttayar@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 34/54] habanalabs: Call put_pid() when releasing control device
Date:   Tue, 16 Mar 2021 20:56:33 -0400
Message-Id: <20210317005654.724862-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 71b3a4d5adc6..7b0bf470795c 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -106,6 +106,8 @@ static int hl_device_release_ctrl(struct inode *inode, struct file *filp)
 	list_del(&hpriv->dev_node);
 	mutex_unlock(&hdev->fpriv_list_lock);
 
+	put_pid(hpriv->taskpid);
+
 	kfree(hpriv);
 
 	return 0;
-- 
2.30.1

