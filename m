Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA94521F464
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgGNOjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgGNOjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B56572067D;
        Tue, 14 Jul 2020 14:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737553;
        bh=6ycqmBgJjHjv734+lHtackk/20kto5gQnyNFO9LxvNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE1EzFcpCEdc03Rj/MX1GyANEqRVeiCEpX0LB7HJ0RU8sBdGux3n/R3aaFVRVdMm4
         QR6wYMyhItN71PrSAjQJnzrzqIL3rmRmLjvQ73fJCIt463i33T8lB7Pa15Y4+NG6u/
         0k0HEnb74G5+7lb7/YFtTc3FCtPgBYkRP+PfNjlk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gavin Shan <gshan@redhat.com>, Sudeep Holla <sudeep.holla@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 19/19] drivers/firmware/psci: Fix memory leakage in alloc_init_cpu_groups()
Date:   Tue, 14 Jul 2020 10:38:49 -0400
Message-Id: <20200714143849.4035283-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143849.4035283-1-sashal@kernel.org>
References: <20200714143849.4035283-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit c377e67c6271954969384f9be1b1b71de13eba30 ]

The CPU mask (@tmp) should be released on failing to allocate
@cpu_groups or any of its elements. Otherwise, it leads to memory
leakage because the CPU mask variable is dynamically allocated
when CONFIG_CPUMASK_OFFSTACK is enabled.

Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/20200630075227.199624-1-gshan@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/psci/psci_checker.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci/psci_checker.c b/drivers/firmware/psci/psci_checker.c
index 873841af8d575..d9b1a2d71223e 100644
--- a/drivers/firmware/psci/psci_checker.c
+++ b/drivers/firmware/psci/psci_checker.c
@@ -157,8 +157,10 @@ static int alloc_init_cpu_groups(cpumask_var_t **pcpu_groups)
 
 	cpu_groups = kcalloc(nb_available_cpus, sizeof(cpu_groups),
 			     GFP_KERNEL);
-	if (!cpu_groups)
+	if (!cpu_groups) {
+		free_cpumask_var(tmp);
 		return -ENOMEM;
+	}
 
 	cpumask_copy(tmp, cpu_online_mask);
 
@@ -167,6 +169,7 @@ static int alloc_init_cpu_groups(cpumask_var_t **pcpu_groups)
 			topology_core_cpumask(cpumask_any(tmp));
 
 		if (!alloc_cpumask_var(&cpu_groups[num_groups], GFP_KERNEL)) {
+			free_cpumask_var(tmp);
 			free_cpu_groups(num_groups, &cpu_groups);
 			return -ENOMEM;
 		}
-- 
2.25.1

