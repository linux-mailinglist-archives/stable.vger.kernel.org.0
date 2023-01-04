Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC865D8CA
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbjADQSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbjADQSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:18:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ACAF581
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:18:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 328AE617AA
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4185AC433D2;
        Wed,  4 Jan 2023 16:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849089;
        bh=wHJNlAyPP2Wn7YPgX7H3tucz7VLrm4cDpOvW54T+hXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNaYuRu4Tr7St888x457O+LiAfieqmOGF2BFdHin1NOUyg4FyYE+rbGLRoPu0mALb
         y1psym5LNz5vzu0qoWEt/u8jFcqrSqfrrTokwOFj36HsdisuSI9h8tNEepVWLuh7xO
         S5nyBc+6+HSevrQdlmRH1cQ6P3OMJ18Bb189eNdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 131/207] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument
Date:   Wed,  4 Jan 2023 17:06:29 +0100
Message-Id: <20230104160516.070850718@linuxfoundation.org>
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

From: Guo Ren <guoren@linux.alibaba.com>

commit 5c3022e4a616d800cf5f4c3a981d7992179e44a1 upstream.

The 'retp' is a pointer to the return address on the stack, so we
must pass the current return address pointer as the 'retp'
argument to ftrace_push_return_trace(). Not parent function's
return address on the stack.

Fixes: b785ec129bd9 ("riscv/ftrace: Add HAVE_FUNCTION_GRAPH_RET_ADDR_PTR support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20221109064937.3643993-2-guoren@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/stacktrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -58,7 +58,7 @@ void notrace walk_stackframe(struct task
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}


