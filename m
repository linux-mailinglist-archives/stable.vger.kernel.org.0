Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B451ED9D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfEOLLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729637AbfEOLLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191DC2184C;
        Wed, 15 May 2019 11:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918708;
        bh=ZE/wyIpieYWpS3jmasNG/txzYJIV0+xGGC7dW8gk/1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0irSYnWxrE5ntedmw8IbGsotfd2wxh/QfP2uiIShFJF93Z7V9wQg1JaYiD5JzSpu
         QUy4fPzTLoFxallxuBBUnqAdgRygp656f3h4SA8sixhQ4I1pGQVKfk5GsHNKIgaciZ
         EPkQmvnqk+4oTB3TUAyedeGNLyvap1+UBuzBj3EI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jon Masters <jcm@redhat.com>,
        Waiman Long <longman9394@gmail.com>,
        Dave Stewart <david.c.stewart@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 208/266] x86/Kconfig: Select SCHED_SMT if SMP enabled
Date:   Wed, 15 May 2019 12:55:15 +0200
Message-Id: <20190515090729.996216353@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit dbe733642e01dd108f71436aaea7b328cb28fd87 upstream.

CONFIG_SCHED_SMT is enabled by all distros, so there is not a real point to
have it configurable. The runtime overhead in the core scheduler code is
minimal because the actual SMT scheduling parts are conditional on a static
key.

This allows to expose the scheduler's SMT state static key to the
speculation control code. Alternatively the scheduler's static key could be
made always available when CONFIG_SMP is enabled, but that's just adding an
unused static key to every other architecture for nothing.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jon Masters <jcm@redhat.com>
Cc: Waiman Long <longman9394@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dave Stewart <david.c.stewart@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20181125185004.337452245@linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -893,13 +893,7 @@ config NR_CPUS
 	  approximately eight kilobytes to the kernel image.
 
 config SCHED_SMT
-	bool "SMT (Hyperthreading) scheduler support"
-	depends on SMP
-	---help---
-	  SMT scheduler support improves the CPU scheduler's decision making
-	  when dealing with Intel Pentium 4 chips with HyperThreading at a
-	  cost of slightly increased overhead in some places. If unsure say
-	  N here.
+	def_bool y if SMP
 
 config SCHED_MC
 	def_bool y


