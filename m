Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE6E1F001A
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 20:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgFESwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 14:52:10 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44144 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgFESwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 14:52:10 -0400
Received: by mail-lj1-f193.google.com with SMTP id c17so12967715lji.11;
        Fri, 05 Jun 2020 11:52:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VDO4czZARJ92nQWa2/saOEN9Dw2btZE7+XJd2+JWZwg=;
        b=YYzDInYFLkx/sjR483zpjcaGBas19dSxEO9Ktfn5lUREcAWhrHhVU/cdi/Q5Qt9Q2q
         HpRwRweIpyEivbxp/cHhetwyvJg1gfERwFAtwqma6jXKbnaDzHgS3w3yNeBX+wVlJ9dO
         9wwcMfHke5u8xjnY9vcOFnQxJVh0B4kbA323uyHzhEXUU4x+GR08NBEZDh1U6t2oimVv
         vkKQjo0cULZqKKbarRRs00DuCpdtqHlJ082kP+6lg4qhJi57Mmb8suNzuvErsunmD3Bt
         yTh7nuHZiwNeTCxJrSv5gF8sNPIt1dNYl7b2+YDTBiecJApF4kyNv6yj+OYl8Wahicnt
         UzuA==
X-Gm-Message-State: AOAM533PvGXCNRmIFQqv+NKkGpz2Zb1FYZ2aEwDvlKhpqCXonzFK49uK
        0UmUylP+wG9Jh1YqowvlJak=
X-Google-Smtp-Source: ABdhPJyIan/7VLcAaDDYG9UbJg5UdB3j2H3sSeQLJ35gqhMbLfIWcVftnxCOgq6DW3rAJlcuOVAA/w==
X-Received: by 2002:a2e:9786:: with SMTP id y6mr5299018lji.398.1591383128001;
        Fri, 05 Jun 2020 11:52:08 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id z22sm1273460lfi.96.2020.06.05.11.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 11:52:07 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Denis Efremov <efremov@linux.com>, Rob Herring <robh@kernel.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Steven Price <steven.price@arm.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] drm/panfrost: Use kvfree() to free bo->sgts in panfrost_mmu_map_fault_addr()
Date:   Fri,  5 Jun 2020 21:52:07 +0300
Message-Id: <20200605185207.76661-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use kvfree() to free bo->sgts, because the memory is allocated with
kvmalloc_array().

Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

