Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2506565D96F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbjADQZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239872AbjADQZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:25:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B088643197
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:24:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB3F61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4621AC433EF;
        Wed,  4 Jan 2023 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849452;
        bh=/BJohr+0JpoCBzxjBbP6eXPaX8v7lhVJQyb8hQICTyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDh71bFEUBqTgniCiSZ/3WGwpluyruWgF7vd7TEEICWvIlC072teB8lgSNiQYC2k/
         FJrweuHOipoOM83yH+B79xVKWAreoAHe7AHmh/aKTgmnVv9WEVs56EiZ9+P0yFor5/
         5XGTI+wlQ7tais8Wjh/BmRhayNbs2hi1Yu2vmqZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Ser <contact@emersion.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Jonas=20=C3=85dahl?= <jadahl@redhat.com>
Subject: [PATCH 6.0 125/177] drm/connector: send hotplug uevent on connector cleanup
Date:   Wed,  4 Jan 2023 17:06:56 +0100
Message-Id: <20230104160511.434651236@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Ser <contact@emersion.fr>

commit 6fdc2d490ea1369d17afd7e6eb66fecc5b7209bc upstream.

A typical DP-MST unplug removes a KMS connector. However care must
be taken to properly synchronize with user-space. The expected
sequence of events is the following:

1. The kernel notices that the DP-MST port is gone.
2. The kernel marks the connector as disconnected, then sends a
   uevent to make user-space re-scan the connector list.
3. User-space notices the connector goes from connected to disconnected,
   disables it.
4. Kernel handles the IOCTL disabling the connector. On success,
   the very last reference to the struct drm_connector is dropped and
   drm_connector_cleanup() is called.
5. The connector is removed from the list, and a uevent is sent to tell
   user-space that the connector disappeared.

The very last step was missing. As a result, user-space thought the
connector still existed and could try to disable it again. Since the
kernel no longer knows about the connector, that would end up with
EINVAL and confused user-space.

Fix this by sending a hotplug uevent from drm_connector_cleanup().

Signed-off-by: Simon Ser <contact@emersion.fr>
Cc: stable@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Jonas Ådahl <jadahl@redhat.com>
Tested-by: Jonas Ådahl <jadahl@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221017153150.60675-2-contact@emersion.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_connector.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -505,6 +505,9 @@ void drm_connector_cleanup(struct drm_co
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 


