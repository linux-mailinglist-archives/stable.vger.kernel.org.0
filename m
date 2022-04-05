Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6074F2E48
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349007AbiDEKuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344477AbiDEJmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:42:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F16BE9C7;
        Tue,  5 Apr 2022 02:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0CB2B81C6E;
        Tue,  5 Apr 2022 09:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BB6C385A0;
        Tue,  5 Apr 2022 09:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150863;
        bh=XQzzdibhL0otRHSkdbIMNyKyXU70t8rbk4JAHgEy2QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZhvooKbzbUQx943pCD5TtNdk8IXIAiys6v0E3/Db5nvZn2lP49jKJcHb0pAa8V2S4
         1UXayNxAygKWbAbeUmPWjTbmQU7EhVuP8aM1xRstVdGlqUJGke2WUTBgdQDx+DaNIr
         WlfYWRxj+YE/FNilEO7u6l1YG6Nhr14mJE/ynt0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 176/913] drm/nouveau/backlight: Fix LVDS backlight detection on some laptops
Date:   Tue,  5 Apr 2022 09:20:38 +0200
Message-Id: <20220405070345.127736150@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

commit 6b0076540faffd47f5a899bf12f3528c4f0e726b upstream.

It seems that some laptops will report having both an eDP and LVDS
connector, even though only the LVDS connector is actually hooked up. This
can lead to issues with backlight registration if the eDP connector ends up
getting registered before the LVDS connector, as the backlight device will
then be registered to the eDP connector instead of the LVDS connector.

So, fix this by only registering the backlight on connectors that are
reported as being connected.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 6eca310e8924 ("drm/nouveau/kms/nv50-: Add basic DPCD backlight support for nouveau")
Bugzilla: https://gitlab.freedesktop.org/drm/nouveau/-/issues/137
Cc: <stable@vger.kernel.org> # v5.15+
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220204180504.328999-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -294,7 +294,8 @@ nv50_backlight_init(struct nouveau_backl
 	struct nouveau_drm *drm = nouveau_drm(nv_encoder->base.base.dev);
 	struct nvif_object *device = &drm->client.device.object;
 
-	if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)))
+	if (!nvif_rd32(device, NV50_PDISP_SOR_PWM_CTL(ffs(nv_encoder->dcb->or) - 1)) ||
+	    nv_conn->base.status != connector_status_connected)
 		return -ENODEV;
 
 	if (nv_conn->type == DCB_CONNECTOR_eDP) {


