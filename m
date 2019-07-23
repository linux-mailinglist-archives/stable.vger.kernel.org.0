Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CDA716A5
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbfGWKzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:55:42 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42621 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731549AbfGWKzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:55:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CED12099D;
        Tue, 23 Jul 2019 06:55:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UdZhjT
        gY/2ZN35m+C9ftHKEYTVKyjQ+gA6cqG4f2/Q4=; b=Y2muXXNvMgEmlwnIgCNl/1
        8QpfCZHpFHFLfDhsq15sFtMh0lM6uF/9p3gwQoXB7fByvOUoUAqNIsYIQIsRHgln
        kF45y+P3O9i9wsD4ybfV23Ye9cQJXOBmR81FtbH3DKTS3NKYI6k299sh4OoQAf0g
        xxHMHk7b/DKFVME6H5okwAyYXZH4N3XzAeoB0wt7drv2DGbIBSESqK3WAYqgaYFN
        i18yD4uEICsdnln5R+33ARV6maduMggmG+Ec0GQkwZvk0XiHkhwo/l5EfxRnKsFV
        EyM2br1GLpq6fsrutXWer+0c4rX9g3qQtRSB3DNxvfcEfoWIgtKowO7ngowkLrgQ
        ==
X-ME-Sender: <xms:rec2XXN6LUq_Snx9r3u4dz7TwAM0ZkyZCsVpbXAAWmPxdvone9hOPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:rec2XYAEH1KmxKiwFZ56qtPApMuoc1zpB23RsxcInhIgTLDlt8ltRQ>
    <xmx:rec2XZhLyXupbibGq-TfjCH_z1VTimbHPEa3Mj-mFG6g4APg6IAWHw>
    <xmx:rec2XT1XZj4yk7Qer3clGND6Tc3yZCbi9jz1qY2uVYiStw1kGMLQrA>
    <xmx:ruc2XXtL-ZFWYI6RMJbNAoydNcm_k2vBwaOwmzj2B1MoO5O7HBA5sQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CC308005A;
        Tue, 23 Jul 2019 06:55:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal/arm64: Use force_sig not force_sig_fault for SIGKILL" failed to apply to 4.19-stable tree
To:     ebiederm@xmission.com, Dave.Martin@arm.com, james.morse@arm.com,
        will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:54:12 +0200
Message-ID: <1563879252194229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

