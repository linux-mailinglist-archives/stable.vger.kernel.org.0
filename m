Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03F6DECBF
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 14:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfJUMtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 08:49:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35033 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728479AbfJUMtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 08:49:21 -0400
Received: by mail-pg1-f194.google.com with SMTP id c8so2954492pgb.2;
        Mon, 21 Oct 2019 05:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=+q3Pz7iL34R36Jp34sL215JsL0y1yMeb6aT9y4kfQGo=;
        b=HL1CGUD6Nz7+su39RPl9DRZCvAkH4cA/DgGsB0v7D7/OojLwQ2HtZTC6R+Y/HKIT/C
         ArlkbztVJx40v0JIKm0kOqhgtdcuogxNq5NFHTMURWlAz2mvhG85xEQT2lPImT7LMwZc
         iE9AhrrO7/OvolJVcURhbxbLcGakEtPTgJDJrp9Wc78TJ2fE3mfi/0ute/HbAV+j1v4H
         pXvppoJXLCdLKfGaL9+8wIGbai6GuK02eCwxSoSebFUEDRvkCWB6yQmXJKF1R0YdsZ4i
         YmIfzuBWPPEBK37R8y5hh3t5RqTIcGaZZx46oi/ZoJv6fx0NrF7sAuBObkDydd4aAW7Z
         e9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=+q3Pz7iL34R36Jp34sL215JsL0y1yMeb6aT9y4kfQGo=;
        b=n6QzW0Loz5bisVQ59X89/uIcuxsMUIWKb7Qy1bds8XXQo160WQ7qqvLsDmfS9gxWcb
         WnBokOIENAa1eo4iFxYRvWudIgxeOomEmCfJTSqyJC6V2WFVAV0V9LrjM6UQ8qKoyeUs
         h9MQxMl/HO6TADTKCPyCRt5aFcyAlPiNsm5aZwrv/k40NOWix9EOiB/L8lsCD5YPY5Rd
         H2Gz5+MKAitVx5PxqVEb2TfUkq3Yuusc3V5HcONLHAhGjL/Tt5kAtzOABrGriV7rgfrE
         QzfhEyUhZLjryiMOQagIQMLarBs9NwBM1ihvwKPgD/iH1NyU4yeVlivz+xWq6y+YGPm+
         EDUQ==
X-Gm-Message-State: APjAAAXPud0dDoZx6gF8PhRo5IAPZ+Z/EwNVH5r/dUpna55Xg7TdJFCC
        xqCTjGQLvl6ESzbEKaGFVfY=
X-Google-Smtp-Source: APXvYqxossI4aU6pwFJhCfrqbj+HZM5LrpmwZru5RzRY1sbBA19PrYqquaB2cYODlJ4r1w8mqqfQvw==
X-Received: by 2002:a63:cb4c:: with SMTP id m12mr12957134pgi.58.1571662160373;
        Mon, 21 Oct 2019 05:49:20 -0700 (PDT)
Received: from software.domain.org ([66.42.68.162])
        by smtp.gmail.com with ESMTPSA id b3sm13562285pjp.13.2019.10.21.05.49.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 21 Oct 2019 05:49:19 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        chenhuacai@gmail.com, linux-kernel@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 110/110] lib/vdso: Improve do_hres() and update vdso data unconditionally
Date:   Mon, 21 Oct 2019 20:52:00 +0800
Message-Id: <1571662320-1280-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In do_hres(), we currently use whether the return value of __arch_get_
hw_counter() is negative to indicate fallback, but this is not a good
idea because:

1, ARM64 returns ULL_MAX but MIPS returns 0 when clock_mode is invalid;
2, For a 64bit counter, a "negative" value of counter is actually valid.

It is sure that MIPS has a bug when clock_mode is invalid and should
return ULL_MAX as ARM64 does (Vincenzo has already submitted a patch).
But do_hres() can still be improved so we use U64_MAX as the only
"invalid" return value -- this is still not fully correct, but it is
the simplest fix and has no problem in most cases (we can hardly see a
64bit counter overflow).

By the way, currently update_vdso_data() and update_vsyscall_tz() rely
on __arch_use_vsyscall(), which causes __cvdso_clock_getres() and some
other functions get wrong results when clock_mode is invalid. So, we
update vdso data unconditionally.

Fixes: 00b26474c2f1613d7ab894c5 ("lib/vdso: Provide generic VDSO implementation")
Fixes: 44f57d788e7deecb50484353 ("timekeeping: Provide a generic update_vsyscall() implementation")
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 kernel/time/vsyscall.c  | 9 +++------
 lib/vdso/gettimeofday.c | 2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/time/vsyscall.c b/kernel/time/vsyscall.c
index 4bc37ac..5ee0f77 100644
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -110,8 +110,7 @@ void update_vsyscall(struct timekeeper *tk)
 	nsec		= nsec + tk->wall_to_monotonic.tv_nsec;
 	vdso_ts->sec	+= __iter_div_u64_rem(nsec, NSEC_PER_SEC, &vdso_ts->nsec);
 
-	if (__arch_use_vsyscall(vdata))
-		update_vdso_data(vdata, tk);
+	update_vdso_data(vdata, tk);
 
 	__arch_update_vsyscall(vdata, tk);
 
@@ -124,10 +123,8 @@ void update_vsyscall_tz(void)
 {
 	struct vdso_data *vdata = __arch_get_k_vdso_data();
 
-	if (__arch_use_vsyscall(vdata)) {
-		vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
-		vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
-	}
+	vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
+	vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
 
 	__arch_sync_vdso_data(vdata);
 }
diff --git a/lib/vdso/gettimeofday.c b/lib/vdso/gettimeofday.c
index e630e7f..5a31643 100644
--- a/lib/vdso/gettimeofday.c
+++ b/lib/vdso/gettimeofday.c
@@ -50,7 +50,7 @@ static int do_hres(const struct vdso_data *vd, clockid_t clk,
 		cycles = __arch_get_hw_counter(vd->clock_mode);
 		ns = vdso_ts->nsec;
 		last = vd->cycle_last;
-		if (unlikely((s64)cycles < 0))
+		if (unlikely(cycles == U64_MAX))
 			return -1;
 
 		ns += vdso_calc_delta(cycles, last, vd->mask, vd->mult);
-- 
2.7.0

