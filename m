Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B006A4F3066
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbiDEJEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240885AbiDEIsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD2026567;
        Tue,  5 Apr 2022 01:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5606360B0A;
        Tue,  5 Apr 2022 08:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A78BC385A0;
        Tue,  5 Apr 2022 08:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147780;
        bh=DfJ3/XGerV9z8uHB5PHG4KlHULnzzbRXaV41X+v+E0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=as7VjPjkGao4bkD1CEhm/vCVB9St1E8hvmGbDkUdHxmgiVp+ulzPdZMjargw2O3sg
         eZFFQ7nNiS/2aHKH/Li6+vwnPfVBPJA/wUgxnmvKyIy9zFwV6FJkWSJqYYa+fBovDm
         QNImfIoxH4+NioxupegNeCfeMhRsietXk8qeIjIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 5.16 0112/1017] drm/simpledrm: Add "panel orientation" property on non-upright mounted LCD panels
Date:   Tue,  5 Apr 2022 09:17:05 +0200
Message-Id: <20220405070357.520874437@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 94fa115f7b28a3f02611499175e134f0a823b686 upstream.

Some devices use e.g. a portrait panel in a standard laptop casing made
for landscape panels. efifb calls drm_get_panel_orientation_quirk() and
sets fb_info.fbcon_rotate_hint to make fbcon rotate the console so that
it shows up-right instead of on its side.

When switching to simpledrm the fbcon renders on its side. Call the
drm_connector_set_panel_orientation_with_quirk() helper to add
a "panel orientation" property on devices listed in the quirk table,
to make the fbcon (and aware userspace apps) rotate the image to
display properly.

Cc: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220221220045.11958-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/simpledrm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -779,6 +779,9 @@ static int simpledrm_device_init_modeset
 	if (ret)
 		return ret;
 	drm_connector_helper_add(connector, &simpledrm_connector_helper_funcs);
+	drm_connector_set_panel_orientation_with_quirk(connector,
+						       DRM_MODE_PANEL_ORIENTATION_UNKNOWN,
+						       mode->hdisplay, mode->vdisplay);
 
 	formats = simpledrm_device_formats(sdev, &nformats);
 


