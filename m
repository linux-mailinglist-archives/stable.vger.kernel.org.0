Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0191A40EE8A
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 02:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241980AbhIQBBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 21:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhIQBBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 21:01:05 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D82C061574;
        Thu, 16 Sep 2021 17:59:44 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 61AA682D18;
        Fri, 17 Sep 2021 02:59:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1631840381;
        bh=bDuOrCdzoWsT+rs95Bjmzf6kn4ZJSlEQSQ56zrjHy00=;
        h=From:To:Cc:Subject:Date:From;
        b=XtwTVrXomL8ZRHqs6Dkl8BjlH0Ti6cypahlBILc0YUuU6lExCL5PBeihb/VNsEgmM
         3OR70Jf9aeUfE5x63S3MvYRTWg3oybdsN/CNUS10yU1c1/yH3M5OYGlWRrikSyLCJx
         /gM+hAolHkHatiPiRWU67/UQ8v6Sea7K9ydTR4Wch+T5GWRnG/2H560Er4q3qsmmMe
         zJl6bsrfLFH06uN+fXtC+C9glX+wcMnLs0o86XVuAdvNUe3DBG4MLkElYdLDWMmAa8
         33Ocksq5YJ3bCtXJBIB9Mut/+NZQ6xgwdwf6MvTSZ9bENMZ1EVL4OCs+pK3py1lVRY
         ZSb82sU7X5mlA==
From:   Marek Vasut <marex@denx.de>
To:     linux-arm-msm@vger.kernel.org
Cc:     freedreno@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] drm/msm: Avoid potential overflow in timeout_to_jiffies()
Date:   Fri, 17 Sep 2021 02:59:13 +0200
Message-Id: <20210917005913.157379-1-marex@denx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The return type of ktime_divns() is s64. The timeout_to_jiffies() currently
assigns the result of this ktime_divns() to unsigned long, which on 32 bit
systems may overflow. Furthermore, the result of this function is sometimes
also passed to functions which expect signed long, dma_fence_wait_timeout()
is one such example.

Fix this by adjusting the type of remaining_jiffies to s64, so we do not
suffer overflow there, and return a value limited to range of 0..INT_MAX,
which is safe for all usecases of this timeout.

The above overflow can be triggered if userspace passes in too large timeout
value, larger than INT_MAX / HZ seconds. The kernel detects it and complains
about "schedule_timeout: wrong timeout value %lx" and generates a warning
backtrace.

Note that this fixes commit 6cedb8b377bb ("drm/msm: avoid using 'timespec'"),
because the previously used timespec_to_jiffies() function returned unsigned
long instead of s64:
static inline unsigned long timespec_to_jiffies(const struct timespec *value)

Fixes: 6cedb8b377bb ("drm/msm: avoid using 'timespec'")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Cc: Rob Clark <robdclark@chromium.org>
Cc: stable@vger.kernel.org # 5.6+
---
NOTE: This is related to Mesa MR
      https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12886
---
 drivers/gpu/drm/msm/msm_drv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 0b2686b060c73..d96b254b8aa46 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -543,7 +543,7 @@ static inline int align_pitch(int width, int bpp)
 static inline unsigned long timeout_to_jiffies(const ktime_t *timeout)
 {
 	ktime_t now = ktime_get();
-	unsigned long remaining_jiffies;
+	s64 remaining_jiffies;
 
 	if (ktime_compare(*timeout, now) < 0) {
 		remaining_jiffies = 0;
@@ -552,7 +552,7 @@ static inline unsigned long timeout_to_jiffies(const ktime_t *timeout)
 		remaining_jiffies = ktime_divns(rem, NSEC_PER_SEC / HZ);
 	}
 
-	return remaining_jiffies;
+	return clamp(remaining_jiffies, 0LL, (s64)INT_MAX);
 }
 
 #endif /* __MSM_DRV_H__ */
-- 
2.33.0

