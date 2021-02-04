Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C066030F9BD
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 18:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbhBDRbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 12:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbhBDRaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 12:30:15 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0C1C061794
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 09:29:15 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id m13so4447528wro.12
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 09:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lPYBVdllGLJ3bXLXYmMIkSoN54YSFIG3csr7TETPut8=;
        b=BIOQPa/49drpGC8qLqHVmeB5plHAsLeshzqlg+CctgCv3a6baDU0vfUQt24nzdeRnc
         XcEYqLikaPsc58jUDBwGvYrL1tq/j9FX9nlfnGeuDKfs81+ZrQR+Zl/5HTjAfOL34i/n
         wdp9wZ1PXZ/l0I0N7VpcWeBfM+j4sohyca9r+eujo62RwDt0Rc8ZlrBM3Faj/AdsHFi+
         AZvG/F5tTc/mZHf+lKfr5aAz8owmcE9OeMN4/0SYFtU/iZd06A/60qiR8FAoBm38L3zo
         LTiTgKzCsLF/xMX6mC9JNvW3KmNV1ABoEE8bmDtyGjM7v3lLk+obSq4jfgEN57k+p4CD
         d4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lPYBVdllGLJ3bXLXYmMIkSoN54YSFIG3csr7TETPut8=;
        b=dym6AvR43lvbC5XNoYeZhV9kPQnfA/6ipY3NMMSv2O28Pv79dsHGjvhj9pnaE4TnV1
         Tyws+DZQgrfCCbanJJ0vCyUcjFjxsIgEmeB4KEZdxNV6Pp0RIsGu1gaMMaCbeZxtpSsm
         uSgrrX/abSTAk8EVJmEdkU/GgfgfNU2rRPU92HK5pdRiDAxjh4gr/S3DpSatxVawKZBo
         o0QNCE0SizYz3L9CfmF0amA6najOvtonUa+zJ3LPmt2bcpT3NZ+uhbX/QOm0AMsV3nbi
         GRIPdRsN1AcD2uf+0mr5JLk2K6h5fGEdPGOeYzCYOyTTuhr3MPGCMeV2mOhe7w3FyvSB
         WhMg==
X-Gm-Message-State: AOAM532WtPgiWW134qSU74SBRGSgsIrFsgCPEVdFUiqf3zRYD2/+qTj3
        8LCx1O47lgi1WP7ofvgPYpnBtZqUZsuWhA==
X-Google-Smtp-Source: ABdhPJxYZd6EeCCvTGsCsKIVKSVuVb3lgQ/yd3SOhIYjKogTTk3zohIsEnXam5NNoGk9AJsD0EiXdQ==
X-Received: by 2002:a5d:5502:: with SMTP id b2mr413960wrv.245.1612459753662;
        Thu, 04 Feb 2021 09:29:13 -0800 (PST)
Received: from dell.default ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id j7sm9641334wrp.72.2021.02.04.09.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:29:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/10] futex: Replace pointless printk in fixup_owner()
Date:   Thu,  4 Feb 2021 17:28:58 +0000
Message-Id: <20210204172903.2860981-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204172903.2860981-1-lee.jones@linaro.org>
References: <20210204172903.2860981-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 04b79c55201f02ffd675e1231d731365e335c307 ]

If that unexpected case of inconsistent arguments ever happens then the
futex state is left completely inconsistent and the printk is not really
helpful. Replace it with a warning and make the state consistent.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 kernel/futex.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 780872ac7d675..a247942d69799 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2412,14 +2412,10 @@ static int fixup_owner(u32 __user *uaddr, struct futex_q *q, int locked)
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
-	 * the owner of the rt_mutex.
+	 * the owner of the rt_mutex. Warn and establish consistent state.
 	 */
-	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current) {
-		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
-				"pi-state %p\n", ret,
-				q->pi_state->pi_mutex.owner,
-				q->pi_state->owner);
-	}
+	if (WARN_ON_ONCE(rt_mutex_owner(&q->pi_state->pi_mutex) == current))
+		return fixup_pi_state_owner(uaddr, q, current);
 
 out:
 	return ret ? ret : locked;
-- 
2.25.1

