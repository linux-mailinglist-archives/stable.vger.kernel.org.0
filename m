Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4CD65D89C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjADQQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239871AbjADQQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:16:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0E541D7E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:15:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA91B617A9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFE0C433D2;
        Wed,  4 Jan 2023 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848958;
        bh=crwRSUmU+3Quc+5mw88khZvxEgG14IXUugIzMdhQ0+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0cIDXwEA4nPJsPq0u8Pa3vA1oUFsoS6Q20N1i//lN/Cn2zY4XES71e6Ad0JCaQEPO
         LSQB9dP1F5XMt3sybFPqX+ExTZggZtQFeVRd9VdL2Qq27+vTIXzwMmfRkoK0aFzhYH
         0ls9hGjUM274m/r+87B3WNbdi/dWg6eayrH6/3ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 087/207] ftrace/x86: Add back ftrace_expected for ftrace bug reports
Date:   Wed,  4 Jan 2023 17:05:45 +0100
Message-Id: <20230104160514.697052116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit fd3dc56253acbe9c641a66d312d8393cd55eb04c upstream.

After someone reported a bug report with a failed modification due to the
expected value not matching what was found, it came to my attention that
the ftrace_expected is no longer set when that happens. This makes for
debugging the issue a bit more difficult.

Set ftrace_expected to the expected code before calling ftrace_bug, so
that it shows what was expected and why it failed.

Link: https://lore.kernel.org/all/CA+wXwBQ-VhK+hpBtYtyZP-NiX4g8fqRRWithFOHQW-0coQ3vLg@mail.gmail.com/
Link: https://lore.kernel.org/linux-trace-kernel/20221209105247.01d4e51d@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "x86@kernel.org" <x86@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 768ae4406a5c ("x86/ftrace: Use text_poke()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -217,7 +217,9 @@ void ftrace_replace_code(int enable)
 
 		ret = ftrace_verify_code(rec->ip, old);
 		if (ret) {
+			ftrace_expected = old;
 			ftrace_bug(ret, rec);
+			ftrace_expected = NULL;
 			return;
 		}
 	}


