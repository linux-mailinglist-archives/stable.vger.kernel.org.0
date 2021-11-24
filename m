Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EA345C649
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351630AbhKXOGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:06:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356574AbhKXOEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:04:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D472D6331F;
        Wed, 24 Nov 2021 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759493;
        bh=drOOjcV+aRgZ/mmAP4zeIn+mwO6sFw3ncXIhB1lvmvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F98gxW8RrKa3tiBEehSN+TE8g6GK0CEwzh1p+K0pQFlGLtjk3SIV4+2NvJuNzkB0r
         lKsG+cg6GvA875i7MZVmq1+twb/OATaG82A1RpBNifInz5ulwy2pRgMQkHN8qpJirO
         NkpuZPfrOwqX5p4ruiF8+OPIYhls9hgcQmJTvt/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Backlund <tmb@iki.fi>
Subject: [PATCH 5.15 259/279] signal/s390: Use force_sigsegv in default_trap_handler
Date:   Wed, 24 Nov 2021 12:59:06 +0100
Message-Id: <20211124115727.665407024@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 9bc508cf0791c8e5a37696de1a046d746fcbd9d8 upstream.

Reading the history it is unclear why default_trap_handler calls
do_exit.  It is not even menthioned in the commit where the change
happened.  My best guess is that because it is unknown why the
exception happened it was desired to guarantee the process never
returned to userspace.

Using do_exit(SIGSEGV) has the problem that it will only terminate one
thread of a process, leaving the process in an undefined state.

Use force_sigsegv(SIGSEGV) instead which effectively has the same
behavior except that is uses the ordinary signal mechanism and
terminates all threads of a process and is generally well defined.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Fixes: ca2ab03237ec ("[PATCH] s390: core changes")
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lkml.kernel.org/r/20211020174406.17889-11-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Thomas Backlund <tmb@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -84,7 +84,7 @@ static void default_trap_handler(struct
 {
 	if (user_mode(regs)) {
 		report_user_fault(regs, SIGSEGV, 0);
-		do_exit(SIGSEGV);
+		force_sigsegv(SIGSEGV);
 	} else
 		die(regs, "Unknown program exception");
 }


