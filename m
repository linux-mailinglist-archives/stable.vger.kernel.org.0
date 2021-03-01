Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D323328CB5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbhCAS5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240262AbhCASwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:52:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A46165020;
        Mon,  1 Mar 2021 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618690;
        bh=PWJ54Uk4uGUCkuj+jIZEmnf9py+5Bl4YScHXZfJPdP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13f9qeQbE/Y+kTFyTWMW8+xB5LRT+3fQfE2co1kaF1OdvqNIgLZN4voX7HdeE9hDw
         NkqFcj10nd8QnesZzLCpEH1QMR7PW+RzgfMdK3KCsshPNs198huJp3fmq/Ah9dAz8U
         dPnvlKKe9L+ojKVZgVcRs23XQHqUJVWfHdfVIFlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/663] drm/tegra: Fix reference leak when pm_runtime_get_sync() fails
Date:   Mon,  1 Mar 2021 17:07:09 +0100
Message-Id: <20210301161150.730567406@linuxfoundation.org>
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

[ Upstream commit dcdfe2712b68f1e9dbf4f1a96ad59b80e5cc0ef7 ]

The PM reference count is not expected to be incremented on return in
these Tegra functions.

However, pm_runtime_get_sync() will increment the PM reference count
even on failure. Forgetting to put the reference again will result in
a leak.

Replace it with pm_runtime_resume_and_get() to keep the usage counter
balanced.

Fixes: fd67e9c6ed5a ("drm/tegra: Do not implement runtime PM")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tegra/dc.c   | 2 +-
 drivers/gpu/drm/tegra/dsi.c  | 2 +-
 drivers/gpu/drm/tegra/hdmi.c | 2 +-
 drivers/gpu/drm/tegra/hub.c  | 2 +-
 drivers/gpu/drm/tegra/sor.c  | 2 +-
 drivers/gpu/drm/tegra/vic.c  | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 424ad60b4f388..b2c8c68b7e261 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -2184,7 +2184,7 @@ static int tegra_dc_runtime_resume(struct host1x_client *client)
 	struct device *dev = client->dev;
 	int err;
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get runtime PM: %d\n", err);
 		return err;
diff --git a/drivers/gpu/drm/tegra/dsi.c b/drivers/gpu/drm/tegra/dsi.c
index 5691ef1b0e586..f46d377f0c304 100644
--- a/drivers/gpu/drm/tegra/dsi.c
+++ b/drivers/gpu/drm/tegra/dsi.c
@@ -1111,7 +1111,7 @@ static int tegra_dsi_runtime_resume(struct host1x_client *client)
 	struct device *dev = client->dev;
 	int err;
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get runtime PM: %d\n", err);
 		return err;
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index d09a24931c87c..e5d2a40260288 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1510,7 +1510,7 @@ static int tegra_hdmi_runtime_resume(struct host1x_client *client)
 	struct device *dev = client->dev;
 	int err;
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get runtime PM: %d\n", err);
 		return err;
diff --git a/drivers/gpu/drm/tegra/hub.c b/drivers/gpu/drm/tegra/hub.c
index 22a03f7ffdc12..5ce771cba1335 100644
--- a/drivers/gpu/drm/tegra/hub.c
+++ b/drivers/gpu/drm/tegra/hub.c
@@ -789,7 +789,7 @@ static int tegra_display_hub_runtime_resume(struct host1x_client *client)
 	unsigned int i;
 	int err;
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get runtime PM: %d\n", err);
 		return err;
diff --git a/drivers/gpu/drm/tegra/sor.c b/drivers/gpu/drm/tegra/sor.c
index cc2aa2308a515..f02a035dda453 100644
--- a/drivers/gpu/drm/tegra/sor.c
+++ b/drivers/gpu/drm/tegra/sor.c
@@ -3218,7 +3218,7 @@ static int tegra_sor_runtime_resume(struct host1x_client *client)
 	struct device *dev = client->dev;
 	int err;
 
-	err = pm_runtime_get_sync(dev);
+	err = pm_runtime_resume_and_get(dev);
 	if (err < 0) {
 		dev_err(dev, "failed to get runtime PM: %d\n", err);
 		return err;
diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index ade56b860cf9d..b77f726303d89 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -314,7 +314,7 @@ static int vic_open_channel(struct tegra_drm_client *client,
 	struct vic *vic = to_vic(client);
 	int err;
 
-	err = pm_runtime_get_sync(vic->dev);
+	err = pm_runtime_resume_and_get(vic->dev);
 	if (err < 0)
 		return err;
 
-- 
2.27.0



