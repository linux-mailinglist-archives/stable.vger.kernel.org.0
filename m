Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2A497A18
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 09:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiAXIR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 03:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiAXIR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 03:17:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79601C06173D;
        Mon, 24 Jan 2022 00:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15902611A7;
        Mon, 24 Jan 2022 08:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABACC340E1;
        Mon, 24 Jan 2022 08:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643012277;
        bh=/zmqS8dbVpUrMvVF0fn0ug9jInAB4m/q8XbM5mrGyac=;
        h=From:To:Cc:Subject:Date:From;
        b=QViBeMRDLqqldHim1dCtUDbnxQVBfkPwd4hlRmogKry0fwpFCZ+l/P1zeJtmHLxEG
         BD/Etr8XlTfz2TD85F60Ua6SAWwbxcOFsaz9BMfhnWWeCamWlQytsXSBcU7ypiE4jw
         mP2RcrqkUPPpU2mRiCjadzGDsIsRA2mAW4RSl6pgaZhOMPhgVxLJI6s00UfpxtqxpG
         8HiFbVu+lz3/W68izUJWmazq8VR6uwzUWq/HAlTmBl2w/6/GjBHNvJN0e7ne2pijm9
         ygCJ4G7h5BGFWEd515vvM8wmupkrjI/2Bn3VIkEFMZ9ceF6JPpIUC/Pg5Y+uAuRRFn
         ext8t3UVGD7Jw==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org
Subject: [PATCH] arm64: Mark start_backtrace() notrace and NOKPROBE_SYMBOL
Date:   Mon, 24 Jan 2022 17:17:54 +0900
Message-Id: <164301227374.1433152.12808232644267107415.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mark the start_backtrace() as notrace and NOKPROBE_SYMBOL
because this function is called from ftrace and lockdep to
get the caller address via return_address(). The lockdep
is used in kprobes, it should also be NOKPROBE_SYMBOL.

Fixes: b07f3499661c ("arm64: stacktrace: Move start_backtrace() out of the header")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 arch/arm64/kernel/stacktrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 94f83cd44e50..b0f21677764d 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -33,7 +33,7 @@
  */
 
 
-void start_backtrace(struct stackframe *frame, unsigned long fp,
+void notrace start_backtrace(struct stackframe *frame, unsigned long fp,
 		     unsigned long pc)
 {
 	frame->fp = fp;
@@ -55,6 +55,7 @@ void start_backtrace(struct stackframe *frame, unsigned long fp,
 	frame->prev_fp = 0;
 	frame->prev_type = STACK_TYPE_UNKNOWN;
 }
+NOKPROBE_SYMBOL(start_backtrace);
 
 /*
  * Unwind from one frame record (A) to the next frame record (B).

