Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702F429BFB3
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816443AbgJ0RGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793522AbgJ0PGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BF6322283;
        Tue, 27 Oct 2020 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811188;
        bh=YGUiDGe90sp5TgqgA7b8ROVDTLh9eKBhKne9K8iMjEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSYX9q7667r39IOYe09+FT5OQV7jr6Guo3arIaIyK9hc2jmjZ7V1So/ZrIQNu2rz0
         ruSDdZVf8nv+wm8ffquKYX1nuc1lhc81B4eMukPAT8WStjlj9299ZEojvQAH7Xb3jY
         WtfbBp9YIRS3llZppzGlix7jau0M6gJlKX2nNDBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Daniel Axtens <dja@axtens.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 404/633] cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_reboot_notifier
Date:   Tue, 27 Oct 2020 14:52:27 +0100
Message-Id: <20201027135541.671099017@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 8646eb197cd96..31f5c4ebbac9f 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -884,12 +884,15 @@ static int powernv_cpufreq_reboot_notifier(struct notifier_block *nb,
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



