Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84DAC157996
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgBJNQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbgBJMiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:08 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B57C24650;
        Mon, 10 Feb 2020 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338288;
        bh=XPfElYvjqyDIFhV1HdPIJGkgIMrVb2nmpoZao//rNLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x48TH3YcHyBgOLgIp3sp+y5sa31KvDQwLwA8lKi8pcZzaOCrMNxyCwRV6kkx5t2Fj
         ntjV8/4YgNohLqxWHZwJDSgZEW71XReOxk77RJUeq+ltiDXMsS0Di/Y1u7tnOSueTy
         G/Xs+RvqTe7vkX99PhJ5Ntofv6WXk96Pvu2FY8PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Boris Brezillon <boris.brezillon@bootlin.com>
Subject: [PATCH 5.4 188/309] drm: atmel-hlcdc: prefer a lower pixel-clock than requested
Date:   Mon, 10 Feb 2020 04:32:24 -0800
Message-Id: <20200210122424.617878149@linuxfoundation.org>
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

From: Peter Rosin <peda@axentia.se>

commit 51a19d150b520f6cb42143f3bdffacd3c33d7ac5 upstream.

The intention was to only select a higher pixel-clock rate than the
requested, if a slight overclocking would result in a rate significantly
closer to the requested rate than if the conservative lower pixel-clock
rate is selected. The fixed patch has the logic the other way around and
actually prefers the higher frequency. Fix that.

Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Fixes: 9946a3a9dbed ("drm/atmel-hlcdc: allow selecting a higher pixel-clock than requested")
Reported-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Tested-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: Boris Brezillon <boris.brezillon@bootlin.com>
Cc: <stable@vger.kernel.org> # v4.20+
Link: https://patchwork.freedesktop.org/patch/msgid/1576672109-22707-6-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -121,8 +121,8 @@ static void atmel_hlcdc_crtc_mode_set_no
 		int div_low = prate / mode_rate;
 
 		if (div_low >= 2 &&
-		    ((prate / div_low - mode_rate) <
-		     10 * (mode_rate - prate / div)))
+		    (10 * (prate / div_low - mode_rate) <
+		     (mode_rate - prate / div)))
 			/*
 			 * At least 10 times better when using a higher
 			 * frequency than requested, instead of a lower.


