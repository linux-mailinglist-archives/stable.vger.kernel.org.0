Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59AB1FE0A7
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732079AbgFRBtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:49:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbgFRB1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37CB7221F7;
        Thu, 18 Jun 2020 01:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443659;
        bh=U6PGRU7V9zX6rQEreKOushHmcNVZiVkvz+uIr6WXMjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ELmAf5pIB4VFNZJKxXbJHg6J2kMZJ3DuAv+id91SVSYMzHzS33SdsrsfEOJX1Ich
         Mlam7L08z03HuDsb6b1J8HfBxIvmXnXoBDlt67qIQyyiiJzOGTubRuBo6bhwdVqRu0
         xrlqhAiYN/xm/UbjVsF1FLrRO31riRvm4YE4f/t0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 078/108] x86/apic: Make TSC deadline timer detection message visible
Date:   Wed, 17 Jun 2020 21:25:30 -0400
Message-Id: <20200618012600.608744-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit de308d1815c9e8fe602a958c5c76142ff6501d75 ]

The commit

  c84cb3735fd5 ("x86/apic: Move TSC deadline timer debug printk")

removed the message which said that the deadline timer was enabled.
It added a pr_debug() message which is issued when deadline timer
validation succeeds.

Well, issued only when CONFIG_DYNAMIC_DEBUG is enabled - otherwise
pr_debug() calls get optimized away if DEBUG is not defined in the
compilation unit.

Therefore, make the above message pr_info() so that it is visible in
dmesg.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200525104218.27018-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 48ab5fdd1044..ee33f0951322 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1915,7 +1915,7 @@ void __init init_apic_mappings(void)
 	unsigned int new_apicid;
 
 	if (apic_validate_deadline_timer())
-		pr_debug("TSC deadline timer available\n");
+		pr_info("TSC deadline timer available\n");
 
 	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
-- 
2.25.1

