Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB7922F26E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgG0OJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:09:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729618AbgG0OJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:09:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 120F8207FC;
        Mon, 27 Jul 2020 14:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858958;
        bh=6BIAxrKabhOJYy2xeoMCfBD72A96CeHELJj9q3yhH6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxOZNnTy3lpLjc5ELy2/V9yldu3YO1uAHC9j+bpAcx/uu0DZYCk6sxx640lIER/Tl
         BAUGZ6HiWMP/pqNqY3ZAtKqSXBGqWfAd1pVJ6n5GUK21fj0ypB4s1uUIjAX7hnxRPO
         DRZwTs9WnLwm7L24LeXGZCvs45yrCmH1rD0zYwKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/86] drivers/firmware/psci: Fix memory leakage in alloc_init_cpu_groups()
Date:   Mon, 27 Jul 2020 16:03:46 +0200
Message-Id: <20200727134914.952600087@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/firmware/psci_checker.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/psci_checker.c b/drivers/firmware/psci_checker.c
index cbd53cb1b2d47..9f1a913933d53 100644
--- a/drivers/firmware/psci_checker.c
+++ b/drivers/firmware/psci_checker.c
@@ -164,8 +164,10 @@ static int alloc_init_cpu_groups(cpumask_var_t **pcpu_groups)
 
 	cpu_groups = kcalloc(nb_available_cpus, sizeof(cpu_groups),
 			     GFP_KERNEL);
-	if (!cpu_groups)
+	if (!cpu_groups) {
+		free_cpumask_var(tmp);
 		return -ENOMEM;
+	}
 
 	cpumask_copy(tmp, cpu_online_mask);
 
@@ -174,6 +176,7 @@ static int alloc_init_cpu_groups(cpumask_var_t **pcpu_groups)
 			topology_core_cpumask(cpumask_any(tmp));
 
 		if (!alloc_cpumask_var(&cpu_groups[num_groups], GFP_KERNEL)) {
+			free_cpumask_var(tmp);
 			free_cpu_groups(num_groups, &cpu_groups);
 			return -ENOMEM;
 		}
-- 
2.25.1



