Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFD459A332
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353827AbiHSQo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353702AbiHSQnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A0D111C1F;
        Fri, 19 Aug 2022 09:11:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA94B617A5;
        Fri, 19 Aug 2022 16:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1E4C433D6;
        Fri, 19 Aug 2022 16:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925387;
        bh=pA8ISevhUsGe/p5+9L1xkYfUhHfjRk8HP8uS3OlHxrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXT0Le89m5TMyOI2g6MZ/cTgLXhkM2aH1WsXX2LHo8TV2np+I00uEaKQ3YzmcsSN3
         AWGga7MuSLubxkZ2UTDMibFXgOpx1B0u5PT9qLtDaNsxRP6EBkUUNNZ9V/Pf3tagyy
         uxo+rSIy1YB+xlKrlhJZeyTV0SBGJeVeHT7x21xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "x86@kernel.org" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 446/545] ftrace/x86: Add back ftrace_expected assignment
Date:   Fri, 19 Aug 2022 17:43:36 +0200
Message-Id: <20220819153849.395764010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit ac6c1b2ca77e722a1e5d651f12f437f2f237e658 upstream.

When a ftrace_bug happens (where ftrace fails to modify a location) it is
helpful to have what was at that location as well as what was expected to
be there.

But with the conversion to text_poke() the variable that assigns the
expected for debugging was dropped. Unfortunately, I noticed this when I
needed it. Add it back.

Link: https://lkml.kernel.org/r/20220726101851.069d2e70@gandalf.local.home

Cc: "x86@kernel.org" <x86@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Fixes: 768ae4406a5c ("x86/ftrace: Use text_poke()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -93,6 +93,7 @@ static int ftrace_verify_code(unsigned l
 
 	/* Make sure it is what we expect it to be */
 	if (memcmp(cur_code, old_code, MCOUNT_INSN_SIZE) != 0) {
+		ftrace_expected = old_code;
 		WARN_ON(1);
 		return -EINVAL;
 	}


