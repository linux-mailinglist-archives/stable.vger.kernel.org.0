Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8944E85F5
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiC0Ffa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiC0Ff3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:35:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54285B869;
        Sat, 26 Mar 2022 22:33:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y6so9571018plg.2;
        Sat, 26 Mar 2022 22:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=xSaEo9LO7falECQjCcduKi//QmoNEw98a9U9ZQZJgh0=;
        b=lGH+n2l5hbyQ3oeQV+8To9w7NYMbU1mNpdI5etgt2b/SaqSpTPk8Jcr8H008L2ru5M
         RDP1RsfEsbdT+3ClnYQ4TtmoUHlrtsenl/HCd040hLBMfOw9rvLCgUZjUG95Wz7097D2
         oqJrsybkccDLMPIxa4R/MGoMYleRdKkXLvoKAdslDyrLIrNOdjJpvoznMFzi6FMtMKm7
         klcoxCekVLTOt0sj167R63L7OUzbNaYPYkoczk7MQ2GTwp4NUHWGFlmVBqWxoulTtOLn
         GxvGK9D8vyvzNm3NKQrpknUprTMCrsJ/a6h98VRfNOLcv06Zy9MBQ9GcQJd4fqZBvfEa
         NHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xSaEo9LO7falECQjCcduKi//QmoNEw98a9U9ZQZJgh0=;
        b=re3BGj7bqhKbSNZl3Mdr1wBbkXzDHp8H4Y5bRuq1KsgPheaK857s7KTEaQZ3yX4D2S
         6bOkXZ9cm8dSgEc6Dw0plf/jcHrvGNTNg0OfjfTMYMr/FK6MREhU48HF4X7rDUfrSvsG
         FAo8ZWnQxpRujbOrU/GX8PEEHqE+HrG4AIJE8cMLa68qsVfA3gCLJ0PzSZ6UE+MY9+SK
         Pzr7U30/d43NpsaXmO1S7g6umtjSAvrehC8SCbfPBJY6+ZO8/iIK1psFw2ckR+YmsHxm
         Tngc1BIU0xBl13xoGd0meL5Tv6kmlR+3e0ugn7dUVrAxm8EDAsqWIU8HtlKNs8odBPHx
         TkmQ==
X-Gm-Message-State: AOAM532rkvnFGpimQEJ5TJ1IJx3II5b/XwH/gDyQSU4TxGUbd9EGBAZy
        9qM2Qyb8fjZagOKmOCo3780=
X-Google-Smtp-Source: ABdhPJzZ18rhjsZXOUmdR1MF8whBPlQuLAFQEDXUlRLG9T0g/Unls8OXFNRgC9YAvDov3k0h3cyoFw==
X-Received: by 2002:a17:902:b597:b0:151:e24e:a61e with SMTP id a23-20020a170902b59700b00151e24ea61emr19886693pls.66.1648359230883;
        Sat, 26 Mar 2022 22:33:50 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id d80-20020a621d53000000b004fae1119955sm11654765pfd.213.2022.03.26.22.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:33:50 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     tomba@kernel.org
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] omapdrm: fix missing check on list iterator
Date:   Sun, 27 Mar 2022 13:33:44 +0800
Message-Id: <20220327053344.2696-1-xiam0nd.tong@gmail.com>
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

