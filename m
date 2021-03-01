Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E4C328ABE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbhCASWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:22:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239530AbhCASRA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0471B6023C;
        Mon,  1 Mar 2021 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618918;
        bh=n29llbtKpLM27QtEJf9zcU7xJDg+PLSceeVCX+ptDd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFXfBwjxi4N/QObybxMit+rU6T2C9rAoPKNlSLcmgj1BKjGnwoQGD1KJHTRLsyd3W
         nPo53UcEJnqlgoKD2XNPqjCnB6CSj7Fsnh+YBHDDO8XtlCw52xQZaYb3YLH4v02CfV
         rhSzo3IYk+xESwV5sEEmJ+8/qjYp+grY8GOnc7mo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Qiang Yu <yuq825@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/663] drm/lima: fix reference leak in lima_pm_busy
Date:   Mon,  1 Mar 2021 17:08:03 +0100
Message-Id: <20210301161153.442328349@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit de4248b744e8394f239c0dd0af34088399d27d94 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to putting operation will result in a
reference leak here.

A new function pm_runtime_resume_and_get is introduced in
[0] to keep usage counter balanced. So We fix the reference
leak by replacing it with new function.

[0] commit dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal with usage counter")

Fixes: 50de2e9ebbc0 ("drm/lima: enable runtime pm")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201127094438.121003-1-miaoqinglang@huawei.com
(cherry picked from commit de499781c97d96703af8a32d2b5e37fdb5b51568)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/lima/lima_sched.c b/drivers/gpu/drm/lima/lima_sched.c
index dc6df9e9a40d8..f6e7a88a56f1b 100644
--- a/drivers/gpu/drm/lima/lima_sched.c
+++ b/drivers/gpu/drm/lima/lima_sched.c
@@ -200,7 +200,7 @@ static int lima_pm_busy(struct lima_device *ldev)
 	int ret;
 
 	/* resume GPU if it has been suspended by runtime PM */
-	ret = pm_runtime_get_sync(ldev->dev);
+	ret = pm_runtime_resume_and_get(ldev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.27.0



