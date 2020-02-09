Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CED6156A5F
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgBINDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:03:11 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52563 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727340AbgBINDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:03:10 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4AFD721B34;
        Sun,  9 Feb 2020 08:03:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:03:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XzsFbl
        B2zM7Z8/WiAdLjiTK7m7vqzM+d5DLmMz1PO4s=; b=RI23FNBOW3e0IrScwf9Ml3
        tePZE1oZhzKCUOZHq8JwR2bm4C4z1lLnr1O/sayO1Z2Os+Ha90m599tNMiybn25Q
        +9024FdYyQd1o2PWGT72DaX47EVlTjhxYtZ00oYSMvfUcrFPJeuAujAbm1oErkhY
        SJjLMw4xlecUUhVNJI+2kVRALwc+EtAcpNYdRaZXopgnZlah0GD76C4oedR9dcBv
        ZMAGXwF03bHJkNmidpbzisSNHqOKWrFufUECR9xG1Kl2JCDwSn/oXEx5+db75D8x
        EQ3Bs/MTPfOjrUMd6OYRgnFiEg4RGtP02Az9pHelX21T2CxzFuN+VT6CjlckdK6Q
        ==
X-ME-Sender: <xms:DgNAXmAPHEijrdjFQzZa1C24OCKu71fFdvQ3Ur4cv-0YZuZ_Yq4afg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepfeekrdelke
    drfeejrddufeehnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DgNAXkzBZ_caN8ou-LwXUAJ1JLPIln9waKrRqz5AP_yfKWAOEGMJCw>
    <xmx:DgNAXkmCkmrNJYjk-O7Vr4j--ODeMvvzG6EEj1HXAu_kaFzywECZmA>
    <xmx:DgNAXpEYunnHKAXlw1fwh8s1x7uTp41qititTTuOusbbCMhG2xD4sA>
    <xmx:DgNAXiRUA2_YZuj-MtNUGHFkwaXQVVJNeb19s5RY3PReu5hk3iaSTw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED53730606E9;
        Sun,  9 Feb 2020 08:03:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm: atmel-hlcdc: enable clock before configuring timing" failed to apply to 4.4-stable tree
To:     claudiu.beznea@microchip.com, boris.brezillon@free-electrons.com,
        sam@ravnborg.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:40:24 +0100
Message-ID: <158124842416260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c1fb9d86f6820abbfaa38a6836157c76ccb4e7b Mon Sep 17 00:00:00 2001
From: Claudiu Beznea <claudiu.beznea@microchip.com>
Date: Wed, 18 Dec 2019 14:28:25 +0200
Subject: [PATCH] drm: atmel-hlcdc: enable clock before configuring timing
 engine

Changing pixel clock source without having this clock source enabled
will block the timing engine and the next operations after (in this case
setting ATMEL_HLCDC_CFG(5) settings in atmel_hlcdc_crtc_mode_set_nofb()
will fail). It is recomended (although in datasheet this is not present)
to actually enabled pixel clock source before doing any changes on timing
enginge (only SAM9X60 datasheet specifies that the peripheral clock and
pixel clock must be enabled before using LCD controller).

Fixes: 1a396789f65a ("drm: add Atmel HLCDC Display Controller support")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: <stable@vger.kernel.org> # v4.0+
Link: https://patchwork.freedesktop.org/patch/msgid/1576672109-22707-3-git-send-email-claudiu.beznea@microchip.com

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
index 5040ed8d0871..721fa88bf71d 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -73,7 +73,11 @@ static void atmel_hlcdc_crtc_mode_set_nofb(struct drm_crtc *c)
 	unsigned long prate;
 	unsigned int mask = ATMEL_HLCDC_CLKDIV_MASK | ATMEL_HLCDC_CLKPOL;
 	unsigned int cfg = 0;
-	int div;
+	int div, ret;
+
+	ret = clk_prepare_enable(crtc->dc->hlcdc->sys_clk);
+	if (ret)
+		return;
 
 	vm.vfront_porch = adj->crtc_vsync_start - adj->crtc_vdisplay;
 	vm.vback_porch = adj->crtc_vtotal - adj->crtc_vsync_end;
@@ -147,6 +151,8 @@ static void atmel_hlcdc_crtc_mode_set_nofb(struct drm_crtc *c)
 			   ATMEL_HLCDC_VSPSU | ATMEL_HLCDC_VSPHO |
 			   ATMEL_HLCDC_GUARDTIME_MASK | ATMEL_HLCDC_MODE_MASK,
 			   cfg);
+
+	clk_disable_unprepare(crtc->dc->hlcdc->sys_clk);
 }
 
 static enum drm_mode_status

