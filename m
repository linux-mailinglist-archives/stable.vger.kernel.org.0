Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BF72793CB
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 23:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgIYVzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 17:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgIYVzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 17:55:35 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD9CC0613CE
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 14:55:34 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c2so3610211ljj.12
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 14:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeTL0c/7JNOZbHDDafGIj2Lq9RezRDqi3GjRLXy3MsM=;
        b=pVGittCTqyTKqdvnYw2YphLU++ysqA22ptlbtdIiK4INItNg77NscljoTBoNwuQF9G
         lq4iY831pPMXw1xmkRNDWa3VzqlQe9Q4x+HwoNYH8C2Q4rgVpA+pSXs9VGq8zrCsjZDe
         ds5Bd0uh20DgrUA7XfoKF+/Z4q3UstXzX+RD8c1rPxSd4E97oDiExrezqx4XZUUYqcAE
         g1+/xJHNi+MlZRO1wb+g2TKz350ARMIBcDM2cMsk9vqus0iFKA+vDmJ5tMQDWa9ekXv/
         kKI21HYapqXBDQVv46R3+M1H6L0+brO4XWTpVRhCYVqKtHEUEvYCZWGgXF0IQ3DdDmMO
         t4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SeTL0c/7JNOZbHDDafGIj2Lq9RezRDqi3GjRLXy3MsM=;
        b=UXbl9QFEd1Mve6m58v0jAPMMMearfoaq+IQD0IgEPo3hVi2xefSSR/gidxu6IuF7ej
         savNYSXPmKAQoE0NUM96A7VtovPIdw5McIwKbwgOWMmEUFEphhQd/3VQ/6Za0z6tg1FQ
         Bwd+5ZYbHyLzcV5pcMEJqALiCy2DxxHlkJ7HJcXpGhUjOylddQoymjK9kitsWbmvOs5/
         wjQMq+X0aDmdgcLlTA5b2UpCNN8QpMgk3m01btXEk74JAcsDcmdf7sTW+EyUJYAOYdxt
         IQBDf/50X4X2oV8QCGCa6mhxe8zL9Ncqt9bZEOQKiktVkOifAWd7cJROhnbi/eLrhx7F
         oIIg==
X-Gm-Message-State: AOAM533XDK+dIFCTvK2vepz0XrDkmechQ1gIRoF8QmSjvDXxZ8TwCg0v
        XsOULfT69Zrbh14CwUhWM/M=
X-Google-Smtp-Source: ABdhPJx6ytnXJvCZhen05QP8JCFosKED8273RviYERaPsmA21OzhS4aeWsWvQ4UgzSKTTJs019juqg==
X-Received: by 2002:a05:651c:1188:: with SMTP id w8mr2131504ljo.344.1601070933023;
        Fri, 25 Sep 2020 14:55:33 -0700 (PDT)
Received: from saturn.localdomain ([2a00:fd00:805f:db00:3926:b59a:e618:9f9c])
        by smtp.gmail.com with ESMTPSA id j8sm261277lfr.80.2020.09.25.14.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 14:55:32 -0700 (PDT)
Sender: Sam Ravnborg <sam.ravnborg@gmail.com>
From:   Sam Ravnborg <sam@ravnborg.org>
To:     dri-devel@lists.freedesktop.org, Heiko Stuebner <heiko@sntech.de>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>, stable@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v1 1/2] drm/rockchip: fix build due to undefined drm_gem_cma_vm_ops
Date:   Fri, 25 Sep 2020 23:55:23 +0200
Message-Id: <20200925215524.2899527-2-sam@ravnborg.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925215524.2899527-1-sam@ravnborg.org>
References: <20200925215524.2899527-1-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 0d590af3140d ("drm/rockchip: Convert to drm_gem_object_funcs")
introduced the following build error:

rockchip_drm_gem.c:304:13: error: ‘drm_gem_cma_vm_ops’ undeclared here
  304 |  .vm_ops = &drm_gem_cma_vm_ops,
      |             ^~~~~~~~~~~~~~~~~~
      |             drm_gem_mmap_obj

Fixed by adding missing include file.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Sandy Huang <hjc@rock-chips.com>
Cc: "Heiko Stübner" <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org
---
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index bb3578469b03..6da15faf0192 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -10,6 +10,7 @@
 
 #include <drm/drm.h>
 #include <drm/drm_gem.h>
+#include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_prime.h>
 #include <drm/drm_vma_manager.h>
 
-- 
2.25.1

