Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26EBE28C8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 05:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404055AbfJXDZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 23:25:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39026 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390629AbfJXDZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 23:25:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id s17so11117918plp.6;
        Wed, 23 Oct 2019 20:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=hL+v0VkC8nJZ/yYasVVgoGkbvgueSaBBRK1E46vpngU=;
        b=cfP9jwhqOFa3Vyoo5fskQENeWHMYsaigLQ8xtjIEM5zJoA+Rq1Ue06Np5/krsZaMIw
         l/EQ2wbVLdCWYJAt1DcFCMNA8NIGRky3whO9LVAAQAALv9qr/uUgTVJveuDwr279TvN1
         JX9y/RURDl96/B5aq8Lxyzzg96YbhzeARNUhFz8ehVls68FvU1lMOVk6nlrr0OyHTO1/
         LO3bhuZgjxvH3RwjXK1nHRmHbfVs+dxy7T6w6t7ukMsrbfg+71lHzCG8Mcb7PNijQf38
         Yz80yF8KKyRWQTW1UNKIgpv9V76hX4cVKry9PQzlVlQIydVnuQBKc6XKE6GsT3tBd6EP
         9eLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=hL+v0VkC8nJZ/yYasVVgoGkbvgueSaBBRK1E46vpngU=;
        b=r1gVwusupyRKxHXRvJ0jn/KucEChKkTrmaqZLV8/Z1l7QZg+h0/4ZgzYdErGbiIRPw
         SqIKAM0eAMOB693Rz2xDv3bUBE3CpMHOOxYL1J27lhnYkELCYVjq5VRC88BWvaMIfJL/
         3VNH05WfhqlCSQSGPibOtgdC7bJ8CIDSDt9ZhgoarOPDloWgTaWzW5zLkucjsVB1pLn3
         4cT/k1YjqZtJlMv05P76AEFFcYg1zzJ6J5GnzE2Yj+jsdbT5aOpOC2W4kRsTbKH3nyaE
         vfKS9TLqVOp8xGVsxk1SGi41hD4pprUgzemyUYxE14NCK7MMFevIuaDAYRNlNa7qWql6
         tBfg==
X-Gm-Message-State: APjAAAWiAisnC0GwYAYkv5t6UZ600A9hogWXqJb2PL6H2pVmC1f14zMd
        FesRu+2z+nqtyqSHHgsmKk4=
X-Google-Smtp-Source: APXvYqzbPeO9Sylf2UWrSs/mFlQJikvRlBtwZ0Ytzy9PU0f4W4+Z/AVwT9xzRUzfQkBXgjOJgWK+Hg==
X-Received: by 2002:a17:902:524:: with SMTP id 33mr13606140plf.123.1571887538912;
        Wed, 23 Oct 2019 20:25:38 -0700 (PDT)
Received: from software.domain.org ([66.42.68.162])
        by smtp.gmail.com with ESMTPSA id y10sm23642731pfe.148.2019.10.23.20.25.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 20:25:38 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        chenhuacai@gmail.com, linux-kernel@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] timekeeping/vsyscall: Update vdso data unconditionally
Date:   Thu, 24 Oct 2019 11:28:29 +0800
Message-Id: <1571887709-11447-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In do_hres(), we currently use whether the return value of __arch_get_
hw_counter() is negative to indicate fallback, but MIPS returns 0 when
clock_mode is invalid.

It is sure that MIPS has a bug when clock_mode is invalid and should
return ULL_MAX as ARM64 does (Vincenzo has already submitted a patch).
But at the time we found another bug: currently update_vsyscall() and
update_vsyscall_tz() rely on __arch_use_vsyscall() to update the vdso
data, which causes __cvdso_clock_getres() and some other functions get
wrong results when clock_mode is invalid. So, in this patch we update
vdso data unconditionally.

Fixes: 44f57d788e7deecb50 ("timekeeping: Provide a generic update_vsyscall() implementation")
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 kernel/time/vsyscall.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

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
-- 
2.7.0

