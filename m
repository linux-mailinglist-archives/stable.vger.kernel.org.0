Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA7A15799D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgBJNQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:32956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbgBJMiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:08 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18E1620838;
        Mon, 10 Feb 2020 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338287;
        bh=IUxzkbV4y8t9RmxGGJIIkdoyBSZBfGfzwVwqW44vYy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2H3nPJ4wLXtPDUX6gnEI9g8PEtboploBfhn2G/z2Fx1mbxN0j8/nybBeUa+5QUYai
         yJVmHUbn172d6sv11tzVI8M+M80HE4vCsFB5tIrWmaEItHYCWFnnfE/wRvLXAuZXBS
         0swcLuBBGqVY8o62qHA+PC+LSscJU5HBYVrW1tZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Boris Brezillon <bbrezillon@kernel.org>
Subject: [PATCH 5.4 186/309] drm: atmel-hlcdc: use double rate for pixel clock only if supported
Date:   Mon, 10 Feb 2020 04:32:22 -0800
Message-Id: <20200210122424.421183250@linuxfoundation.org>
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

commit 07acf4bafe81dd37eff3fbcfbbdbc48084bc202b upstream.

Doubled system clock should be used as pixel cock source only if this
is supported. This is emphasized by the value of
atmel_hlcdc_crtc::dc::desc::fixed_clksrc.

Fixes: a6eca2abdd42 ("drm: atmel-hlcdc: add config option for clock selection")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: <stable@vger.kernel.org> # v5.3+
Link: https://patchwork.freedesktop.org/patch/msgid/1576672109-22707-2-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -95,14 +95,14 @@ static void atmel_hlcdc_crtc_mode_set_no
 		     (adj->crtc_hdisplay - 1) |
 		     ((adj->crtc_vdisplay - 1) << 16));
 
+	prate = clk_get_rate(crtc->dc->hlcdc->sys_clk);
+	mode_rate = adj->crtc_clock * 1000;
 	if (!crtc->dc->desc->fixed_clksrc) {
+		prate *= 2;
 		cfg |= ATMEL_HLCDC_CLKSEL;
 		mask |= ATMEL_HLCDC_CLKSEL;
 	}
 
-	prate = 2 * clk_get_rate(crtc->dc->hlcdc->sys_clk);
-	mode_rate = adj->crtc_clock * 1000;
-
 	div = DIV_ROUND_UP(prate, mode_rate);
 	if (div < 2) {
 		div = 2;


