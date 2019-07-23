Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A09D716A3
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387480AbfGWKzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:55:41 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42787 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731549AbfGWKzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:55:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A670221CDD;
        Tue, 23 Jul 2019 06:55:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:55:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zgD3Su
        qMTQeS5i9/LSRXJhi9cgS0+wwR59I9SYwcrc0=; b=1LCkzytzUbCdimNRjzFEn1
        bRdbwvHnaJZAvBRXVVHFBTDPsMxYps4u+QvnxOfGI+LByDubHiNwaAqMH5GxcQt1
        FO/w70oLyS0L6vgtFd0CcJrkDO6VmAo5yoe7ajE69CA/FZVNZBHvPmpCgzSQmxC1
        qfm6QxybVwGtFZGQdW22zDYIlJb12ukbCs5s6dclwv70kMN0mRM8isDGOgELH6nS
        BMpuOvWB6MCe0KsbeZGWmYd8yZGdWNIOU/B5WZgirOeQ1a0ru0mockNCEHZnI6uJ
        iImTUls9SsoK4/Cns+do3P6itoSWWB6/8s49Qt8HYxu8mIaaH5G/Z7itaheMaQ0g
        ==
X-ME-Sender: <xms:quc2XcoOSeNh21xIPjF-OwmCZUybuxiq6Cz_lwu6P3A5afW9D3E7ug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:quc2XeIRbGx9WC0jiYcTMvHJIl4PpiWxB7jhO2zqV3kgsSqJDcTHZg>
    <xmx:quc2XYPsQArGUHLVIuk7wn5F0ixA0wKhEHCl4MhiEj83exR55SO7zA>
    <xmx:quc2Xc1ru816DqSm68AffgK6cOzTT-aST1CfR6GP0kF06wXMrPc4_w>
    <xmx:quc2XTYAepNhzPUX3KmrTLjKNQdkGNViEnPh_CjLbespYgwaGy4lfw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 187BE8005B;
        Tue, 23 Jul 2019 06:55:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal/arm64: Use force_sig not force_sig_fault for SIGKILL" failed to apply to 5.2-stable tree
To:     ebiederm@xmission.com, Dave.Martin@arm.com, james.morse@arm.com,
        will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:54:08 +0200
Message-ID: <1563879248245217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 82e10af2248d2d09c99834613f1b47d5002dc379 Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 16 May 2019 10:55:21 -0500
Subject: [PATCH] signal/arm64: Use force_sig not force_sig_fault for SIGKILL

I don't think this is userspace visible but SIGKILL does not have
any si_codes that use the fault member of the siginfo union.  Correct
this the simple way and call force_sig instead of force_sig_fault when
the signal is SIGKILL.

The two know places where synchronous SIGKILL are generated are
do_bad_area and fpsimd_save.  The call paths to force_sig_fault are:
do_bad_area
  arm64_force_sig_fault
    force_sig_fault
force_signal_inject
  arm64_notify_die
    arm64_force_sig_fault
       force_sig_fault

Which means correcting this in arm64_force_sig_fault is enough
to ensure the arm64 code is not misusing the generic code, which
could lead to maintenance problems later.

Cc: stable@vger.kernel.org
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Fixes: af40ff687bc9 ("arm64: signal: Ensure si_code is valid for all fault signals")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index ade32046f3fe..e45d5b440fb1 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -256,7 +256,10 @@ void arm64_force_sig_fault(int signo, int code, void __user *addr,
 			   const char *str)
 {
 	arm64_show_signal(signo, str);
-	force_sig_fault(signo, code, addr, current);
+	if (signo == SIGKILL)
+		force_sig(SIGKILL, current);
+	else
+		force_sig_fault(signo, code, addr, current);
 }
 
 void arm64_force_sig_mceerr(int code, void __user *addr, short lsb,

