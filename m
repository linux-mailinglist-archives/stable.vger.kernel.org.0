Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEE31F45F7
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388844AbgFISWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732308AbgFIRsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:48:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B3F5207F9;
        Tue,  9 Jun 2020 17:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724910;
        bh=ZdePdRXU8ATU95ggv1vzgQqxst9eZaKBHqoiOG6EeHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dcDpkrklKn9OiQ1pg8sH+jczs/pXynPepvCCYxIIJr4OL6lbTzNhQW9KiVfb39W9R
         JtpHYf58lb8aZyhzVUkU2MSQDxY9ZVKrZZjTNjAA5UQ14RbYsBsm0qA0rdsoxCfjvn
         wbn2A6uINixG6QzhoN0jHbu6qkTUzj9Bd+d30jd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/42] x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables
Date:   Tue,  9 Jun 2020 19:44:13 +0200
Message-Id: <20200609174016.240837390@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit d7110a26e5905ec2fe3fc88bc6a538901accb72b ]

When building with Clang + -Wtautological-compare and
CONFIG_CPUMASK_OFFSTACK unset:

  arch/x86/mm/mmio-mod.c:375:6: warning: comparison of array 'downed_cpus'
  equal to a null pointer is always false [-Wtautological-pointer-compare]
          if (downed_cpus == NULL &&
              ^~~~~~~~~~~    ~~~~
  arch/x86/mm/mmio-mod.c:405:6: warning: comparison of array 'downed_cpus'
  equal to a null pointer is always false [-Wtautological-pointer-compare]
          if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
              ^~~~~~~~~~~    ~~~~
  2 warnings generated.

Commit

  f7e30f01a9e2 ("cpumask: Add helper cpumask_available()")

added cpumask_available() to fix warnings of this nature. Use that here
so that clang does not warn regardless of CONFIG_CPUMASK_OFFSTACK's
value.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/982
Link: https://lkml.kernel.org/r/20200408205323.44490-1-natechancellor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mmio-mod.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index bef36622e408..abd4fa587ca4 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -385,7 +385,7 @@ static void enter_uniprocessor(void)
 	int cpu;
 	int err;
 
-	if (downed_cpus == NULL &&
+	if (!cpumask_available(downed_cpus) &&
 	    !alloc_cpumask_var(&downed_cpus, GFP_KERNEL)) {
 		pr_notice("Failed to allocate mask\n");
 		goto out;
@@ -415,7 +415,7 @@ static void leave_uniprocessor(void)
 	int cpu;
 	int err;
 
-	if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
+	if (!cpumask_available(downed_cpus) || cpumask_weight(downed_cpus) == 0)
 		return;
 	pr_notice("Re-enabling CPUs...\n");
 	for_each_cpu(cpu, downed_cpus) {
-- 
2.25.1



