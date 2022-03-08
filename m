Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703AF4D1F51
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 18:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348653AbiCHRov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 12:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346747AbiCHRov (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 12:44:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CBE13BFAF
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 09:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646761433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=alZLDhY3ctKEsDcSiL/Qu/J5K/GOOm/V8wMQqvRO8KI=;
        b=Mt5a9FXAMotgDMRe9NuA5z4qAF9GGtSFZobvvRxU75iREFiaex7dSB0q7KSRi98yNcsJSJ
        UJ+vuaFIN6ixwalxwa7sy9+MSyx/K7vvlJwACYLoVswoi3zlxVtZ+dCIOuuNTMu5NVV8ol
        R5V9X4pRoGurUjI9gEyZXvDYveyPgNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-PWD1tRqTPI2mTQluLvE8fw-1; Tue, 08 Mar 2022 12:43:50 -0500
X-MC-Unique: PWD1tRqTPI2mTQluLvE8fw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76C3D180A08C;
        Tue,  8 Mar 2022 17:43:48 +0000 (UTC)
Received: from hydra.redhat.com (unknown [10.39.192.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ECE980FC8;
        Tue,  8 Mar 2022 17:43:42 +0000 (UTC)
From:   Jocelyn Falempe <jfalempe@redhat.com>
To:     dri-devel@lists.freedesktop.org
Cc:     michel@daenzer.net, lyude@redhat.com, tzimmermann@suse.de,
        Jocelyn Falempe <jfalempe@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] drm/mgag200: Fix PLL setup for g200wb and g200ew
Date:   Tue,  8 Mar 2022 18:43:21 +0100
Message-Id: <20220308174321.225606-1-jfalempe@redhat.com>
In-Reply-To: <20220308171111.220557-1-jfalempe@redhat.com>
References: <20220308171111.220557-1-jfalempe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f86c3ed55920 ("drm/mgag200: Split PLL setup into compute and
 update functions") introduced a regression for g200wb and g200ew.
The PLLs are not set up properly, and VGA screen stays
black, or displays "out of range" message.

MGA1064_WB_PIX_PLLC_N/M/P was mistakenly replaced with
MGA1064_PIX_PLLC_N/M/P which have different addresses.

Patch tested on a Dell T310 with g200wb

Fixes: f86c3ed55920 ("drm/mgag200: Split PLL setup into compute and update functions")
Cc: stable@vger.kernel.org
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
---
 drivers/gpu/drm/mgag200/mgag200_pll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_pll.c b/drivers/gpu/drm/mgag200/mgag200_pll.c
index e9ae22b4f813..52be08b744ad 100644
--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -404,9 +404,9 @@ mgag200_pixpll_update_g200wb(struct mgag200_pll *pixpll, const struct mgag200_pl
 		udelay(50);
 
 		/* program pixel pll register */
-		WREG_DAC(MGA1064_PIX_PLLC_N, xpixpllcn);
-		WREG_DAC(MGA1064_PIX_PLLC_M, xpixpllcm);
-		WREG_DAC(MGA1064_PIX_PLLC_P, xpixpllcp);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_N, xpixpllcn);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_M, xpixpllcm);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_P, xpixpllcp);
 
 		udelay(50);
 
-- 
2.35.1

