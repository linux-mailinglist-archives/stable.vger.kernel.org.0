Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71264E863B
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 08:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiC0GRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 02:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiC0GRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 02:17:03 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451EC1F9;
        Sat, 26 Mar 2022 23:15:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f3so8623663pfe.2;
        Sat, 26 Mar 2022 23:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=zQojn1+l5AZVyTtTxvOBeZeYl0iCp/EsKmxH0UlfEcs=;
        b=Hibwc5S0U7wcL6DejpbxHFA4lwtNZXXluK5w0lQDctDdwmhutQeqQBn0No39o26MwV
         gJG5BJCw1+UelUqn/tGXf3SFwVIPDpmpiPRSZ+u1sY3f6iqKckD719pRDZc973b4EXde
         R/a3pJSpYS6ro2qo3aZVIvSxfLYGAYktqScZAeFd0+/KnFt80DQVgCDhTtNBLGxmyS5T
         wgahD66mgtdWO8inc+hftRU9X4Zks5RVn+SEKX/vKLDEW+TKTNipJOxRacru4iMCdTcJ
         LKDDpszpxqgA1TWeikNnHOoZGSRFkAxqIpLH9InpiH+8DcW/Xg321+8hqxml1LWEvNuG
         298Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zQojn1+l5AZVyTtTxvOBeZeYl0iCp/EsKmxH0UlfEcs=;
        b=F18BhXXoV1/diYE1968mp/kwhzYQKCIvwfSeMnqG1pTgD277JTbVUGmEogeOljQVup
         ea4oWVDNG3wkRkwBnwC6N9n7byp02A7sE55gI4g4lRtb+3lQE9D5jWLBTymrdvsmQksn
         0i/OK08aksti7OAzONjctDdn1DLC8HVzrHjsfUbJrAR3OPJwf1w9O02TzB03wCO0GxPU
         aJB1TP78VNlBOJQwU9ioGNJXNzxrRzIlF89eh/Ausp4qBJi3vmSzf7lufswrLQP7UEC7
         BQnWTQ2+m7eaicChRkMJyneGWPYVgBMo/dWF7O37AuU70yLgJ6bse040MW7GqUXSbeXZ
         E6ng==
X-Gm-Message-State: AOAM5301OkmcBRUDtiPsNBcW8qw+JkrPPsApm4DbYmg7dqru7mpnJyLe
        C4A55d8IEXB7FC3JeujS++k=
X-Google-Smtp-Source: ABdhPJwA+6yTY8xKsO78Xv/GnGsfLJkWH/TmLye/R0ryZxaUbH2KjgQoftfUHWRZJBP0X7DIXlyr1g==
X-Received: by 2002:a62:5583:0:b0:4fa:c74c:7eaa with SMTP id j125-20020a625583000000b004fac74c7eaamr17732239pfb.23.1648361722864;
        Sat, 26 Mar 2022 23:15:22 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id u204-20020a6279d5000000b004fa58625a80sm11650684pfc.53.2022.03.26.23.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 23:15:22 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     jyri.sarha@iki.fi
Cc:     tomba@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 14:15:16 +0800
Message-Id: <20220327061516.5076-1-xiam0nd.tong@gmail.com>
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
	if (!encoder) {

The list iterator value 'encoder' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, use a new variable 'iter' as the list iterator,
while use the original variable 'encoder' as a dedicated pointer
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: ec9eab097a500 ("drm/tilcdc: Add drm bridge support for attaching drm bridge drivers")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_external.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_external.c b/drivers/gpu/drm/tilcdc/tilcdc_external.c
index 7594cf6e186e..3b86d002ef62 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_external.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_external.c
@@ -60,11 +60,13 @@ struct drm_connector *tilcdc_encoder_find_connector(struct drm_device *ddev,
 int tilcdc_add_component_encoder(struct drm_device *ddev)
 {
 	struct tilcdc_drm_private *priv = ddev->dev_private;
-	struct drm_encoder *encoder;
+	struct drm_encoder *encoder = NULL, *iter;
 
-	list_for_each_entry(encoder, &ddev->mode_config.encoder_list, head)
-		if (encoder->possible_crtcs & (1 << priv->crtc->index))
+	list_for_each_entry(iter, &ddev->mode_config.encoder_list, head)
+		if (iter->possible_crtcs & (1 << priv->crtc->index)) {
+			encoder = iter;
 			break;
+		}
 
 	if (!encoder) {
 		dev_err(ddev->dev, "%s: No suitable encoder found\n", __func__);
-- 
2.17.1

