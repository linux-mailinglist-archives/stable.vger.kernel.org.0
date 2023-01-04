Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0858065D9D0
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbjADQ3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbjADQ25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2D244377
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672849661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28+xUt4XD6oJKtFA7tA/ZRPebQEYdm2bmnUTPRRpXMg=;
        b=YetlfwLMTCSM1oJkIK/PdU7tWPVVW4SNXqQXnFqW/3dEtNg15H91ktHl+J3wo5aiV/aYpm
        1k5iEDhNmrbC/hW0XcdBZklLc73PfeT8UknrycCR64BfEvKhWukvPkmIibRDCvox4lIAiz
        WAszo0uwLdgQJrlOg7r6HjX9QZUudL4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-FTnnbWMqPiGjJ6f-N63GFw-1; Wed, 04 Jan 2023 11:27:37 -0500
X-MC-Unique: FTnnbWMqPiGjJ6f-N63GFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80419884343;
        Wed,  4 Jan 2023 16:27:37 +0000 (UTC)
Received: from hydra.redhat.com (unknown [10.39.192.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0A571121314;
        Wed,  4 Jan 2023 16:27:36 +0000 (UTC)
From:   Jocelyn Falempe <jfalempe@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     Jocelyn Falempe <jfalempe@redhat.com>, stable@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Date:   Wed,  4 Jan 2023 17:27:29 +0100
Message-Id: <20230104162729.424575-1-jfalempe@redhat.com>
In-Reply-To: <167284297425244@kroah.com>
References: <167284297425244@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b389286d0234e1edbaf62ed8bc0892a568c33662 upstream.

For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
or "signal out of range" on VGA display.
previous code had "m |= 0x80" which was changed to
m |= ((pixpllcn & BIT(8)) >> 1);

Tested on G200_SE_A rev 42

This line of code was moved to another file with
commit 877507bb954e ("drm/mgag200: Provide per-device callbacks for
PIXPLLC") but can be easily backported before this commit.

v2: * put BIT(7) First to respect MSB-to-LSB (Thomas)
    * Add a comment to explain that this bit must be set (Thomas)

backported to v6.0.17, it also applies cleanly to v5.15.86

Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221013132810.521945-1-jfalempe@redhat.com
---
 drivers/gpu/drm/mgag200/mgag200_pll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_pll.c b/drivers/gpu/drm/mgag200/mgag200_pll.c
index 8065ca5d8de9..4f55961848a8 100644
--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -269,7 +269,8 @@ static void mgag200_pixpll_update_g200se_04(struct mgag200_pll *pixpll,
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	// For G200SE A, BIT(7) should be set unconditionally.
+	xpixpllcm = BIT(7) | pixpllcm;
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 
-- 
2.38.1

