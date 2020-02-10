Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E510815799E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgBJNQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:32978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgBJMiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:08 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A9A2173E;
        Mon, 10 Feb 2020 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338287;
        bh=rVtizd47pPRclKqUkCqje4zkgi1bBzaeodtlgmwOJag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQyJWtsXotalRJfBcDBbATiwXk33SbPXYS05BOuH8hf2G/APlt7kNZpIFdV4mx//u
         oTNNXjrms6f2fSXhQFcJYT4ztKAm/9xxBsPpEXtj8+OPZ1uj8xvvrOE9TmE4kpXoSH
         C5lOPyfPQdksDG++b4UXd2Wr3nF84o1nOIzd1RhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 5.4 187/309] drm: atmel-hlcdc: enable clock before configuring timing engine
Date:   Mon, 10 Feb 2020 04:32:23 -0800
Message-Id: <20200210122424.517724468@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit 2c1fb9d86f6820abbfaa38a6836157c76ccb4e7b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -73,7 +73,11 @@ static void atmel_hlcdc_crtc_mode_set_no
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
@@ -147,6 +151,8 @@ static void atmel_hlcdc_crtc_mode_set_no
 			   ATMEL_HLCDC_VSPSU | ATMEL_HLCDC_VSPHO |
 			   ATMEL_HLCDC_GUARDTIME_MASK | ATMEL_HLCDC_MODE_MASK,
 			   cfg);
+
+	clk_disable_unprepare(crtc->dc->hlcdc->sys_clk);
 }
 
 static enum drm_mode_status


