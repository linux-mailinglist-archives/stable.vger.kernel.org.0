Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7B666CB89
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbjAPRPQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbjAPROe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E644C6C4
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75E8FB8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCE7C433EF;
        Mon, 16 Jan 2023 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888108;
        bh=nY7PsE362sG6NnPVcJvIdALivP4ddwhZfnntVz3fFBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5+K1drAvPsVx9IrLjMoWtMkkMzjs3WQtyhn8Rcp+RUjTpiyPyVWTnp7BjD9S0Ra2
         oPXDIhvfrWMOBygyv7WHkAONHcDbDoA9exiqvI9tFApz+Akx689x1D+W+lVtcU+yis
         m3CWDXxAdoQzn5AIbIN8aWocyX8Y8rY5hu7aVbLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Ser <contact@emersion.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Jonas=20=C3=85dahl?= <jadahl@redhat.com>
Subject: [PATCH 4.19 404/521] drm/connector: send hotplug uevent on connector cleanup
Date:   Mon, 16 Jan 2023 16:51:06 +0100
Message-Id: <20230116154905.154643599@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -413,6 +413,9 @@ void drm_connector_cleanup(struct drm_co
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 


