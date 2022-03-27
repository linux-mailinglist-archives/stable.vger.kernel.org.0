Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC62C4E85E7
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiC0FWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiC0FWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:22:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DDE65FF;
        Sat, 26 Mar 2022 22:20:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so6947357pjb.3;
        Sat, 26 Mar 2022 22:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=/a7VRIQfIk0sc3S+jykLBy1he3snFYah83JVhZ/FtcE=;
        b=Gu4KKtsGjBhRW6NALsZW7nc+kbdqqMi0pvPUrm0M1PGXR6i7tH9CzlmoBZjvqIvKIB
         PANnpRV0QzyhRqV6SuqNlLC9we6wmEyOkgcgEsr3ygdMhosxl1ZnkumOC8GuI1PyZdAf
         hWX7RvBCmGl5CPoQslMoAUKcz3qTS1K11cPL2aOFjqKrXoK8/1DvDV9GuiZu/pzTLvGP
         0O+/NycEb2xyfFc9XgPFLlw1Swr0VZq+KHUcbsxJ8FsTEfRMgYr7wmfnj19e9hRz4J5T
         8rDqczBMI96n1yYUrmFxkmRb83MZcnPk4ByGlrnqJJAvx7I/KtRF+/OA0oCH2gZ8zGzF
         J4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/a7VRIQfIk0sc3S+jykLBy1he3snFYah83JVhZ/FtcE=;
        b=Wzad3YGmRHFPKaLOXtz8mKapS6o469JvJFVXt8NUHNEiVsnEkXTLV1m4goIsKsJvzR
         bt+/gbXO7B44pyI9PmHMVOVyShaapc+pjaN+CBFWNRYsTQKaszl11aa+admUhg3KwCJs
         lhl7Ivmq9+9em+n8VjDVgLbYxTdn1gcX1uF87gYiATHqTmC8gScuIrN75ulQdnyUArX8
         rE1ZEEh+s/jFV0Q72FBvJ9BvDpSKySk1AmxF39kirCLQ8MUB5JknSHmjB9pwO68F6X3b
         PUtsTMMncn5Le/9bSi6i6scJGbynSEggwweUJ1BOey9rxLIQGJ5JjsUrJg0DBDN3T50a
         ZyFQ==
X-Gm-Message-State: AOAM5320nJ8bvSrJoqlat2vezyDMcbMlsc80Y0wyMTpy4AADfJ2ZIyhN
        9vcxvr6HOJ79r5tPMemUYb0=
X-Google-Smtp-Source: ABdhPJwpKtizoLaCssM+03oOecEr9SKKWfBodr8JhWSrgJTi3+rwUGiYHVWv+7cjG+H0YSsjqMU39Q==
X-Received: by 2002:a17:902:d652:b0:153:ad02:741c with SMTP id y18-20020a170902d65200b00153ad02741cmr20017545plh.135.1648358435718;
        Sat, 26 Mar 2022 22:20:35 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm15735507pjb.2.2022.03.26.22.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:20:35 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     patrik.r.jakobsson@gmail.com
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] gma500: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 13:20:28 +0800
Message-Id: <20220327052028.2013-1-xiam0nd.tong@gmail.com>
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
	return crtc;

The list iterator value 'crtc' will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found.

To fix the bug, return 'crtc' when found, otherwise return NULL.

Cc: stable@vger.kernel.org
fixes: 89c78134cc54d ("gma500: Add Poulsbo support")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/gma500/psb_intel_display.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index d5f95212934e..42d1a733e124 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -535,14 +535,15 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 
 struct drm_crtc *psb_intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
 {
-	struct drm_crtc *crtc = NULL;
+	struct drm_crtc *crtc;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct gma_crtc *gma_crtc = to_gma_crtc(crtc);
+
 		if (gma_crtc->pipe == pipe)
-			break;
+			return crtc;
 	}
-	return crtc;
+	return NULL;
 }
 
 int gma_connector_clones(struct drm_device *dev, int type_mask)
-- 
2.17.1

