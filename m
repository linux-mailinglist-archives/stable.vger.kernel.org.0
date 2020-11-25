Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B372C4906
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 21:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgKYU1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 15:27:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729175AbgKYU1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 15:27:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606336036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m28TgjZwi7HhBuSwen4t4g93qkTs31I2N0RIyqGkBQY=;
        b=ecTPpWB9KnDY2ew0Nj2/tFIPHitjvc6+B138AXrO/Jgy3SfU80EXNm1bOl1Ynk7ohpMEXG
        EPJ4htHzV2pxjc4AR4YJ5B04g0AWzNPxPXbnkUnF5x2o2R7gNo4YkoxxVbuKlP+JClMfz0
        GavdIUXiFbPEcr4sLlR70OJq90EsI8g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-WvyK-rq6MiGI3V0gHXqujw-1; Wed, 25 Nov 2020 15:27:14 -0500
X-MC-Unique: WvyK-rq6MiGI3V0gHXqujw-1
Received: by mail-qv1-f72.google.com with SMTP id cu18so3208842qvb.17
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 12:27:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m28TgjZwi7HhBuSwen4t4g93qkTs31I2N0RIyqGkBQY=;
        b=W7SsmQpGgUaJYhQpdxwkGaNGJMSp1rruG/WZyko06lHKSUTTKHppeETUVo6iyuPAXM
         gNQpnv4PbTOgEHvrRjmzuZIbQIo4ay8rtyqqa/X/IlBsBj0cq6Plpu+xSYsHL7UmsL1h
         kIzUT5oAiLoKwUHBzegEuhKjNawf+EDLTngxT0iCc0mrrhn4963ctzOTUbZmNeVJQh1X
         CCWN/vKZCyU1COgBjFVPOpO5tig9dXyvRteHmVKtx1qW+sYEPKZnT/P7amycVlUE/vJ0
         x3myZjwGDPVT3ORRi/i3S6ZVrtjfrZ1+zYGu9BPiTnXnDxcaZgWpf4kqIRuCWsT0yduk
         d6jw==
X-Gm-Message-State: AOAM533YeF04yijvjz2RI5UR+gZsDBj5B/RohFItFqqxBaIyMjDn4er1
        8T7Vlxwd4uSX6U2kfoCVROkSNOmhE8QHvHiJ/CQgRoXSbhrxWGFJTDx/oFUGWnul5Tc38PzUAf/
        KzMKKevoRDDKkVlwV
X-Received: by 2002:a37:4854:: with SMTP id v81mr748205qka.20.1606336033967;
        Wed, 25 Nov 2020 12:27:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTVi4YITmr/yVt0UXkpzCkoAdVjZcIU7pnzNdwrA6y0qo2w8G8fpzl3w+LvWzcj9VOPAQxLw==
X-Received: by 2002:a37:4854:: with SMTP id v81mr748193qka.20.1606336033788;
        Wed, 25 Nov 2020 12:27:13 -0800 (PST)
Received: from dev.jcline.org ([2605:a601:a638:b301:9966:d978:493:6a3d])
        by smtp.gmail.com with ESMTPSA id o187sm431772qkb.120.2020.11.25.12.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:27:13 -0800 (PST)
From:   Jeremy Cline <jcline@redhat.com>
To:     Ben Skeggs <bskeggs@redhat.com>
Cc:     Lyude Paul <lyude@redhat.com>, Karol Herbst <kherbst@redhat.com>,
        David Airlie <airlied@linux.ie>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jeremy Cline <jcline@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] drm/nouveau: Add a dedicated mutex for the clients list
Date:   Wed, 25 Nov 2020 15:26:47 -0500
Message-Id: <20201125202648.5220-3-jcline@redhat.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201125202648.5220-1-jcline@redhat.com>
References: <20201103194912.184413-1-jcline@redhat.com>
 <20201125202648.5220-1-jcline@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rather than protecting the nouveau_drm clients list with the lock within
the "client" nouveau_cli, add a dedicated lock to serialize access to
the list. This is both clearer and necessary to avoid lockdep being
upset with us when we need to iterate through all the clients in the
list and potentially lock their mutex, which is the same class as the
lock protecting the entire list.

Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Cline <jcline@redhat.com>
---
Changes since v1:
  - Add a mutex_destroy() call when destroying the device struct

 drivers/gpu/drm/nouveau/nouveau_drm.c | 10 ++++++----
 drivers/gpu/drm/nouveau/nouveau_drv.h |  5 +++++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 4fe4d664c5f2..6ee1adc9bd40 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -557,6 +557,7 @@ nouveau_drm_device_init(struct drm_device *dev)
 		nvkm_dbgopt(nouveau_debug, "DRM");
 
 	INIT_LIST_HEAD(&drm->clients);
+	mutex_init(&drm->clients_lock);
 	spin_lock_init(&drm->tile.lock);
 
 	/* workaround an odd issue on nvc1 by disabling the device's
@@ -654,6 +655,7 @@ nouveau_drm_device_fini(struct drm_device *dev)
 	nouveau_cli_fini(&drm->client);
 	nouveau_cli_fini(&drm->master);
 	nvif_parent_dtor(&drm->parent);
+	mutex_destroy(&drm->clients_lock);
 	kfree(drm);
 }
 
@@ -1089,9 +1091,9 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 
 	fpriv->driver_priv = cli;
 
-	mutex_lock(&drm->client.mutex);
+	mutex_lock(&drm->clients_lock);
 	list_add(&cli->head, &drm->clients);
-	mutex_unlock(&drm->client.mutex);
+	mutex_unlock(&drm->clients_lock);
 
 done:
 	if (ret && cli) {
@@ -1117,9 +1119,9 @@ nouveau_drm_postclose(struct drm_device *dev, struct drm_file *fpriv)
 		nouveau_abi16_fini(cli->abi16);
 	mutex_unlock(&cli->mutex);
 
-	mutex_lock(&drm->client.mutex);
+	mutex_lock(&drm->clients_lock);
 	list_del(&cli->head);
-	mutex_unlock(&drm->client.mutex);
+	mutex_unlock(&drm->clients_lock);
 
 	nouveau_cli_fini(cli);
 	kfree(cli);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 9d04d1b36434..550e5f335146 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -141,6 +141,11 @@ struct nouveau_drm {
 
 	struct list_head clients;
 
+	/**
+	 * @clients_lock: Protects access to the @clients list of &struct nouveau_cli.
+	 */
+	struct mutex clients_lock;
+
 	u8 old_pm_cap;
 
 	struct {
-- 
2.28.0

