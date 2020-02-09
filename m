Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A061156A5B
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBINCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:02:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43623 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727473AbgBINCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:02:38 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 78EA4215B2;
        Sun,  9 Feb 2020 08:02:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:02:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=WHs5H3
        Di4nERZVWhsMIZ8hW9Ffj6c1S+olPIDlNdiZE=; b=SfI2Z9JEo3RC/fL82eGu8i
        D6UIHfWaLveYdYwjgVW4eqWWFrlfH1SsH2De+bSu+0HjyiV6Rwynleiz7CWE/8tq
        FalhKsGNyolhHm3aR1Y46pxQds7CYXrGpu209Vw+jtAE/vjDA7b9AzyxG9/dzdwe
        YuoFmAIafhH0dKtwXlZFUZDHM61aoJ3y4wxzAP2Hm0vSs94gk2GjC2mNzzZKYl/J
        9X0azsA48w+MCl573R7hUrPrEpIiNbWNa6IKAKaKHUzVkmKOnCiH0YarGgmTCaos
        mPtoncmoA26QetkvC75w16rkopXMi50HbJQdVnXfWGg6RQ4hr5vH/b+WzqwFK2BQ
        ==
X-ME-Sender: <xms:7gJAXnPNgAtwRL3lbx7AN7eTwVBMvOJcsixCfX0SH2C4Ou78dJaQBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepfeekrdelke
    drfeejrddufeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7gJAXrkDU4Q-rRBgMSrewQw6PhJbGELZlSQtEKyutGcGuN24nymylw>
    <xmx:7gJAXi-fAFkxCSgs60IoO1eEen2VUXlU2MHTV18qON29a_gjg_ZI4w>
    <xmx:7gJAXtPAzDhTdcixocqITQewiigZb4U7U6F4JsIAvO5DIpVD-E_DgQ>
    <xmx:7gJAXsZ_wIW5ZznVO5Rm4LtaYSE3MAY1Nedv-_8OsCqlowSY6963lg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE2E7328005A;
        Sun,  9 Feb 2020 08:02:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm: atmel-hlcdc: enable clock before configuring timing" failed to apply to 4.19-stable tree
To:     claudiu.beznea@microchip.com, boris.brezillon@free-electrons.com,
        sam@ravnborg.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 12:40:20 +0100
Message-ID: <158124842070142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

