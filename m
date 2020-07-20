Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27892264D4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgGTPsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729932AbgGTPsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:48:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B2222482;
        Mon, 20 Jul 2020 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260119;
        bh=3nBhr8KvHL41nT9MeEU1tSZse/nQrdOPicJryuGPjBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxErNIKOeZuxLSakdEJ7lXO/EX9G8+RsW4wOmgeKsH9lErUF3/Uw+LJu8xzLL3mc3
         T4ScW5H0S/5vYUzy220dR5FCB2FClaEBfcZ09wKY2cDktVoMcqrrcLLvMl56GqziKg
         eya3YhOOs5UK2PD66QfW+EKGGLN+vhGa6GfaBTyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 4.14 113/125] MIPS: Fix build for LTS kernel caused by backporting lpj adjustment
Date:   Mon, 20 Jul 2020 17:37:32 +0200
Message-Id: <20200720152808.479775453@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

Commit ed26aacfb5f71eecb20a ("mips: Add udelay lpj numbers adjustment")
has backported to 4.4~5.4, but the "struct cpufreq_freqs" (and also the
cpufreq notifier machanism) of 4.4~4.19 are different from the upstream
kernel. These differences cause build errors, and this patch can fix the
build.

Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Stable <stable@vger.kernel.org> # 4.4/4.9/4.14/4.19
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/time.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

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
@@ -64,6 +62,7 @@ static int cpufreq_callback(struct notif
 		}
 	}
 
+	cpu = freq->cpu;
 	/*
 	 * Adjust global lpj variable and per-CPU udelay_val number in
 	 * accordance with the new CPU frequency.
@@ -74,12 +73,8 @@ static int cpufreq_callback(struct notif
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


