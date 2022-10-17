Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3CF6012C7
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 17:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJQPcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 11:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiJQPcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 11:32:16 -0400
Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90A912753
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 08:32:14 -0700 (PDT)
Date:   Mon, 17 Oct 2022 15:32:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1666020732; x=1666279932;
        bh=IKMEh+TcgfoRlr9HJfKGhPSu4b8tesTclKkh0S1exQY=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=XWeCzDaGJEO3QxbkmlTVdiuImyt82NQtjmkKO9KUZKr5gQjfyJSFvSJmVZESd8GOb
         XihvZ6IWWPrb1XHJZtDnK4fGZqO01/x0k4biBR6HbZuKPW5KqKUMk2Px+J5IGFbmJH
         oriw9gNudRBogbStisETZV3GvO7h4YyJJzcSC7b87Ng7UivxwaTciU4WhRv9rAOkRU
         ISnDCK7VvNEQiDvdTYBUU6or7V9ty4LNZyktGKUScXhautXSNFjYcyiNJnuJLi6ZF7
         aDYKI54bvmcBBvD7gl26ZS8zRRxMPqClXMIDqeedklPjKYipX7S1weVjGCe4Qq2fSw
         VvJ11fgwW38CA==
To:     dri-devel@lists.freedesktop.org
From:   Simon Ser <contact@emersion.fr>
Cc:     stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Lyude Paul <lyude@redhat.com>,
        =?utf-8?Q?Jonas_=C3=85dahl?= <jadahl@redhat.com>
Subject: [PATCH 2/2] drm/connector: send hotplug uevent on connector cleanup
Message-ID: <20221017153150.60675-2-contact@emersion.fr>
In-Reply-To: <20221017153150.60675-1-contact@emersion.fr>
References: <20221017153150.60675-1-contact@emersion.fr>
Feedback-ID: 1358184:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A typical DP-MST unplug removes a KMS connector. However care must
be taken to properly synchronize with user-space. The expected
sequence of events is the following:

1. The kernel notices that the DP-MST port is gone.
2. The kernel marks the connector as disconnected, then sends a
   uevent to make user-space re-scan the connector list.
3. User-space notices the connector goes from connected to disconnected,
   disables it.
4. Kernel handles the the IOCTL disabling the connector. On success,
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
Cc: Jonas =C3=85dahl <jadahl@redhat.com>
---
 drivers/gpu/drm/drm_connector.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connecto=
r.c
index e3142c8142b3..90dad87e9ad0 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -582,6 +582,9 @@ void drm_connector_cleanup(struct drm_connector *connec=
tor)
 =09mutex_destroy(&connector->mutex);
=20
 =09memset(connector, 0, sizeof(*connector));
+
+=09if (dev->registered)
+=09=09drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
=20
--=20
2.38.0


