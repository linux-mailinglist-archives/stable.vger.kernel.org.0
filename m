Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1362C0836
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732756AbgKWMqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732754AbgKWMqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D31C02100A;
        Mon, 23 Nov 2020 12:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135593;
        bh=FcQ2lWZ8l0PQE0qMcdwtHgkU+NqMLdt8Hnpc+Nd2D28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lM6HEXK45Sj1GTyesaqVFSO2xe6DlINDaiUU4NiYgCr/j0IhD9Q3rzVK4CQQIYKJe
         uYplfaV4JSkM+R6YXo6RHbIOsBV5Har+xOmdU8WAzF3D7qkGHvG358sZg4mCXhYbUz
         xLvCK6Qbmaoys+1mpCvO6/YXFLNMGEt63I1Zz8Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Liu <net147@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 125/252] drm: bridge: dw-hdmi: Avoid resetting force in the detect function
Date:   Mon, 23 Nov 2020 13:21:15 +0100
Message-Id: <20201123121841.625268664@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Liu <net147@gmail.com>

[ Upstream commit bc551d776b691022f49b5bb5379bd58f7c4eb76a ]

It has been observed that resetting force in the detect function can
result in the PHY being powered down in response to hot-plug detect
being asserted, even when the HDMI connector is forced on.

Enabling debug messages and adding a call to dump_stack() in
dw_hdmi_phy_power_off() shows the following in dmesg:
[  160.637413] dwhdmi-rockchip ff940000.hdmi: EVENT=plugin
[  160.637433] dwhdmi-rockchip ff940000.hdmi: PHY powered down in 0 iterations

Call trace:
dw_hdmi_phy_power_off
dw_hdmi_phy_disable
dw_hdmi_update_power
dw_hdmi_detect
dw_hdmi_connector_detect
drm_helper_probe_detect_ctx
drm_helper_hpd_irq_event
dw_hdmi_irq
irq_thread_fn
irq_thread
kthread
ret_from_fork

Fixes: 381f05a7a842 ("drm: bridge/dw_hdmi: add connector mode forcing")
Signed-off-by: Jonathan Liu <net147@gmail.com>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201031081747.372599-1-net147@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 748df1cacd2b7..0c79a9ba48bb6 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -2327,12 +2327,6 @@ static enum drm_connector_status dw_hdmi_detect(struct dw_hdmi *hdmi)
 {
 	enum drm_connector_status result;
 
-	mutex_lock(&hdmi->mutex);
-	hdmi->force = DRM_FORCE_UNSPECIFIED;
-	dw_hdmi_update_power(hdmi);
-	dw_hdmi_update_phy_mask(hdmi);
-	mutex_unlock(&hdmi->mutex);
-
 	result = hdmi->phy.ops->read_hpd(hdmi, hdmi->phy.data);
 
 	mutex_lock(&hdmi->mutex);
-- 
2.27.0



