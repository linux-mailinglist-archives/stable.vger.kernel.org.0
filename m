Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D5328CFD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240956AbhCATDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:03:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240732AbhCAS4f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:56:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A21CF60231;
        Mon,  1 Mar 2021 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620784;
        bh=4ruyj+OxNmR7V31Jk/Y0KVng6tnvHvbE+Bfdtt5Ra48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEykEUqPFdXNcZjvYoCSM2K5JfJANtd9Csk/SdiZPLiwk15DkSvns6PluoihKsAbZ
         Q6o2D1r3CUqXOEUR4AKay+GIADLYGavTKkHieS7x013LZHnnHL+x3uJ0IMDaAYCVP7
         gFVNDNLeL7VHepA5hn0uJ5FFY1NqWYYhX7oNPLjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Qiang Yu <yuq825@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 279/775] drm/lima: fix reference leak in lima_pm_busy
Date:   Mon,  1 Mar 2021 17:07:27 +0100
Message-Id: <20210301161215.415412361@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 63b4c5643f9cd..5cc20b403a252 100644
--- a/drivers/gpu/drm/lima/lima_sched.c
+++ b/drivers/gpu/drm/lima/lima_sched.c
@@ -201,7 +201,7 @@ static int lima_pm_busy(struct lima_device *ldev)
 	int ret;
 
 	/* resume GPU if it has been suspended by runtime PM */
-	ret = pm_runtime_get_sync(ldev->dev);
+	ret = pm_runtime_resume_and_get(ldev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.27.0



