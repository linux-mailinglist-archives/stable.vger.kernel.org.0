Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119254A2FCD
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 14:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350842AbiA2NbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 08:31:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55278 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346162AbiA2NbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 08:31:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C967C60C84
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 13:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2340C340E5;
        Sat, 29 Jan 2022 13:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643463070;
        bh=HHXtsE2JbnTOi7EA5o6HpsQK5cimWt1cPCXI1JOHcd4=;
        h=Subject:To:Cc:From:Date:From;
        b=ntS0j19lTpCxAkFhvYldUH9EY6WACEiy7T3MtANEltRtTNXOawRRm5NevZtU05SrC
         ak7rIj/ePYW6G4o+OVNFxrJd7K7mhp5XUUAd3mgBoQDYKGic8wHVfCDKoN3RuPuCqB
         ObiYtLDd3ytOkrc43Tu9XhoqbWdzIV2xx8Z7FG4s=
Subject: FAILED: patch "[PATCH] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL" failed to apply to 5.15-stable tree
To:     mhiramat@kernel.org, broonie@kernel.org, catalin.marinas@arm.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 Jan 2022 14:31:07 +0100
Message-ID: <164346306729246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1e0924bd09916fab795fc2a21ec1d148f24299fd Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Mon, 24 Jan 2022 17:17:54 +0900
Subject: [PATCH] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL

Mark the start_backtrace() as notrace and NOKPROBE_SYMBOL
because this function is called from ftrace and lockdep to
get the caller address via return_address(). The lockdep
is used in kprobes, it should also be NOKPROBE_SYMBOL.

Fixes: b07f3499661c ("arm64: stacktrace: Move start_backtrace() out of the header")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/164301227374.1433152.12808232644267107415.stgit@devnote2
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 0fb58fed54cb..e4103e085681 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,8 +33,8 @@
  */
 
 
-static void start_backtrace(struct stackframe *frame, unsigned long fp,
-			    unsigned long pc)
+static notrace void start_backtrace(struct stackframe *frame, unsigned long fp,
+				    unsigned long pc)
 {
 	frame->fp = fp;
 	frame->pc = pc;
@@ -55,6 +55,7 @@ static void start_backtrace(struct stackframe *frame, unsigned long fp,
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 }
+NOKPROBE_SYMBOL(start_backtrace);
 
 /*
  * Unwind from one frame record (A) to the next frame record (B).

