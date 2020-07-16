Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8563A221FCF
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 11:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGPJhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 05:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgGPJhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 05:37:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C05C061755;
        Thu, 16 Jul 2020 02:37:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x9so3626406plr.2;
        Thu, 16 Jul 2020 02:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=7NAnZNOW9RnOu3wm5S7KBfhMHZl/bPVZtLS6stku3C0=;
        b=T/kOZWQ0OXEOBX7qh4Q5LFhAWW3G0FMDDErt2JJeUxvVvc0lzf/OJY4ATloZgcQ0g3
         XrRLtRJSawAyy4DC2Gfu0FtZPdy/Kf9ncRZ+VhADrhJERQyE7ru5MbSiFcMHxQ7yoK+P
         PHRDmay6NqpmJlE7fOFNvMOT9rJC71RB2b7FXCQY4y6dBlat+vi2LKwc8Cscj/yNg1KL
         mU0R+hCJ+woOwPDp8PjY53U2KFdMK16PxDaOwaJa2Bq6yR9msbLrZBdbDnMKaDMOEHy4
         F6ielKWSJIvLvosprMCfwqsm4lpsDXlzj/QNpSrE3PhgUJBiCHf+Fg05FnirdM/4559m
         TzWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=7NAnZNOW9RnOu3wm5S7KBfhMHZl/bPVZtLS6stku3C0=;
        b=lPEZKHsWtu0OtSLSoWGKSU6LVxWS0SCoT/R+l1vMlbDOInjsTMJhItJrD/5xOZHdwz
         wvAN6vERhhuelyDHKFU/htXLnuhe7fxbSB8Wu4ScKiMMJqwKx7own5Yr7f/uF4c42vlz
         B0TsBKiKcrhm6TB6AARUIkrBVk4hWWCvOKYdfOYa6h+Qfk4VpNV5VN0fG1buizoDSiFo
         3AL2fnUbLP6NrgOXnL8U4MlCo7HWVKKpp/easKhMj0XI6FwRgrRu46lRj1YjYA6k15h6
         mZhDmjx0ksg+uA+0AI3oUuvOhUxT8CKcDK8NbSw3O9a1vBYrAyJX4KY+y3IdHfntdB6w
         P6qw==
X-Gm-Message-State: AOAM531bJwJ9nJEawlHS/yIL+2abbpRAALPBuZkS4nLj8yoMnrXXCLao
        3tuyLP+aOYX69NlumWfd0go7egGUdzQ5gA==
X-Google-Smtp-Source: ABdhPJxbN08AJydzVzFjZaKsNAf1GlxJkrYVy3CkwoCswSYz6ZwHbI+R/8vLHV0hb+dfMPK/vyXmAg==
X-Received: by 2002:a17:90a:2b8f:: with SMTP id u15mr3853403pjd.98.1594892242062;
        Thu, 16 Jul 2020 02:37:22 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id a11sm4523871pjw.35.2020.07.16.02.37.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 02:37:21 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        "Stable # 4 . 4/4 . 9/4 . 14/4 . 19" <stable@vger.kernel.org>
Subject: [PATCH -stable] MIPS: Fix build for LTS kernel caused by backporting lpj adjustment
Date:   Thu, 16 Jul 2020 17:39:29 +0800
Message-Id: <1594892369-28060-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit ed26aacfb5f71eecb20a ("mips: Add udelay lpj numbers adjustment")
has backported to 4.4~5.4, but the "struct cpufreq_freqs" (and also the
cpufreq notifier machanism) of 4.4~4.19 are different from the upstream
kernel. These differences cause build errors, and this patch can fix the
build.

Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Stable <stable@vger.kernel.org> # 4.4/4.9/4.14/4.19
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/kernel/time.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kernel/time.c b/arch/mips/kernel/time.c
index b7f7e08..b15ee12 100644
--- a/arch/mips/kernel/time.c
+++ b/arch/mips/kernel/time.c
@@ -40,10 +40,8 @@ static unsigned long glb_lpj_ref_freq;
 static int cpufreq_callback(struct notifier_block *nb,
 			    unsigned long val, void *data)
 {
-	struct cpufreq_freqs *freq = data;
-	struct cpumask *cpus = freq->policy->cpus;
-	unsigned long lpj;
 	int cpu;
+	struct cpufreq_freqs *freq = data;
 
 	/*
 	 * Skip lpj numbers adjustment if the CPU-freq transition is safe for
@@ -64,6 +62,7 @@ static int cpufreq_callback(struct notifier_block *nb,
 		}
 	}
 
+	cpu = freq->cpu;
 	/*
 	 * Adjust global lpj variable and per-CPU udelay_val number in
 	 * accordance with the new CPU frequency.
@@ -74,12 +73,8 @@ static int cpufreq_callback(struct notifier_block *nb,
 						glb_lpj_ref_freq,
 						freq->new);
 
-		for_each_cpu(cpu, cpus) {
-			lpj = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
-					    per_cpu(pcp_lpj_ref_freq, cpu),
-					    freq->new);
-			cpu_data[cpu].udelay_val = (unsigned int)lpj;
-		}
+		cpu_data[cpu].udelay_val = cpufreq_scale(per_cpu(pcp_lpj_ref, cpu),
+					   per_cpu(pcp_lpj_ref_freq, cpu), freq->new);
 	}
 
 	return NOTIFY_OK;
-- 
2.7.0

