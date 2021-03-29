Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80C34C8E7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhC2IYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234204AbhC2IX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 483D0619C4;
        Mon, 29 Mar 2021 08:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006235;
        bh=Hw9A6Psap29M1k2WTByEluXpzjwHWq9t16vzcJNwzyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqfZYiZH4OyfUM9GuEDVqJNHIK6xWB0TsKPn+X+kbEIaO0pSpBipHTixRC6RYHwBa
         AReOpl7hCW1GxV6hfe1JrHieGpL23vvO6fCXJOQIlX25AlyYOgIlPOz2LUA/Xhfj7K
         4r/oGJwyF42L+nnPSd9rWArF+Kelq/GvVQ9mQ818=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/221] drm/msm: Fix suspend/resume on i.MX5
Date:   Mon, 29 Mar 2021 09:58:18 +0200
Message-Id: <20210329075634.718810265@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit a9748134ea4aad989e52a6a91479e0acfd306e5b ]

When putting iMX5 into suspend, the following flow is
observed:

[   70.023427] [<c07755f0>] (msm_atomic_commit_tail) from [<c06e7218>]
(commit_tail+0x9c/0x18c)
[   70.031890] [<c06e7218>] (commit_tail) from [<c0e2920c>]
(drm_atomic_helper_commit+0x1a0/0x1d4)
[   70.040627] [<c0e2920c>] (drm_atomic_helper_commit) from
[<c06e74d4>] (drm_atomic_helper_disable_all+0x1c4/0x1d4)
[   70.050913] [<c06e74d4>] (drm_atomic_helper_disable_all) from
[<c0e2943c>] (drm_atomic_helper_suspend+0xb8/0x170)
[   70.061198] [<c0e2943c>] (drm_atomic_helper_suspend) from
[<c06e84bc>] (drm_mode_config_helper_suspend+0x24/0x58)

In the i.MX5 case, priv->kms is not populated (as i.MX5 does not use any
of the Qualcomm display controllers), causing a NULL pointer
dereference in msm_atomic_commit_tail():

[   24.268964] 8<--- cut here ---
[   24.274602] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   24.283434] pgd = (ptrval)
[   24.286387] [00000000] *pgd=ca212831
[   24.290788] Internal error: Oops: 17 [#1] SMP ARM
[   24.295609] Modules linked in:
[   24.298777] CPU: 0 PID: 197 Comm: init Not tainted 5.11.0-rc2-next-20210111 #333
[   24.306276] Hardware name: Freescale i.MX53 (Device Tree Support)
[   24.312442] PC is at msm_atomic_commit_tail+0x54/0xb9c
[   24.317743] LR is at commit_tail+0xa4/0x1b0

Fix the problem by calling drm_mode_config_helper_suspend/resume()
only when priv->kms is available.

Fixes: ca8199f13498 ("drm/msm/dpu: ensure device suspend happens during PM sleep")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 45e325c982c2..b38ebccad42f 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -1079,6 +1079,10 @@ static int __maybe_unused msm_pm_resume(struct device *dev)
 static int __maybe_unused msm_pm_prepare(struct device *dev)
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
+	struct msm_drm_private *priv = ddev ? ddev->dev_private : NULL;
+
+	if (!priv || !priv->kms)
+		return 0;
 
 	return drm_mode_config_helper_suspend(ddev);
 }
@@ -1086,6 +1090,10 @@ static int __maybe_unused msm_pm_prepare(struct device *dev)
 static void __maybe_unused msm_pm_complete(struct device *dev)
 {
 	struct drm_device *ddev = dev_get_drvdata(dev);
+	struct msm_drm_private *priv = ddev ? ddev->dev_private : NULL;
+
+	if (!priv || !priv->kms)
+		return;
 
 	drm_mode_config_helper_resume(ddev);
 }
-- 
2.30.1



