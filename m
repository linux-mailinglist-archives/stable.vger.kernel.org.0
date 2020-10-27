Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E152B29B991
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802604AbgJ0Pu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801359AbgJ0Pk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:40:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C675D2231B;
        Tue, 27 Oct 2020 15:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813256;
        bh=cjqWogI3hcqi3JlyrCFJ81svNJzOzkNzhZBZA2fbFTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f78hM+7N4AAGspuRaJ4GSsgwFuJqToxRyOLXgG+tnCm99vk88pIhuSuMPhMCevwe3
         A9Dbl6PbcP/qjG0npcgTViyvkj12yPEVqqW39E5LUH2wq5Bymyi/8tB0Gh48jCDMwb
         elE4s0fX1xYN58f8K8GqkH99Q02BdcD0C7f1VvEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 491/757] cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier
Date:   Tue, 27 Oct 2020 14:52:21 +0100
Message-Id: <20201027135513.502252541@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit a2d0230b91f7e23ceb5d8fb6a9799f30517ec33a ]

The patch avoids allocating cpufreq_policy on stack hence fixing frame
size overflow in 'powernv_cpufreq_reboot_notifier':

  drivers/cpufreq/powernv-cpufreq.c: In function powernv_cpufreq_reboot_notifier:
  drivers/cpufreq/powernv-cpufreq.c:906:1: error: the frame size of 2064 bytes is larger than 2048 bytes

Fixes: cf30af76 ("cpufreq: powernv: Set the cpus to nominal frequency during reboot/kexec")
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200922080254.41497-1-srikar@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/powernv-cpufreq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index a9af15e994ccf..e439b43c19ebe 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -885,12 +885,15 @@ static int powernv_cpufreq_reboot_notifier(struct notifier_block *nb,
 				unsigned long action, void *unused)
 {
 	int cpu;
-	struct cpufreq_policy cpu_policy;
+	struct cpufreq_policy *cpu_policy;
 
 	rebooting = true;
 	for_each_online_cpu(cpu) {
-		cpufreq_get_policy(&cpu_policy, cpu);
-		powernv_cpufreq_target_index(&cpu_policy, get_nominal_index());
+		cpu_policy = cpufreq_cpu_get(cpu);
+		if (!cpu_policy)
+			continue;
+		powernv_cpufreq_target_index(cpu_policy, get_nominal_index());
+		cpufreq_cpu_put(cpu_policy);
 	}
 
 	return NOTIFY_DONE;
-- 
2.25.1



