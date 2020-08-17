Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FBD246962
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgHQPVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbgHQPVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:21:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23553206FA;
        Mon, 17 Aug 2020 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677678;
        bh=x2EdT82fe7GeAYl9x+JFtiof54LVZjz/+2qJUuXzK6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJFBn8izYTxYjk1I+lwF21DzDv9eW3A5h5MBvGLA7XbPE8BJVSX8ZbruFJOLLNc4a
         RG//lj9ZniANkpwrMZpHpgeONcGi4OGwSKulitEgtPKfCWG3xEzAdGOdyX1c5F9Tee
         5QPUXw4H4TrwH3e6mXFR9lZyZfZlWZROaIIZL6Xw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 069/464] irqchip/irq-bcm7038-l1: Guard uses of cpu_logical_map
Date:   Mon, 17 Aug 2020 17:10:22 +0200
Message-Id: <20200817143837.072632766@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 9808357ff2e5bfe1e0dcafef5e78cc5b617a7078 ]

cpu_logical_map is only defined for CONFIG_SMP builds, when we are in an
UP configuration, the boot CPU is 0.

Fixes: 6468fc18b006 ("irqchip/irq-bcm7038-l1: Add PM support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200724184157.29150-1-f.fainelli@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-bcm7038-l1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/irqchip/irq-bcm7038-l1.c b/drivers/irqchip/irq-bcm7038-l1.c
index fd7c537fb42ac..4127eeab10af1 100644
--- a/drivers/irqchip/irq-bcm7038-l1.c
+++ b/drivers/irqchip/irq-bcm7038-l1.c
@@ -327,7 +327,11 @@ static int bcm7038_l1_suspend(void)
 	u32 val;
 
 	/* Wakeup interrupt should only come from the boot cpu */
+#ifdef CONFIG_SMP
 	boot_cpu = cpu_logical_map(0);
+#else
+	boot_cpu = 0;
+#endif
 
 	list_for_each_entry(intc, &bcm7038_l1_intcs_list, list) {
 		for (word = 0; word < intc->n_words; word++) {
@@ -347,7 +351,11 @@ static void bcm7038_l1_resume(void)
 	struct bcm7038_l1_chip *intc;
 	int boot_cpu, word;
 
+#ifdef CONFIG_SMP
 	boot_cpu = cpu_logical_map(0);
+#else
+	boot_cpu = 0;
+#endif
 
 	list_for_each_entry(intc, &bcm7038_l1_intcs_list, list) {
 		for (word = 0; word < intc->n_words; word++) {
-- 
2.25.1



