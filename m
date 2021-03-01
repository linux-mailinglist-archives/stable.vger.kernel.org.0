Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFAC328C98
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhCASyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:53936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240677AbhCAStB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F1FE65183;
        Mon,  1 Mar 2021 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618611;
        bh=/NtNWIfCG7WbH3eGSRavY1hWp44cMgcLivxb71kLvWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEhPNIbc8hNI6NkkWUmNr3qy+PNCR2Z5MR3Lh3AGxsWihlE2Vu+N6WBoPZnHgKtyV
         r7VNHnMrpCuQnCIT8sat7sbrdzSxjlPiX59UsR8fZaE1Z4OJOFij4Q1nhI1VsT/m4p
         ALVSOaJlqRqS7yf30uN0B+DPx23ask2M4ktClQmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/663] drm: rcar-du: Fix PM reference leak in rcar_cmm_enable()
Date:   Mon,  1 Mar 2021 17:06:38 +0100
Message-Id: <20210301161149.196797056@linuxfoundation.org>
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

[ Upstream commit 136ce7684bc1ff4a088812f600c63daca50b32c2 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in a reference leak here.

A new function pm_runtime_resume_and_get is introduced in [0] to keep
usage counter balanced. So We fix the reference leak by replacing it
with new funtion.

[0] dd8088d5a896 ("PM: runtime: Add  pm_runtime_resume_and_get to deal with usage counter")

Fixes: e08e934d6c28 ("drm: rcar-du: Add support for CMM")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Acked-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rcar-du/rcar_cmm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_cmm.c b/drivers/gpu/drm/rcar-du/rcar_cmm.c
index c578095b09a53..382d53f8a22e8 100644
--- a/drivers/gpu/drm/rcar-du/rcar_cmm.c
+++ b/drivers/gpu/drm/rcar-du/rcar_cmm.c
@@ -122,7 +122,7 @@ int rcar_cmm_enable(struct platform_device *pdev)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_resume_and_get(&pdev->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.27.0



