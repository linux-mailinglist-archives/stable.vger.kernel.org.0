Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1180F147F1E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731819AbgAXK7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgAXK7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:59:48 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99A3520838;
        Fri, 24 Jan 2020 10:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863587;
        bh=7Xy3n3xB1MfuD7b+IoXs8QZTAuOPh9hV3O2G65UpMrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aB/JRbZ40TyBsWEe81kAJME18f5NwEB0FC968wLe2xEzW1Au1jABZ27no+m45iMhQ
         phvcjzKq1bCQ2iIvoQ1akxf9MOaO8+jHuC62vFx1halvMS/89CHR2qjdJzvxhKxoLc
         fx5cJbWYq/+Q/MiPiyf4FMlSDVRHAcJHHJnnv9us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/639] signal/ia64: Use the force_sig(SIGSEGV,...) in ia64_rt_sigreturn
Date:   Fri, 24 Jan 2020 10:23:23 +0100
Message-Id: <20200124093051.581418128@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit b92adb74adde62d9a9780ff2977d63dcb21aeaa6 ]

The ia64 handling of failure to return from a signal frame has been trying
to set overlapping fields in struct siginfo since 2.3.43.  The si_code
corresponds to the fields that were stomped (not the field that is
actually written), so I can not imagine a piece of userspace code
making sense of the signal frame if it looks closely.

In practice failure to return from a signal frame is a rare event that
almost never happens.  Someone using an alternate signal stack to
recover and looking in detail is even more rare.  So I presume no one
has ever noticed and reported this ia64 nonsense.

Sort this out by causing ia64 to use force_sig(SIGSEGV) like other architectures.

Fixes: 2.3.43
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/signal.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/ia64/kernel/signal.c b/arch/ia64/kernel/signal.c
index 01fc133b2e4c8..9a960829a01d9 100644
--- a/arch/ia64/kernel/signal.c
+++ b/arch/ia64/kernel/signal.c
@@ -110,7 +110,6 @@ ia64_rt_sigreturn (struct sigscratch *scr)
 {
 	extern char ia64_strace_leave_kernel, ia64_leave_kernel;
 	struct sigcontext __user *sc;
-	struct siginfo si;
 	sigset_t set;
 	long retval;
 
@@ -153,14 +152,7 @@ ia64_rt_sigreturn (struct sigscratch *scr)
 	return retval;
 
   give_sigsegv:
-	clear_siginfo(&si);
-	si.si_signo = SIGSEGV;
-	si.si_errno = 0;
-	si.si_code = SI_KERNEL;
-	si.si_pid = task_pid_vnr(current);
-	si.si_uid = from_kuid_munged(current_user_ns(), current_uid());
-	si.si_addr = sc;
-	force_sig_info(SIGSEGV, &si, current);
+	force_sig(SIGSEGV, current);
 	return retval;
 }
 
-- 
2.20.1



