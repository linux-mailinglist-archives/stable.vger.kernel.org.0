Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321FB5FD631
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 10:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJMI3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 04:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJMI3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 04:29:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98E915DB0F
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 01:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665649757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GbAPudkJN2ZfKtwFkn+RvQb0MCZbu4crNWZxr6gzXJI=;
        b=E/s2DzedYqAbB+c5zKqYym8/gSJi7lTWCqNlw7qKI8/OjYV0i+XEaFTdUueQ756PQrqNNC
        pcZ3QIX5FE9oBnEGGK9JTkqv+Nl0GfBf5Ud5wo65s+ix0kzwNfU8KB5UWnVamuDsk8yMKk
        jbmGAfViQQIumUjlZ1pjgm5tAR+E4gI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-YLfXgt9VMPuCT4FXIDAHGA-1; Thu, 13 Oct 2022 04:29:16 -0400
X-MC-Unique: YLfXgt9VMPuCT4FXIDAHGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7C861C004F5;
        Thu, 13 Oct 2022 08:29:15 +0000 (UTC)
Received: from hydra.redhat.com (unknown [10.39.192.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E14D140EBF3;
        Thu, 13 Oct 2022 08:29:14 +0000 (UTC)
From:   Jocelyn Falempe <jfalempe@redhat.com>
To:     dri-devel@lists.freedesktop.org, tzimmermann@suse.de,
        airlied@redhat.com
Cc:     lyude@redhat.com, michel@daenzer.net,
        Jocelyn Falempe <jfalempe@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Date:   Thu, 13 Oct 2022 10:29:01 +0200
Message-Id: <20221013082901.471417-1-jfalempe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
or "signal out of range" on VGA display.
previous code had "m |= 0x80" which was changed to
m |= ((pixpllcn & BIT(8)) >> 1);

Tested on G200_SE_A rev 42

This line of code was moved to another file with
commit 85397f6bc4ff ("drm/mgag200: Initialize each model in separate
function") but can be easily backported before this commit.

Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
---
 drivers/gpu/drm/mgag200/mgag200_g200se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c b/drivers/gpu/drm/mgag200/mgag200_g200se.c
index be389ed91cbd..4ec035029b8b 100644
--- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
@@ -284,7 +284,7 @@ static void mgag200_g200se_04_pixpllc_atomic_update(struct drm_crtc *crtc,
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	xpixpllcm = pixpllcm | BIT(7);
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 
-- 
2.37.3

