Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5307066CBCE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbjAPRSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234446AbjAPRRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:17:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACD1530E1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56218B80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F70C433D2;
        Mon, 16 Jan 2023 16:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888256;
        bh=nUPHlsX0dveVVhsCD/Q3sp3bXMZPCZY7s00RAOU5A2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbM/oucZTYxEQRXn0m7BfpQvmcBPrYgmw9ummVc9BuVSD0+g8asKxj767nipO290o
         WfwjN7FskND043tWSeyitDkFrEH3mt0zT/9Ia0XYPlYtf6bJQ+Gu5nVJQwj7paQE0j
         f7D4XZjheE7ftAGt5DhQRSk4AgV9Y8C6RQ7wUNHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guo Ren <guoren@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 430/521] riscv: stacktrace: Fixup ftrace_graph_ret_addr retp argument
Date:   Mon, 16 Jan 2023 16:51:32 +0100
Message-Id: <20230116154906.369997562@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 5c3022e4a616d800cf5f4c3a981d7992179e44a1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 3d1e184e39e9..75ed5b5b1f9b 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -69,7 +69,7 @@ static void notrace walk_stackframe(struct task_struct *task,
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}
-- 
2.35.1



