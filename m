Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD71226436
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgGTPnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:43:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbgGTPnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:43:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F8D2064B;
        Mon, 20 Jul 2020 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259784;
        bh=3nBhr8KvHL41nT9MeEU1tSZse/nQrdOPicJryuGPjBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFdi6y94cufMltUlCzEqmie7Pf1gcQ1dnZhzoAaTp4WDpPwySm/Ct4FbQyjlQSUYt
         uMe8H1rt/1XzJtIADzZM34G26CdD/g+CaEpbmUXFHgNDHt3VXIdJNKoHzzi7SAf0DN
         Jct2zED7b0vlvHSxCzEPBEq2oXO2TrupD6sL0pt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 4.9 79/86] MIPS: Fix build for LTS kernel caused by backporting lpj adjustment
Date:   Mon, 20 Jul 2020 17:37:15 +0200
Message-Id: <20200720152757.215444569@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
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


