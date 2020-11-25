Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471052C4905
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 21:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgKYU1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 15:27:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729354AbgKYU1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 15:27:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606336034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oyv7TmTJOo07L0V0MDDH9iBw1ZsQzWrWnebIO9wiR7I=;
        b=EnscSJBfWEnNQagyJKY06/SgSW401FLj3ogUTPHzjS0gMcSWPlGTgWRZ4+oZ0bsprMy35x
        ortU5LBeXqjgULkrJghCjEpW95Si3NJHbtwwrjodg13znf3W+A91LWELfQfkR/J87CkAUc
        wUJqjQoLuo6QL4oW1YZ2imNWBX7bOE4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-XNa6kdt8PoS9W-nnnIOUDQ-1; Wed, 25 Nov 2020 15:27:12 -0500
X-MC-Unique: XNa6kdt8PoS9W-nnnIOUDQ-1
Received: by mail-qt1-f198.google.com with SMTP id y5so3245027qtb.13
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:27:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oyv7TmTJOo07L0V0MDDH9iBw1ZsQzWrWnebIO9wiR7I=;
        b=k9HY2dpyf1tgWQVrUFFqs/wNmSUMF5ty2P94YdVpuXpzDv//xjDAdWquhPfK46eApJ
         9Us+VQ+3wMbtXodtMX0qZl57Z2seX/f4zsXmXyJagzp76QiAXm4yCJmWIAvRZjcHTDbP
         rmN4teSAo3OzN9Drr1Wh6UjC01vKnAcEMeNkAp9ggZIDA8x5B2nXhx2vI01gnProDrzZ
         MLLms6rhoQHNYiqMsBeEKmqWNSDH6eh7NJdfHn7gvzt7NwZNh7fV4AoKxKTN1kaaihNy
         K/568cxuBistVCXupIWyPf+WCGshvXWsau44nIgUTYI4eJJJmn9+cB/EYehL4D24kci+
         d2nw==
X-Gm-Message-State: AOAM533MFgI4gV2iXPmviIqwDBYufnCJNWPZXEANPvQM++4xGBk+ocj0
        VXdu6pdvgGqJHkUy8c2xZ8ljGf6vGopoEn6RAaSFAVKy5u7Jrbyx4j06blfCE71Z8XfBWvF3UAh
        fpHZLicjDukwXv1LI
X-Received: by 2002:aed:39c2:: with SMTP id m60mr663843qte.206.1606336031654;
        Wed, 25 Nov 2020 12:27:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKH4xIOuYE9iphSs67b2xooUR1MwfVJh1L82U2A+W+f2xs7dI2EaoZEqdNs7n2LbREsN/4Fg==
X-Received: by 2002:aed:39c2:: with SMTP id m60mr663825qte.206.1606336031489;
        Wed, 25 Nov 2020 12:27:11 -0800 (PST)
Received: from dev.jcline.org ([2605:a601:a638:b301:9966:d978:493:6a3d])
        by smtp.gmail.com with ESMTPSA id o187sm431772qkb.120.2020.11.25.12.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:27:10 -0800 (PST)
From:   Jeremy Cline <jcline@redhat.com>
To:     Ben Skeggs <bskeggs@redhat.com>
Cc:     Lyude Paul <lyude@redhat.com>, Karol Herbst <kherbst@redhat.com>,
        David Airlie <airlied@linux.ie>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jeremy Cline <jcline@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/3] drm/nouveau: use drm_dev_unplug() during device removal
Date:   Wed, 25 Nov 2020 15:26:46 -0500
Message-Id: <20201125202648.5220-2-jcline@redhat.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125202648.5220-1-jcline@redhat.com>
References: <20201103194912.184413-1-jcline@redhat.com>
 <20201125202648.5220-1-jcline@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nouveau does not currently support hot-unplugging, but it still makes
sense to switch from drm_dev_unregister() to drm_dev_unplug().
drm_dev_unplug() calls drm_dev_unregister() after marking the device as
unplugged, but only after any device critical sections are finished.

Since nouveau isn't using drm_dev_enter() and drm_dev_exit(), there are
no critical sections so this is nearly functionally equivalent. However,
the DRM layer does check to see if the device is unplugged, and if it is
returns appropriate error codes.

In the future nouveau can add critical sections in order to truly
support hot-unplugging.

Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index d141a5f004af..4fe4d664c5f2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -792,7 +792,7 @@ nouveau_drm_device_remove(struct drm_device *dev)
 	struct nvkm_client *client;
 	struct nvkm_device *device;
 
-	drm_dev_unregister(dev);
+	drm_dev_unplug(dev);
 
 	dev->irq_enabled = false;
 	client = nvxx_client(&drm->client.base);
-- 
2.28.0

