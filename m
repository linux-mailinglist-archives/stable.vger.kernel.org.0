Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2C4488B80
	for <lists+stable@lfdr.de>; Sun,  9 Jan 2022 19:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbiAISLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 13:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbiAISLu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 13:11:50 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF76FC06173F;
        Sun,  9 Jan 2022 10:11:49 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id pf13so2922817pjb.0;
        Sun, 09 Jan 2022 10:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version:reply-to
         :organization:content-transfer-encoding;
        bh=tNvI+a7A8PS5Wd2PToIgDMYPiKE2u7O11qPaKJfdtO8=;
        b=hFx4PqOcNZK5MuhbcALaswLAWpYR63pmyKMyh3S1r4Dkx2YT9LsxaoSfGDgGTqktAB
         izsb8drDwggw5idyFf8BE9Yx6Z/c8yjegszok9iAO31xvjdvQgHKJPMkB+bmVambspHc
         edGrF9kxxltrQOgWkEx4t/iW9GCDaq7dIKgswpbPRWCAnZ3e+wq4b9erEaNphdtClGFP
         uZZSLB2zsU2s67S2/TBCfDocJUGkJLfaSbNvoI0sbpD1OTkK8103AhbEPjYs4TdsIkw/
         lzzlNlbbb09ddQ87s3T0ZlaaIxY6wZreQrPPhkVmmMJNYgUWceNQJA0ElerW1/m3Inwe
         q+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:reply-to:organization:content-transfer-encoding;
        bh=tNvI+a7A8PS5Wd2PToIgDMYPiKE2u7O11qPaKJfdtO8=;
        b=4Pjgb3CPlWtVXA4QwXi1vZnFqUH3BgRvt+Fq9p7YnCVs+qiTeX4DEPZpaOKXO2OUeo
         r/6psmJP6KsB+qtowYLXwGo8mGaFKQAc+z+huW0o3jtH7xLUAJMPMvKYkpaJOOdcOUuL
         mJUfIEyCy8rRLxFMR4ThCJoZQGojTOvjgvmiELIHlXt27Vdo3lo2AsPTJHekajP5jRui
         5TpOrH9mIMKRrtEqEUYcED1IqAnsNvxDqMbnT4ih8Zxq1r6m0LEHaAH5+FOcgrjlPTAQ
         2LXbUD4RHgYrtR07UyVIH7STwLW04YOO13+GDR8Jh15o7K5wH6PT0F0BHyyJuYBeN1sp
         cmFg==
X-Gm-Message-State: AOAM532XbhxYf1awFYQ4UVXWe1u3BOiUgLWZ6Jq3L9Km89PNG2PVmcBb
        SKt5oIYsyqXMPVPL1sBBLi6D7O0jOgRijg==
X-Google-Smtp-Source: ABdhPJyh8djCs5KBhtHmWvs+w17xnphZd7/tx119erntsFX9510Pj8MdMJrgE3jzC2Hewn4vcst2iQ==
X-Received: by 2002:a17:90b:4c11:: with SMTP id na17mr27193063pjb.84.1641751909234;
        Sun, 09 Jan 2022 10:11:49 -0800 (PST)
Received: from localhost.localdomain (h69-131-29-103.cntcnh.broadband.dynamic.tds.net. [69.131.29.103])
        by smtp.gmail.com with ESMTPSA id j4sm4372827pfj.34.2022.01.09.10.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 10:11:48 -0800 (PST)
Sender: Len Brown <lenb417@gmail.com>
From:   Len Brown <lenb@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH REGRESSION] Revert "drm/amdgpu: stop scheduler when calling hw_fini (v2)"
Date:   Sun,  9 Jan 2022 13:11:37 -0500
Message-Id: <8ab406c8bb2e58969668a806a529d5988b447530.1641750730.git.len.brown@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Len Brown <len.brown@intel.com>

This reverts commit f7d6779df642720e22bffd449e683bb8690bd3bf.

This bisected regression has impacted suspend-resume stability
since 5.15-rc1. It regressed -stable via 5.14.10.

https://bugzilla.kernel.org/show_bug.cgi?id=215315

Fixes: f7d6779df64 ("drm/amdgpu: stop scheduler when calling hw_fini (v2)")
Cc: Guchun Chen <guchun.chen@amd.com>
Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: <stable@vger.kernel.org> # 5.14+
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 9afd11ca2709..45977a72b5dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -547,9 +547,6 @@ void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
-		if (!ring->no_scheduler)
-			drm_sched_stop(&ring->sched, NULL);
-
 		/* You can't wait for HW to signal if it's gone */
 		if (!drm_dev_is_unplugged(adev_to_drm(adev)))
 			r = amdgpu_fence_wait_empty(ring);
@@ -609,11 +606,6 @@ void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
-		if (!ring->no_scheduler) {
-			drm_sched_resubmit_jobs(&ring->sched);
-			drm_sched_start(&ring->sched, true);
-		}
-
 		/* enable the interrupt */
 		if (ring->fence_drv.irq_src)
 			amdgpu_irq_get(adev, ring->fence_drv.irq_src,
-- 
2.25.1

