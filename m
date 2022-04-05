Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8664F25D4
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiDEHwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiDEHwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:52:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506C219288;
        Tue,  5 Apr 2022 00:48:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD6661668;
        Tue,  5 Apr 2022 07:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E206AC3410F;
        Tue,  5 Apr 2022 07:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144921;
        bh=7BB3FgLvSc0zHBfw7IiOKNCmtEcStSksT+drOFDU2Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFAA4J3x8VVZf7mmUR8vX/jvzCy2xG6fJrQqc75gVhsJiAjYVbsvv4m70sZMGPcwZ
         tcFim1eo6V8Tn2RzJh5EAc4fdM+5JnIZ1ZBrPQWps5u8KxnaucQrki6gmOOvw5cNwt
         0kzYmKWDfbwD0/hbZaZvvU4MgxjdqhwHFFCWWBw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.17 0185/1126] drm/nouveau/backlight: Just set all backlight types as RAW
Date:   Tue,  5 Apr 2022 09:15:32 +0200
Message-Id: <20220405070413.037111380@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit b21a142fd2055d8276169efcc95b624ff908a341 upstream.

Currently we can get a warning on systems with eDP backlights like so:

  nv_backlight: invalid backlight type
  WARNING: CPU: 4 PID: 454 at drivers/video/backlight/backlight.c:420
    backlight_device_register+0x226/0x250

This happens as a result of us not filling out props.type for the eDP
backlight, even though we do it for all other backlight types.

Since nothing in our driver uses anything but BACKLIGHT_RAW, let's take the
props\.type assignments out of the codepaths for individual backlight types
and just set it unconditionally to prevent this from happening again.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 6eca310e8924 ("drm/nouveau/kms/nv50-: Add basic DPCD backlight support for nouveau")
Cc: <stable@vger.kernel.org> # v5.15+
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220204193319.451119-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -101,7 +101,6 @@ nv40_backlight_init(struct nouveau_encod
 	if (!(nvif_rd32(device, NV40_PMC_BACKLIGHT) & NV40_PMC_BACKLIGHT_MASK))
 		return -ENODEV;
 
-	props->type = BACKLIGHT_RAW;
 	props->max_brightness = 31;
 	*ops = &nv40_bl_ops;
 	return 0;
@@ -343,7 +342,6 @@ nv50_backlight_init(struct nouveau_backl
 	else
 		*ops = &nva3_bl_ops;
 
-	props->type = BACKLIGHT_RAW;
 	props->max_brightness = 100;
 
 	return 0;
@@ -411,6 +409,7 @@ nouveau_backlight_init(struct drm_connec
 		goto fail_alloc;
 	}
 
+	props.type = BACKLIGHT_RAW;
 	bl->dev = backlight_device_register(backlight_name, connector->kdev,
 					    nv_encoder, ops, &props);
 	if (IS_ERR(bl->dev)) {


