Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E80111E14
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfLCW7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:59:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:55700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729364AbfLCW7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:59:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3AFE20865;
        Tue,  3 Dec 2019 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413948;
        bh=mbcxVdp4s/ty4G3JdaSIo/9yjvlwPPsjwjG58fNirxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGi0wiRJLotsGX2/i3iq8bgiudmX04ZwCytCafRbI+HHo2Z8dOnQxFKG+3miYgyX3
         d+nKLlus4FucoWnG+w8TMAANNM6tqjftOlQco12n2m65BY624zSKTVdBOXAt2jIvYU
         kv9VZnxWdCKTD4cP2vFMaseY8MpOgLQ+64LuIrqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 301/321] drm/atmel-hlcdc: revert shift by 8
Date:   Tue,  3 Dec 2019 23:36:07 +0100
Message-Id: <20191203223442.809046337@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

commit cbb32079149dbf557fa3f7bab8fa3c5fec857da7 upstream.

Revert shift by 8 of state->base.alpha. This introduced a
regression on planes.

Fixes: 7f73c10b256b ("drm/atmel-hclcdc: Convert to the new generic alpha property")
Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/1556195748-11106-7-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -382,7 +382,7 @@ atmel_hlcdc_plane_update_general_setting
 			cfg |= ATMEL_HLCDC_LAYER_LAEN;
 		else
 			cfg |= ATMEL_HLCDC_LAYER_GAEN |
-			       ATMEL_HLCDC_LAYER_GA(state->base.alpha >> 8);
+			       ATMEL_HLCDC_LAYER_GA(state->base.alpha);
 	}
 
 	if (state->disc_h && state->disc_w)


