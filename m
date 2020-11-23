Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319F22C091A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387774AbgKWNEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:04:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387615AbgKWMva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46D1820888;
        Mon, 23 Nov 2020 12:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135889;
        bh=yePgMLztxQkudFiAiTC7NfeQazOfh6csbK8JFLhq5KM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfwbA0CK2mpRRcpDQ3s9pq73U2HTYzXOOV5y2DLZ/RtGI45utw50ygkAAE6cL5J/w
         Oml8R2kSYtPMX+Jp5a9T1WetpSu/p9nd2UX3iRN9vTEw/JpkgJ6JzO6sWPI2cpLP9r
         Q38WVJCFpYIF3k21GB8UIP41rl2XqvwqOaeDWH7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.9 232/252] s390: fix system call exit path
Date:   Mon, 23 Nov 2020 13:23:02 +0100
Message-Id: <20201123121846.769225614@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit ce9dfafe29bed86fe3cda330ac6072ce84e1ff81 upstream.

The system call exit path is running with interrupts enabled while
checking for TIF/PIF/CIF bits which require special handling. If all
bits have been checked interrupts are disabled and the kernel exits to
user space.
The problem is that after checking all bits and before interrupts are
disabled bits can be set already again, due to interrupt handling.

This means that the kernel can exit to user space with some
TIF/PIF/CIF bits set, which should never happen. E.g. TIF_NEED_RESCHED
might be set, which might lead to additional latencies, since that bit
will only be recognized with next exit to user space.

Fix this by checking the corresponding bits only when interrupts are
disabled.

Fixes: 0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
Cc: <stable@vger.kernel.org> # 5.8
Acked-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -422,6 +422,7 @@ ENTRY(system_call)
 #endif
 	LOCKDEP_SYS_EXIT
 .Lsysc_tif:
+	DISABLE_INTS
 	TSTMSK	__PT_FLAGS(%r11),_PIF_WORK
 	jnz	.Lsysc_work
 	TSTMSK	__TI_flags(%r12),_TIF_WORK
@@ -446,6 +447,7 @@ ENTRY(system_call)
 # One of the work bits is on. Find out which one.
 #
 .Lsysc_work:
+	ENABLE_INTS
 	TSTMSK	__TI_flags(%r12),_TIF_NEED_RESCHED
 	jo	.Lsysc_reschedule
 	TSTMSK	__PT_FLAGS(%r11),_PIF_SYSCALL_RESTART


