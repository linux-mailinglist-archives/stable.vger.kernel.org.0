Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FE6272F15
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgIUQrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728045AbgIUQq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69F423888;
        Mon, 21 Sep 2020 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706816;
        bh=fXVGge8+cR5WWy113wFwpWFgNcSHFw7sOKDTjkPBGZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrnWM+j6UG14tXjMsmHk8Zm6YeI009RvP4dZmZ5Lnw00fn+cS1yEE364D5LWaI221
         Nqwp7o8pQGy06xTrBFq/e5DL2l1IwZ6m5JD3cTAufOgLbeTfn8SkSm52TWnwYy4uPo
         BTJEzpkHArMUuGf1Bp/h2ZB1AY6ga4n0eAp5SjGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.8 106/118] s390: add 3f program exception handler
Date:   Mon, 21 Sep 2020 18:28:38 +0200
Message-Id: <20200921162041.295334701@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

commit cd4d3d5f21ddbfae3f686ac0ff405f21f7847ad3 upstream.

Program exception 3f (secure storage violation) can only be detected
when the CPU is running in SIE with a format 4 state description,
e.g. running a protected guest. Because of this and because user
space partly controls the guest memory mapping and can trigger this
exception, we want to send a SIGSEGV to the process running the guest
and not panic the kernel.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 5.7
Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry.h     |    1 +
 arch/s390/kernel/pgm_check.S |    2 +-
 arch/s390/mm/fault.c         |   20 ++++++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -26,6 +26,7 @@ void do_protection_exception(struct pt_r
 void do_dat_exception(struct pt_regs *regs);
 void do_secure_storage_access(struct pt_regs *regs);
 void do_non_secure_storage_access(struct pt_regs *regs);
+void do_secure_storage_violation(struct pt_regs *regs);
 
 void addressing_exception(struct pt_regs *regs);
 void data_exception(struct pt_regs *regs);
--- a/arch/s390/kernel/pgm_check.S
+++ b/arch/s390/kernel/pgm_check.S
@@ -80,7 +80,7 @@ PGM_CHECK(do_dat_exception)		/* 3b */
 PGM_CHECK_DEFAULT			/* 3c */
 PGM_CHECK(do_secure_storage_access)	/* 3d */
 PGM_CHECK(do_non_secure_storage_access)	/* 3e */
-PGM_CHECK_DEFAULT			/* 3f */
+PGM_CHECK(do_secure_storage_violation)	/* 3f */
 PGM_CHECK(monitor_event_exception)	/* 40 */
 PGM_CHECK_DEFAULT			/* 41 */
 PGM_CHECK_DEFAULT			/* 42 */
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -875,6 +875,21 @@ void do_non_secure_storage_access(struct
 }
 NOKPROBE_SYMBOL(do_non_secure_storage_access);
 
+void do_secure_storage_violation(struct pt_regs *regs)
+{
+	/*
+	 * Either KVM messed up the secure guest mapping or the same
+	 * page is mapped into multiple secure guests.
+	 *
+	 * This exception is only triggered when a guest 2 is running
+	 * and can therefore never occur in kernel context.
+	 */
+	printk_ratelimited(KERN_WARNING
+			   "Secure storage violation in task: %s, pid %d\n",
+			   current->comm, current->pid);
+	send_sig(SIGSEGV, current, 0);
+}
+
 #else
 void do_secure_storage_access(struct pt_regs *regs)
 {
@@ -885,4 +900,9 @@ void do_non_secure_storage_access(struct
 {
 	default_trap_handler(regs);
 }
+
+void do_secure_storage_violation(struct pt_regs *regs)
+{
+	default_trap_handler(regs);
+}
 #endif


