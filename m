Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6851F1BDF
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 17:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgFHPRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 11:17:44 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37113 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730220AbgFHPRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 11:17:42 -0400
Received: by mail-lj1-f194.google.com with SMTP id e4so21008384ljn.4;
        Mon, 08 Jun 2020 08:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OsWMPsmZoyIJzuygJAaRJCsAmuz070EmkzRigfL9BXc=;
        b=h11QtlVxQVU2MeFrxPO28lfUOn/bKnfCvp5z50lW9G13BNoMCyJXWuGsG4LGUtezXa
         9jDiHsEpRBOXn7CZt2m+rG+Ro/X1t3pzn+4BG7vyxNrxDHIAovZ+2uzi0/VFjvY6XRJH
         q1fcO9p/nGnQv9SJv/b/P5LAKNFHvMEztHL6MYho58j0oypMm1rCEnZfcu4jLojZ4qou
         fTulMXVCf9eKRHKrRbDH65tjs2gJ8AGxDPXf7HVoqdmzAIUJGExLl/I615sudMvJ+/X1
         ovFkyIQalXz6wyPCYDPUz/QHSgUZgpAwIRxJtsna9rI9K60f43ys3Yw5eNdp8Cwt80qT
         CnyA==
X-Gm-Message-State: AOAM530lDC/izRbtj8zFHlkqEmFMtSzEmZMQabadlRQK/GdMXkJDpdR2
        uGCCOJvr4enIr5kUl97GVto=
X-Google-Smtp-Source: ABdhPJzDUCdm1G2TGpfofl/wlFzlXPT1eIy4dTUHaK0MG2U+WNevg620xxVGee8AVKlTDm/4kibqzg==
X-Received: by 2002:a2e:2f0a:: with SMTP id v10mr11160069ljv.163.1591629460131;
        Mon, 08 Jun 2020 08:17:40 -0700 (PDT)
Received: from localhost.localdomain ([213.87.137.116])
        by smtp.googlemail.com with ESMTPSA id x28sm4416704lfg.86.2020.06.08.08.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 08:17:39 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Denis Efremov <efremov@linux.com>,
        Steven Price <steven.price@arm.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2] drm/panfrost: Use kvfree() to free bo->sgts
Date:   Mon,  8 Jun 2020 18:17:28 +0300
Message-Id: <20200608151728.234026-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200605185207.76661-1-efremov@linux.com>
References: <20200605185207.76661-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use kvfree() to free bo->sgts, because the memory is allocated with
kvmalloc_array() in panfrost_mmu_map_fault_addr().

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
Change in v2:
 - kvfree() fixed in panfrost_gem_free_object(), thanks to Steven Price

 drivers/gpu/drm/panfrost/panfrost_gem.c | 2 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 17b654e1eb94..556181ea4a07 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -46,7 +46,7 @@ static void panfrost_gem_free_object(struct drm_gem_object *obj)
 				sg_free_table(&bo->sgts[i]);
 			}
 		}
-		kfree(bo->sgts);
+		kvfree(bo->sgts);
 	}
 
 	drm_gem_shmem_free_object(obj);
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index ed28aeba6d59..3c8ae7411c80 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -486,7 +486,7 @@ static int panfrost_mmu_map_fault_addr(struct panfrost_device *pfdev, int as,
 		pages = kvmalloc_array(bo->base.base.size >> PAGE_SHIFT,
 				       sizeof(struct page *), GFP_KERNEL | __GFP_ZERO);
 		if (!pages) {
-			kfree(bo->sgts);
+			kvfree(bo->sgts);
 			bo->sgts = NULL;
 			mutex_unlock(&bo->base.pages_lock);
 			ret = -ENOMEM;
-- 
2.26.2

