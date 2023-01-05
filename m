Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D665EC6B
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjAENJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbjAENJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:09:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87DD5DE66
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5301FCE1AD0
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AE8C433F1;
        Thu,  5 Jan 2023 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672924130;
        bh=I5c5fox+q07OpPB+Q7xKVHc7Mp7MYCjON7vvhoDA6+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X4pt5BLEwSMaHmJuTIybOJcsd+74ds31uHb4973IWRKxI/e7dIOocJnquSpF+pw19
         deg/dVKpp9xyNi/EySlpBPw2U7Z3VSGgiFVofH+s3YMKDhmLSEvwxRHivwJos2rGCB
         iCFX4i1VvAwhqrl2M5zWz9Hk9h9xGhftB/z4cq/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Simon Ser <contact@emersion.fr>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lyude Paul <lyude@redhat.com>,
        =?UTF-8?q?Jonas=20=C3=85dahl?= <jadahl@redhat.com>
Subject: [PATCH 4.9 243/251] drm/connector: send hotplug uevent on connector cleanup
Date:   Thu,  5 Jan 2023 13:56:20 +0100
Message-Id: <20230105125346.001926140@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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
@@ -363,6 +363,9 @@ void drm_connector_cleanup(struct drm_co
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 


