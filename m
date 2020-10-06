Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064E728544B
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 00:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgJFWFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 18:05:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727582AbgJFWFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 18:05:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602021933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D0yKHCyJxum/tEvo7iuV0O9loM8q594QajFgJPXI2c4=;
        b=jV3iCbGRZ8MY8m1QOibtOh0sBplgSbigZsLVuXhGPZiwfnpv1rwRU5jwfJcNZA7MBnQzXm
        sSZLHcj26tM236MRNFq4NzxXGA/fidk5Plj8tOfBcaigzqtJkDenOGKB8oNfEllYGH7l5J
        cA5SRenuhB9mHfZ1CW2xlVG+xWR22Mk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-tbwAcPtgMU6wUd7v8ecvGw-1; Tue, 06 Oct 2020 18:05:31 -0400
X-MC-Unique: tbwAcPtgMU6wUd7v8ecvGw-1
Received: by mail-wm1-f72.google.com with SMTP id u82so16499wmu.4
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 15:05:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D0yKHCyJxum/tEvo7iuV0O9loM8q594QajFgJPXI2c4=;
        b=nGbh+hstOHeOE+IIB3K8CURi5voIu3JKkFsuw/KshpgdFnIcyo9gu1t4P0WZ2bhRfC
         i53PxFa1uUcC1Ov3oUA1Ci/dnP9JHlMWkeqf9Yr/UlEklPFnJUj6LH+HBHOCKMyqD230
         uq12OwLJIWITygszhCJt2wIz2yIWJLXgnoxs6QuS7MHr4lNDVpzDBsHz1SlDQ5DoP4L0
         GJ7p/s3jWFY96h/SxML3I3vRyPH4h5nH1NTNtRld4Yp5v4dB10jvH7jlc2Md3Sl1df4o
         WLrUBE1SKfd5w3N/KvEvfP/D7XPmzUsvJNYD4oKIcwSiT+Lp+OAMPJ9gRrwx1g+ca16V
         lvLg==
X-Gm-Message-State: AOAM533QPmLmrmK4rELdJ7l+SyPuOj4fgNPKOGNSS1VswPqShAqp1UIe
        le5PWqrJFAH5HC/xTw3GO5JqqMyS8VuVq9c770zMxN/uhFf4BaObZPZF2c5sKzVdLr/8HJtwX65
        y1ojgOCf4bNJPgcsH
X-Received: by 2002:adf:fd49:: with SMTP id h9mr33862wrs.115.1602021930624;
        Tue, 06 Oct 2020 15:05:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbg7nuJicaHR4v9MJENcMoSYOrRrx86lmMYFazGdMK/ndKQQAW9w7ksDntXUfpn4zS04aZEA==
X-Received: by 2002:adf:fd49:: with SMTP id h9mr33854wrs.115.1602021930461;
        Tue, 06 Oct 2020 15:05:30 -0700 (PDT)
Received: from kherbst.pingu.com ([2a02:8308:b088:c000:2bdf:b7aa:eede:d65f])
        by smtp.gmail.com with ESMTPSA id j17sm157785wrw.68.2020.10.06.15.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 15:05:29 -0700 (PDT)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>,
        dann frazier <dann.frazier@canonical.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, stable@vger.kernel.org,
        Jeremy Cline <jcline@redhat.com>
Subject: [PATCH 1/2] drm/nouveau/device: return error for unknown chipsets
Date:   Wed,  7 Oct 2020 00:05:27 +0200
Message-Id: <20201006220528.13925-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously the code relied on device->pri to be NULL and to fail probing
later. We really should just return an error inside nvkm_device_ctor for
unsupported GPUs.

Fixes: 24d5ff40a732 ("drm/nouveau/device: rework mmio mapping code to get rid of second map")

Signed-off-by: Karol Herbst <kherbst@redhat.com>
Cc: dann frazier <dann.frazier@canonical.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Jeremy Cline <jcline@redhat.com>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index 9f4ac2672cf2e..dcb70677d0acc 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -3149,6 +3149,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 		case 0x168: device->chip = &nv168_chipset; break;
 		default:
 			nvdev_error(device, "unknown chipset (%08x)\n", boot0);
+			ret = -ENODEV;
 			goto done;
 		}
 
-- 
2.26.2

