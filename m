Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A34431C7E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhJRNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhJRNjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A9FE613E6;
        Mon, 18 Oct 2021 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563974;
        bh=Djm/Wz8BkBkqc/s435I7JSTKaCq4zCtqGrnv56ShB8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BxpCjVuhTMkkvRrEylmiTl5ReoJ346uF+d+qGA+Ny4O+9yRBQK9axKiQn9VP4XL0t
         SfG73Z+mRB75/4jlAuMZJpY+hYERFg3Q8KXcfmCtumq7NTN8kzq/1qqAJRa0RTE2MS
         77L9CmOYTrN34zd1pv+7ZG60KQtvMD8I03PC17bc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 5.10 018/103] drm/msm: Avoid potential overflow in timeout_to_jiffies()
Date:   Mon, 18 Oct 2021 15:23:54 +0200
Message-Id: <20211018132335.315869640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 171316a68d9a8e0d9e28b7cf4c15afc4c6244a4e upstream.

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
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210917005913.157379-1-marex@denx.de
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_drv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -543,7 +543,7 @@ static inline int align_pitch(int width,
 static inline unsigned long timeout_to_jiffies(const ktime_t *timeout)
 {
 	ktime_t now = ktime_get();
-	unsigned long remaining_jiffies;
+	s64 remaining_jiffies;
 
 	if (ktime_compare(*timeout, now) < 0) {
 		remaining_jiffies = 0;
@@ -552,7 +552,7 @@ static inline unsigned long timeout_to_j
 		remaining_jiffies = ktime_divns(rem, NSEC_PER_SEC / HZ);
 	}
 
-	return remaining_jiffies;
+	return clamp(remaining_jiffies, 0LL, (s64)INT_MAX);
 }
 
 #endif /* __MSM_DRV_H__ */


