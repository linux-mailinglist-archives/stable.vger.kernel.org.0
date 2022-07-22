Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6E957DEC7
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbiGVJXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiGVJXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:23:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A12AC0B5A;
        Fri, 22 Jul 2022 02:14:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AFD1B827BE;
        Fri, 22 Jul 2022 09:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545AAC341C6;
        Fri, 22 Jul 2022 09:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481285;
        bh=Sp4lzYf28TvH726a0QxviKjDpHbCkEZsCj2pLcovfbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djAu6YFb2Ow+mgEnherdbvf400jatDcQkuRTKHBKBjjLsL0nbBn97hI6mbOS3045a
         kgElRJ7N+GFeqcPzCXwGmqoXpWPhYW0AdBfVzNfNKMywplbl9Csp8uH9cpr+JffbXO
         FYkl4k4URoaQmeyPnnq+89scJKHh9J9mXEIKhm0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 39/89] x86/entry: Avoid very early RET
Date:   Fri, 22 Jul 2022 11:11:13 +0200
Message-Id: <20220722091135.548369561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 7c81c0c9210c9bfab2bae76aab2999de5bad27db upstream.

Commit

  ee774dac0da1 ("x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()")

manages to introduce a CALL/RET pair that is before SWITCH_TO_KERNEL_CR3,
which means it is before RETBleed can be mitigated.

Revert to an earlier version of the commit in Fixes. Down side is that
this will bloat .text size somewhat. The alternative is fully reverting
it.

The purpose of this patch was to allow migrating error_entry() to C,
including the whole of kPTI. Much care needs to be taken moving that
forward to not re-introduce this problem of early RETs.

Fixes: ee774dac0da1 ("x86/entry: Move PUSH_AND_CLEAR_REGS out of error_entry()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry_64.S |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -314,14 +314,6 @@ SYM_CODE_END(ret_from_fork)
 #endif
 .endm
 
-/* Save all registers in pt_regs */
-SYM_CODE_START_LOCAL(push_and_clear_regs)
-	UNWIND_HINT_FUNC
-	PUSH_AND_CLEAR_REGS save_ret=1
-	ENCODE_FRAME_POINTER 8
-	RET
-SYM_CODE_END(push_and_clear_regs)
-
 /**
  * idtentry_body - Macro to emit code calling the C function
  * @cfunc:		C function to be called
@@ -329,8 +321,8 @@ SYM_CODE_END(push_and_clear_regs)
  */
 .macro idtentry_body cfunc has_error_code:req
 
-	call push_and_clear_regs
-	UNWIND_HINT_REGS
+	PUSH_AND_CLEAR_REGS
+	ENCODE_FRAME_POINTER
 
 	/*
 	 * Call error_entry() and switch to the task stack if from userspace.


