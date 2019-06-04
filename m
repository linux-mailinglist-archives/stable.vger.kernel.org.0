Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5A213462B
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfFDMFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:05:20 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60953 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727250AbfFDMFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:05:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D276D21FC1;
        Tue,  4 Jun 2019 08:05:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LlREBF
        AUSvjVh4zUGuAofeDC0EQNXYuAb/tAnLSGc9Y=; b=yOsn8luxswEuvMe9HvBunY
        kCaKQ7OAqFU58RENcyCDuezMktgxdboaAvWcRLBXRrQp0Cp6D0lp3wmrIiMfHEoK
        /s8MA0X4CU2XobSum4G9YpTnN30MOhJ+IPawORhBJNL2Nu8r51E4EsQ/1ocOs6IV
        /qP97qjrTDd213ijq72Xe1Mj+1XVg83F8KJT7HWCI45KpKoi5+RbXUAQcDaBOX7e
        eXzJWttdX+sV+lKZH2XrLVqorkH2u3Ww/P2rOmQ7h4inXWtppV73FDmhUzSJlRMe
        OwNcpOUn5fGMS/bhhebnmL9KM7UTjJDDAxzSXRS/ljOvxURDnT3GxzX8AXuZYaKg
        ==
X-ME-Sender: <xms:fl72XN6J4kbIN48tHdRjiuwYq_fkDdaIRPDNHBSVgq0EFZeLLmBY4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:fl72XPIcH_R7FBG8vGRjN6e9E6v8El-feeL_gXWEMFQ4hbyKP8zaEg>
    <xmx:fl72XPerAzIlRHb5OtbzcK3KaGK6JkMqZuIjuyte4VSC4-PCMgvOyw>
    <xmx:fl72XKcrw2CucJAC__6yyW1nM3idhTM8ZD8lT7cDX3bAVG9N2CmVcg>
    <xmx:fl72XIZT5RYE8b9CABBzHsySWyHJacUCaVABclcBJeacgXhHtMf1Ow>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6FA680060;
        Tue,  4 Jun 2019 08:05:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal/arm64: Use force_sig not force_sig_fault for SIGKILL" failed to apply to 4.19-stable tree
To:     ebiederm@xmission.com, Dave.Martin@arm.com, james.morse@arm.com,
        will.deacon@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:05:15 +0200
Message-ID: <1559649915235202@kroah.com>
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

From d76cac67db40c172791ce07948367b96a758e45b Mon Sep 17 00:00:00 2001
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Thu, 23 May 2019 11:11:19 -0500
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
Fixes: af40ff687bc9 ("arm64: signal: Ensure si_code is valid for all fault signals")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index e6be1a6efc0a..177c0f6ebabf 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -252,7 +252,10 @@ void arm64_force_sig_fault(int signo, int code, void __user *addr,
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

