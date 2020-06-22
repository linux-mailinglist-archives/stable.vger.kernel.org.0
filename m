Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB52041FD
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgFVUbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:31:35 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41758 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgFVUbe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 16:31:34 -0400
Received: by mail-lj1-f195.google.com with SMTP id 9so20898726ljc.8;
        Mon, 22 Jun 2020 13:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8HniiSVoKsGZ/ERECfPVj/nc7IWNw6qhcYKMolA91Q=;
        b=kkHQvh6TZzt7nHJCyBC2Z1nAsqReS6OYsUKtq8UjPxrnTatF0GM6pQ5rRbSpLVU/5D
         wF+A3xzLkRJNrrOgM/o+b8YpFx0KskBf4PVrZS/595cRgQo5jNJxPTTcAVfD0uQzg5/Z
         QBWGnlBUhmR0aa1BpZ8hTNAFp2QEGwn3w6RiWATZm7U3mbfTobBVTzKl9UOR20yFRebW
         40O09U6MmZJe1ztdJffDg227RmP7F6ec0gY+hyAsgRqTQjmE3zv1XfpSuVED4sFhsj5U
         PesTXpe2gCvGe3/dkY5m6+YogTzERld4ksuto7HS3zYcx+1u1BOFHf5Z0wrNTZBrxxJY
         SF0A==
X-Gm-Message-State: AOAM533unRwAN4sOc1rIyDHgOWXKFRAwcNzG1d7d8UQjh+zUR1tvVVUQ
        q/CpOhmwBbaSbxM+btshO0c=
X-Google-Smtp-Source: ABdhPJz37T3KcEtin9mmO3jL3SyxSsPs1OmE+fOB967YPMpslsKyG6O5PxGgCQv2SwoUzBV2/HHFfg==
X-Received: by 2002:a2e:9a08:: with SMTP id o8mr9066001lji.126.1592857892366;
        Mon, 22 Jun 2020 13:31:32 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id y143sm2577314lff.88.2020.06.22.13.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 13:31:31 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc:     Denis Efremov <efremov@linux.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] drm/radeon: fix fb_div check in ni_init_smc_spll_table()
Date:   Mon, 22 Jun 2020 23:31:22 +0300
Message-Id: <20200622203122.25749-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

clk_s is checked twice in a row in ni_init_smc_spll_table().
fb_div should be checked instead.

Fixes: 69e0b57a91ad ("drm/radeon/kms: add dpm support for cayman (v5)")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/gpu/drm/radeon/ni_dpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index b57c37ddd164..c7fbb7932f37 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2127,7 +2127,7 @@ static int ni_init_smc_spll_table(struct radeon_device *rdev)
 		if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
 			ret = -EINVAL;
 
-		if (clk_s & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKS_SHIFT))
+		if (fb_div & ~(SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_FBDIV_SHIFT))
 			ret = -EINVAL;
 
 		if (clk_v & ~(SMC_NISLANDS_SPLL_DIV_TABLE_CLKV_MASK >> SMC_NISLANDS_SPLL_DIV_TABLE_CLKV_SHIFT))
-- 
2.26.2

