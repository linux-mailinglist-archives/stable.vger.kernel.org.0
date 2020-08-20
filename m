Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC44C24BE18
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgHTNU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728476AbgHTJel (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CE3E20724;
        Thu, 20 Aug 2020 09:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916081;
        bh=fB0Emn9tdUFDUbLUQKwJWZ+0+bGZg3jjzr7SbIFLdkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xIyxS1BkcdcDVeMxEiOTMagt6cA+lGVvTP3lxjpOZq9Eo9VdDeDoxDU7KUb4BbxIE
         iCbMu1vJINJnYYBWbD14+K5YaSeTdFTmRdfIU/6n9Zri2EYqFyuxO3vryn4Y8VZYuJ
         GSbBZDSRedTU93+8l7BvskrljjyduhsemYU4cfJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.8 226/232] drm/omap: force runtime PM suspend on system suspend
Date:   Thu, 20 Aug 2020 11:21:17 +0200
Message-Id: <20200820091623.729630080@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit ecfdedd7da5d54416db5ca0f851264dca8736f59 upstream.

Use SET_LATE_SYSTEM_SLEEP_PM_OPS in DSS submodules to force runtime PM
suspend and resume.

We use suspend late version so that omapdrm's system suspend callback is
called first, as that will disable all the display outputs after which
it's safe to force DSS into suspend.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200618095153.611071-1-tomi.valkeinen@ti.com
Acked-by: Tony Lindgren <tony@atomide.com>
Fixes: cef766300353 ("drm/omap: Prepare DSS for probing without legacy platform data")
Cc: stable@vger.kernel.org # v5.7+
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/omapdrm/dss/dispc.c |    1 +
 drivers/gpu/drm/omapdrm/dss/dsi.c   |    1 +
 drivers/gpu/drm/omapdrm/dss/dss.c   |    1 +
 drivers/gpu/drm/omapdrm/dss/venc.c  |    1 +
 4 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -4915,6 +4915,7 @@ static int dispc_runtime_resume(struct d
 static const struct dev_pm_ops dispc_pm_ops = {
 	.runtime_suspend = dispc_runtime_suspend,
 	.runtime_resume = dispc_runtime_resume,
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 struct platform_driver omap_dispchw_driver = {
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -5467,6 +5467,7 @@ static int dsi_runtime_resume(struct dev
 static const struct dev_pm_ops dsi_pm_ops = {
 	.runtime_suspend = dsi_runtime_suspend,
 	.runtime_resume = dsi_runtime_resume,
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 struct platform_driver omap_dsihw_driver = {
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1614,6 +1614,7 @@ static int dss_runtime_resume(struct dev
 static const struct dev_pm_ops dss_pm_ops = {
 	.runtime_suspend = dss_runtime_suspend,
 	.runtime_resume = dss_runtime_resume,
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 struct platform_driver omap_dsshw_driver = {
--- a/drivers/gpu/drm/omapdrm/dss/venc.c
+++ b/drivers/gpu/drm/omapdrm/dss/venc.c
@@ -902,6 +902,7 @@ static int venc_runtime_resume(struct de
 static const struct dev_pm_ops venc_pm_ops = {
 	.runtime_suspend = venc_runtime_suspend,
 	.runtime_resume = venc_runtime_resume,
+	SET_LATE_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend, pm_runtime_force_resume)
 };
 
 static const struct of_device_id venc_of_match[] = {


