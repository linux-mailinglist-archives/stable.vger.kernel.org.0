Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD4D194ECF
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 03:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgC0CMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 22:12:13 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34196 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgC0CMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 22:12:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id 23so3772808pfj.1;
        Thu, 26 Mar 2020 19:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FOm6MV3EMePJN0FuLWiMdiV/GLEXaRUsnceHfNcS4rI=;
        b=dJEPY5dPpm7vUNfoirSoxG9vs6rh1upSUPocJViZ9qUJB56uMUc3xZ+GaVnH9Kd6ia
         yU36LekPM9Rs+hIGO9OfPGD9CeZroyCQJkbEgF7gKDiMHnROVofESe+yCdPWUzMt+Vq+
         soIrVlHmdntzH5PC8REyn+2OJxZLuZUHRhuMmrT4Gn8IGB/MnpYYC2eTnF6bdX8DeUQz
         qaXVcbMdxKsQzokDH1AH50jXmnHKcNlJkbJVqSNVhIZgkkYA8RcIU0oko3DOiXlxZLcD
         Zcjd3L/wujq57anjnFWP0pk2EcBKbs9TVtAs4P7t7WxaJXmjsWvpOOH0kJ/eD7ROrd3j
         g0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FOm6MV3EMePJN0FuLWiMdiV/GLEXaRUsnceHfNcS4rI=;
        b=TDkSKRkErB5u0xtTsXwOdPJq9waCwOVHfjKfEDSoyuD54eHLwg+sWh6iPaPmoes6St
         58sGI+/TSKn5aX4JJXfIUchQlpXVwCX+4pRlcWHdQ8wa+6VnksqqInL37IKrpBCigBFB
         0u6f84YD6gL/RiX9TY/VqQfJG7IxNiD/hMtAR666FWYcLeLHm0AgFy64XuNorYdf/igN
         XYtK4Go1GuoGANJPvCY6n6Jz40Mbi8xsz4XPeZWz3/nmZKgIXZunAPQwDw+CgbClhcYF
         TFcwbnqXAFUddjtRwP/IRhAO/8vtXDexlu26okzi0+4UpkIJ3xOlngdFuuoWYUMBXkQd
         +Hmg==
X-Gm-Message-State: ANhLgQ3cHzConVQPAsh8U1QecJVI5FDEdKbf38m+WLi9HQJyPOwb9O4x
        8bggZ4ZWd/ECoKIN2oar2ahDgVTJIWU=
X-Google-Smtp-Source: ADFU+vuBkEqnRm6ngW5777xbhAVueA0Lix6mvtGr3oV7fkUyr7/2zLlP6r/i6whCO2U0s2oQYzfI8w==
X-Received: by 2002:a63:5859:: with SMTP id i25mr11245278pgm.74.1585275132126;
        Thu, 26 Mar 2020 19:12:12 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([131.107.160.210])
        by smtp.googlemail.com with ESMTPSA id w31sm2673844pgl.84.2020.03.26.19.12.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Mar 2020 19:12:11 -0700 (PDT)
From:   Tianyu Lan <ltykernel@gmail.com>
X-Google-Original-From: Tianyu Lan <Tianyu.Lan@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        vkuznets@redhat.com, stable@vger.kernel.org,
        Yubo Xie <yuboxie@microsoft.com>
Subject: [PATCH V2] x86/Hyper-V: Fix hv sched clock function return wrong time unit
Date:   Thu, 26 Mar 2020 19:11:59 -0700
Message-Id: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yubo Xie <yuboxie@microsoft.com>

sched clock callback should return time with nano second as unit
but current hv callback returns time with 100ns. Fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Fixes: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function")
---
Change since v1:
	Update fix commit number in change log. 
---
 drivers/clocksource/hyperv_timer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
index 9d808d595ca8..662ed978fa24 100644
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
 
 static u64 read_hv_sched_clock_tsc(void)
 {
-	return read_hv_clock_tsc() - hv_sched_clock_offset;
+	return (read_hv_clock_tsc() - hv_sched_clock_offset)
+		* (NSEC_PER_SEC / HV_CLOCK_HZ);
 }
 
 static void suspend_hv_clock_tsc(struct clocksource *arg)
@@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
 
 static u64 read_hv_sched_clock_msr(void)
 {
-	return read_hv_clock_msr() - hv_sched_clock_offset;
+	return (read_hv_clock_msr() - hv_sched_clock_offset)
+		* (NSEC_PER_SEC / HV_CLOCK_HZ);
 }
 
 static struct clocksource hyperv_cs_msr = {
-- 
2.14.5

