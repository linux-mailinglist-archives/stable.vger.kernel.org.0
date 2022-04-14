Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F405005CE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 08:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbiDNGQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 02:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiDNGQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 02:16:47 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A3D641C;
        Wed, 13 Apr 2022 23:14:21 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso8404018pju.1;
        Wed, 13 Apr 2022 23:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=xSaEo9LO7falECQjCcduKi//QmoNEw98a9U9ZQZJgh0=;
        b=kxTi7L39zBMmLwbO/yI0P60LXETiezuazG6rlO5ELFcbhEY1oEruR/u/1yo6N3KdQM
         2O3AUj5NiRsJ7q8fAiWhsh1U7XzByWNXQ0o+0xTNY6Fm/VpR3V3BCHnj6q1Y4ZmerDhl
         ml3SH/gbEb8sBaGbfujS5u45t1wFcG08OKiubAk72kE3re/C0hcN5oRWV5yHx2cWPh3G
         4EHxbAAxD5TeYvB/GTp04kn5Ko8AZzXvBXTj5w73Klbl6Pym2+BixMDk3gFHJN2VGOg0
         7cDTVYIflbge4PL8N9KjNv+cRh+9M1Nx1gAYdPFS3eYVK5FrN+1+TYR4Yd2qMNOSfcC9
         GKpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xSaEo9LO7falECQjCcduKi//QmoNEw98a9U9ZQZJgh0=;
        b=jFyJeWD+L8o7x8WNA8Suz4cYTeqA5QmdL5I21iZPv0cfuHuyGJ34A79moLVBfYnUO4
         r5SP+/vPT7XWA6ZMHB7AhUDQ7ir8hIYBnRumZZDgWRmFwIhgkPy5VeUrAbdcR8A/WFdX
         puBbfMO/2htGL9tE/8y7LJuidENU4lGYDz/PrAkR0NUDcUfoX1P474OB7FGmWnuB465F
         JB6Rjd6nREMJrAN64XepmlEBl0oQY7TSMb6mU6Cq6E9aQZOhzQ7DEaAgdBjIfG6QBfcE
         xZuBCs1fpqMydD6FsHIM1EkpsTUYdGCu39ONlwWz2J84lPS5e+CLZ3pAgUG5H+/n5+ch
         9liQ==
X-Gm-Message-State: AOAM531e5vSTOXcH/JXpnb3rMqa6gnfaR6wsPJw6TzZ/aBUaocL7UfnG
        beycy9J4tyc9rmFLc55UejA=
X-Google-Smtp-Source: ABdhPJzfqbuE+SKFgvlaHYYvwCo6iZQfPGv6i6/v9EAG/8WGUTum8VyjBgQWC5Y8dRWej4ZxlU0lQQ==
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id v10-20020a17090a00ca00b001ca5253b625mr2065267pjd.220.1649916860983;
        Wed, 13 Apr 2022 23:14:20 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id 25-20020a631259000000b0039d353e6d75sm927364pgs.57.2022.04.13.23.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 23:14:20 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     tomba@kernel.org, airlied@linux.ie, daniel@ffwll.ch
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [RESEND][PATCH] omapdrm: fix missing check on list iterator
Date:   Thu, 14 Apr 2022 14:14:10 +0800
Message-Id: <20220414061410.7678-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	bus_flags = connector->display_info.bus_flags;

The list iterator 'connector-' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will lead
to a invalid memory access.

To fix this bug, add an check. Use a new value 'iter' as the list
iterator, while use the old value 'connector' as a dedicated variable
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: ("drm/omap: Add support for drm_panel")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/omapdrm/omap_encoder.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_encoder.c b/drivers/gpu/drm/omapdrm/omap_encoder.c
index 4dd05bc732da..d648ab4223b1 100644
--- a/drivers/gpu/drm/omapdrm/omap_encoder.c
+++ b/drivers/gpu/drm/omapdrm/omap_encoder.c
@@ -76,14 +76,16 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
 	struct omap_encoder *omap_encoder = to_omap_encoder(encoder);
 	struct omap_dss_device *output = omap_encoder->output;
 	struct drm_device *dev = encoder->dev;
-	struct drm_connector *connector;
+	struct drm_connector *connector = NULL, *iter;
 	struct drm_bridge *bridge;
 	struct videomode vm = { 0 };
 	u32 bus_flags;
 
-	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
-		if (connector->encoder == encoder)
+	list_for_each_entry(iter, &dev->mode_config.connector_list, head) {
+		if (iter->encoder == encoder) {
+			connector = iter;
 			break;
+		}
 	}
 
 	drm_display_mode_to_videomode(adjusted_mode, &vm);
@@ -106,8 +108,10 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
 		omap_encoder_update_videomode_flags(&vm, bus_flags);
 	}
 
-	bus_flags = connector->display_info.bus_flags;
-	omap_encoder_update_videomode_flags(&vm, bus_flags);
+	if (connector) {
+		bus_flags = connector->display_info.bus_flags;
+		omap_encoder_update_videomode_flags(&vm, bus_flags);
+	}
 
 	/* Set timings for all devices in the display pipeline. */
 	dss_mgr_set_timings(output, &vm);
-- 
2.17.1

