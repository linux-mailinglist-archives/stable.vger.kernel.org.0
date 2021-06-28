Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E903B60DF
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbhF1Oa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234452AbhF1O3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:29:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A88FF61C89;
        Mon, 28 Jun 2021 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890384;
        bh=dVflfAwi5EQseM4d4kfWeseILZiSu0k+TLU/U3ydB1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPThcgADt4PAo9Td8EcMrYCUQtDO7z1hmScTmWXnRsho60Pavovosp3Mv87XLqizd
         OXBQk8zM6WEWPTXoLPoWSfNaY4uYQdq+j+tJJx1QxhovoXKnfJJwhgiVOd8t2CclNe
         d70758MYiX+gjczyGkETjaR/op+DsbQkxVTWnjNLupqRcE1X7i9lOTVtt2zWvJCRlj
         4GXQSmMuc7uJ5RYjDFN8fsblPwj7n0HB5nGB7jv6slVGGDn8Ng0BSXLwUdLe3mTXCD
         S8xvT+wcFv0/LgOb5yJZp8nCIZln8xyhzf/yExj7Of6Mjwlv1Xj6XO9BfvLh9Ze27q
         NOCHkw3SmMRlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/101] drm/vc4: hdmi: Make sure the controller is powered in detect
Date:   Mon, 28 Jun 2021 10:24:42 -0400
Message-Id: <20210628142607.32218-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.47-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.47-rc1
X-KernelTest-Deadline: 2021-06-30T14:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 9984d6664ce9dcbbc713962539eaf7636ea246c2 ]

If the HPD GPIO is not available and drm_probe_ddc fails, we end up
reading the HDMI_HOTPLUG register, but the controller might be powered
off resulting in a CPU hang. Make sure we have the power domain and the
HSM clock powered during the detect cycle to prevent the hang from
happening.

Fixes: 4f6e3d66ac52 ("drm/vc4: Add runtime PM support to the HDMI encoder driver")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210525091059.234116-4-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 5978e99a0e85..88a8cb840cd5 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -146,6 +146,8 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 	struct vc4_hdmi *vc4_hdmi = connector_to_vc4_hdmi(connector);
 	bool connected = false;
 
+	WARN_ON(pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev));
+
 	if (vc4_hdmi->hpd_gpio) {
 		if (gpio_get_value_cansleep(vc4_hdmi->hpd_gpio) ^
 		    vc4_hdmi->hpd_active_low)
@@ -167,10 +169,12 @@ vc4_hdmi_connector_detect(struct drm_connector *connector, bool force)
 			}
 		}
 
+		pm_runtime_put(&vc4_hdmi->pdev->dev);
 		return connector_status_connected;
 	}
 
 	cec_phys_addr_invalidate(vc4_hdmi->cec_adap);
+	pm_runtime_put(&vc4_hdmi->pdev->dev);
 	return connector_status_disconnected;
 }
 
-- 
2.30.2

