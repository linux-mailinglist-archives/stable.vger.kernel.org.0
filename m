Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113191F42D8
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbgFIRs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732285AbgFIRs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0F720835;
        Tue,  9 Jun 2020 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724906;
        bh=PeS/4GIPSGbQf2eV5Sw0OOAjraoC0SV0L+r5iD4XQ/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwfoBygzVr5Tk0p4qIsG9lYDbZGyTv7T/HnNGC328m9jS//befCYeeAIf+x7+V1hs
         T3t439V5sWuihyOS6WgnVaLOEyPCPas+cTZik4ame49bYmik29w/TL2SJLiYelmqfZ
         Pstn4kKOAlqHW2YUDfEpgoplOrjLwX1rgNYKsrtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 05/42] s390/ftrace: save traced function caller
Date:   Tue,  9 Jun 2020 19:44:11 +0200
Message-Id: <20200609174016.016075931@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit b4adfe55915d8363e244e42386d69567db1719b9 ]

A typical backtrace acquired from ftraced function currently looks like
the following (e.g. for "path_openat"):

arch_stack_walk+0x15c/0x2d8
stack_trace_save+0x50/0x68
stack_trace_call+0x15a/0x3b8
ftrace_graph_caller+0x0/0x1c
0x3e0007e3c98 <- ftraced function caller (should be do_filp_open+0x7c/0xe8)
do_open_execat+0x70/0x1b8
__do_execve_file.isra.0+0x7d8/0x860
__s390x_sys_execve+0x56/0x68
system_call+0xdc/0x2d8

Note random "0x3e0007e3c98" stack value as ftraced function caller. This
value causes either imprecise unwinder result or unwinding failure.
That "0x3e0007e3c98" comes from r14 of ftraced function stack frame, which
it haven't had a chance to initialize since the very first instruction
calls ftrace code ("ftrace_caller"). (ftraced function might never
save r14 as well). Nevertheless according to s390 ABI any function
is called with stack frame allocated for it and r14 contains return
address. "ftrace_caller" itself is called with "brasl %r0,ftrace_caller".
So, to fix this issue simply always save traced function caller onto
ftraced function stack frame.

Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/mcount.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 802a4ded9a62..e9df35249f9f 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -39,6 +39,7 @@ EXPORT_SYMBOL(_mcount)
 ENTRY(ftrace_caller)
 	.globl	ftrace_regs_caller
 	.set	ftrace_regs_caller,ftrace_caller
+	stg	%r14,(__SF_GPRS+8*8)(%r15)	# save traced function caller
 	lgr	%r1,%r15
 #ifndef CC_USING_HOTPATCH
 	aghi	%r0,MCOUNT_RETURN_FIXUP
-- 
2.25.1



