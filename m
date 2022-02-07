Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80804AC57D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 17:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiBGQWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 11:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381666AbiBGQOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 11:14:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2A57C0401D2
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644250488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IFrUiE399AWkgKFh5f0w6DFQ5l0IKVbpkKeYpipiJKA=;
        b=P+E63qIrFa2Pe1V+YkKGXWPaMAzf4Wbxr6IFHr2ZynCrMZuF7oZbY0ZXHFNSrRmMqYc0W1
        SVY8w8ArWn2/1UzsxKtkoTtOF7EKoOyXdTP1rWs9tsOaVtowIIEz+P1J56IoZp3tGl5xLE
        g1hWz+5INNRBjNiabcHWtH3irW4EesY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-YIHgJIFLO7SE0efwhHXyoA-1; Mon, 07 Feb 2022 11:14:46 -0500
X-MC-Unique: YIHgJIFLO7SE0efwhHXyoA-1
Received: by mail-wm1-f72.google.com with SMTP id c7-20020a1c3507000000b0034a0dfc86aaso12477332wma.6
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 08:14:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IFrUiE399AWkgKFh5f0w6DFQ5l0IKVbpkKeYpipiJKA=;
        b=inhobRKde19Duo1I/gdtckFBnJ1CXwKjL2tXiq1DVpuPpoYU42QNA+gCAqCyWZvKc0
         eOeF5EgvOEplphe8eiEFIpiaSftgfpvizRp70GRJP7yIxOdsCMj2NyVL8NCZiCwYVLVy
         6oiudYVlLiFVRrkIN3hYQaLd5bI5SOPe7lBBDWuoyGkgvxggN0A/ZTMqkNgm6pSM/dwG
         xF4nuMr4uRwhoIAEC/ZtDTBP1y55/K5dXTROby+DLoua/RuGoAtknFNy3AuaKycoAOQ2
         tFk73++XriZiYtllYLFLDk6dYNoM5+J5GNGmf8tFG+tdKJF67/iuN1CtajW+1CwlLBOt
         3UGA==
X-Gm-Message-State: AOAM5334MjCJH5cZhJDjtTWfmavrIzU/L0pfj5mTLqwKTEQsDMyc1nni
        I3e1M6t94IQfpgsCuHIRL5bU5uSM61J/oM7In7/QXI0h2MiZSHuzzU0TSILQrhsE1EQ4+3+p+aM
        iTdTiFU1mrMFIysPY
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr178622wrq.6.1644250484835;
        Mon, 07 Feb 2022 08:14:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxag/VMAQvDNvrhkp9126/FEr3+jzTAsqTwom1rxeqdyBy5yKiDpvjeiVrKAD+kaImszZyfLA==
X-Received: by 2002:a5d:40ca:: with SMTP id b10mr178611wrq.6.1644250484657;
        Mon, 07 Feb 2022 08:14:44 -0800 (PST)
Received: from kherbst.pingu.com (ip1f10bb48.dynamic.kabel-deutschland.de. [31.16.187.72])
        by smtp.gmail.com with ESMTPSA id f8sm12358148wry.12.2022.02.07.08.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:14:44 -0800 (PST)
From:   Karol Herbst <kherbst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Karol Herbst <kherbst@redhat.com>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS),
        nouveau@lists.freedesktop.org (open list:DRM DRIVER FOR NVIDIA
        GEFORCE/QUADRO GPUS)
Subject: [PATCH] drm/nouveau/mmu: fix reuse of nvkm_umem
Date:   Mon,  7 Feb 2022 17:14:42 +0100
Message-Id: <20220207161443.1843660-1-kherbst@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am not entirely sure if this fixes anything, but the code standed out
while investigated problematic calls to vunmap.

nvkm_umem.io is only ever set for the NVKM_OBJECT_MAP_IO case in
nvkm_umem_map, but never for the NVKM_OBJECT_MAP_VA one, which could lead
to taking the wrong patch inside nvkm_umem_unmap.

I just don't know if this is a real issue or not, but the code doesn't
look correct this way.

Fixes: c83c4097eba8 ("drm/nouveau/mmu: define user interfaces to mmu memory allocation")
Cc: <stable@vger.kernel.org> # v4.15+
---
 drivers/gpu/drm/nouveau/nvkm/subdev/mmu/umem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/umem.c b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/umem.c
index e530bb8b3b17..2608e0796066 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/umem.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/mmu/umem.c
@@ -102,6 +102,7 @@ nvkm_umem_map(struct nvkm_object *object, void *argv, u32 argc,
 		*handle = (unsigned long)(void *)umem->map;
 		*length = nvkm_memory_size(umem->memory);
 		*type = NVKM_OBJECT_MAP_VA;
+		umem->io = false;
 		return 0;
 	} else
 	if ((umem->type & NVKM_MEM_VRAM) ||
@@ -112,12 +113,11 @@ nvkm_umem_map(struct nvkm_object *object, void *argv, u32 argc,
 			return ret;
 
 		*type = NVKM_OBJECT_MAP_IO;
-	} else {
-		return -EINVAL;
+		umem->io = true;
+		return 0;
 	}
 
-	umem->io = (*type == NVKM_OBJECT_MAP_IO);
-	return 0;
+	return -EINVAL;
 }
 
 static void *
-- 
2.34.1

