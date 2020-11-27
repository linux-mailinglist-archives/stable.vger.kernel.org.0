Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAED2C6BAC
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 19:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgK0Sjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 13:39:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgK0Sjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 13:39:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606502374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ou0ihm1ZRJ4jAkiF1iCHhrbt5Qjc5Z5KkD4Hf0ZuyHI=;
        b=irShDVZNqE773dN0UVTJG84jxnN5PIrYmmD9CGzYmiRURHEw+MzWBiitkfx6yPtBLOJEHV
        uGZWNYFKp+fH5BP2Hs4sn9KSwZV/uIXA60b7P5B85dkqqKhhLR8JNemvlNebOot3Fab+86
        UIxkxF0wXW1z/bczwOx/0mQOkoV25wQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-6AfhDPk2NdCZVXoUyo5eqQ-1; Fri, 27 Nov 2020 13:39:33 -0500
X-MC-Unique: 6AfhDPk2NdCZVXoUyo5eqQ-1
Received: by mail-ed1-f72.google.com with SMTP id dc6so594786edb.14
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 10:39:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ou0ihm1ZRJ4jAkiF1iCHhrbt5Qjc5Z5KkD4Hf0ZuyHI=;
        b=i3r4GGL67dr+Q+ArwxJ3d/sVctEmiNOP+5mx4gAjyxZaloabfP/GpGqBI4FdUF+xy7
         /dRTVVkQ/c5OYmog6RQila8nbkDA4ILCAbxIY2wl03YWtaohvpTrOnsdpGnO4/Vx7IGM
         53LxwJXX4bYPHNcP900cmK7ymnXTL3cuIOgqsU59ge22Up/zGC9glDjKKQV+Y3aq/6f1
         w9pJKYZKxtS4smZkYlKrUjxXi8rbhQ+4cBrrPzCb9edfcjNnRKHkO9VCDKY0/Ms5quh5
         BaPmFk4BW3mtEkZW4Tzz+KmbMKh7b8SFcS/mqsJ4pSQBoY5qZ5SRnKwisNt9E8/tzLFA
         7L7Q==
X-Gm-Message-State: AOAM532edzS723P02Q+54gfOq/+OwXNaTnn7XhE2s0sa6qjHW6VEo2Pu
        pNsgiRWXogMAwVJlj65rFPvP4T4JvywuniuazEJcRjZacQe6ARD0F0wneTPFa+iakXjFK2wyRih
        lOXyiWn4G0ACEciUC
X-Received: by 2002:aa7:c904:: with SMTP id b4mr6985017edt.172.1606502372216;
        Fri, 27 Nov 2020 10:39:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwkC3Xbd/F8jXTqnu8Pk3oYFYI/QqYutxzTOWWhOtVlAUxDjUzKUNCD5oqIgPKX1Dx8fwIt/A==
X-Received: by 2002:aa7:c904:: with SMTP id b4mr6985003edt.172.1606502372082;
        Fri, 27 Nov 2020 10:39:32 -0800 (PST)
Received: from kherbst.pingu.com ([2a02:8308:b088:c000:e1c8:454f:b858:87a5])
        by smtp.gmail.com with ESMTPSA id l22sm1003900ejk.14.2020.11.27.10.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 10:39:31 -0800 (PST)
From:   Karol Herbst <kherbst@redhat.com>
To:     nouveau@lists.freedesktop.org
Cc:     Karol Herbst <kherbst@redhat.com>, stable@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        Mark Pearson <markpearson@lenovo.com>
Subject: [PATCH] drm/nouveau/kms: handle mDP connectors
Date:   Fri, 27 Nov 2020 19:39:09 +0100
Message-Id: <20201127183909.2089734-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In some cases we have the handle those explicitly as the fallback
connector type detection fails and marks those as eDP connectors.

Attempting to use such a connector with mutter leads to a crash of mutter
as it ends up with two eDP displays.

Information is taken from the official DCB documentation.

Cc: stable@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: Ben Skeggs <bskeggs@redhat.com>
Reported-by: Mark Pearson <markpearson@lenovo.com>
Tested-by: Mark Pearson <markpearson@lenovo.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
---
 drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h | 1 +
 drivers/gpu/drm/nouveau/nouveau_connector.c             | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h b/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
index f5f59261ea81..d1beaad0c82b 100644
--- a/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
+++ b/drivers/gpu/drm/nouveau/include/nvkm/subdev/bios/conn.h
@@ -14,6 +14,7 @@ enum dcb_connector_type {
 	DCB_CONNECTOR_LVDS_SPWG = 0x41,
 	DCB_CONNECTOR_DP = 0x46,
 	DCB_CONNECTOR_eDP = 0x47,
+	DCB_CONNECTOR_mDP = 0x48,
 	DCB_CONNECTOR_HDMI_0 = 0x60,
 	DCB_CONNECTOR_HDMI_1 = 0x61,
 	DCB_CONNECTOR_HDMI_C = 0x63,
diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 8b4b3688c7ae..4c992fd5bd68 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1210,6 +1210,7 @@ drm_conntype_from_dcb(enum dcb_connector_type dcb)
 	case DCB_CONNECTOR_DMS59_DP0:
 	case DCB_CONNECTOR_DMS59_DP1:
 	case DCB_CONNECTOR_DP       :
+	case DCB_CONNECTOR_mDP      :
 	case DCB_CONNECTOR_USB_C    : return DRM_MODE_CONNECTOR_DisplayPort;
 	case DCB_CONNECTOR_eDP      : return DRM_MODE_CONNECTOR_eDP;
 	case DCB_CONNECTOR_HDMI_0   :
-- 
2.28.0

