Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A405D59DDBE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354132AbiHWKY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354797AbiHWKWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20F0B1E3;
        Tue, 23 Aug 2022 02:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 187B561580;
        Tue, 23 Aug 2022 09:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7E5C433D6;
        Tue, 23 Aug 2022 09:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245408;
        bh=qLA7A5Br4kr6XCh5cM4QAi+8idAHdklGHyK/3mm2rt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtF1ZWLHX+lb0fBC229uxPfp31AUNIbihNHApTF/Np7r3C6rfp3Ignh/SEcXyMLxb
         m2eR80BnsxSlkSU33rW0qMl4Cf5rvY9HB+aOzFHAd7JMgjkt5QUAex47G4msRG9WTD
         n2+l28eusqTSYSXCZQ2JE8rEk4PCwGlSWWPTYXhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francis Laniel <flaniel@linux.microsoft.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/287] arm64: Do not forget syscall when starting a new thread.
Date:   Tue, 23 Aug 2022 10:23:28 +0200
Message-Id: <20220823080101.584936413@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Francis Laniel <flaniel@linux.microsoft.com>

[ Upstream commit de6921856f99c11d3986c6702d851e1328d4f7f6 ]

Enable tracing of the execve*() system calls with the
syscalls:sys_exit_execve tracepoint by removing the call to
forget_syscall() when starting a new thread and preserving the value of
regs->syscallno across exec.

Signed-off-by: Francis Laniel <flaniel@linux.microsoft.com>
Link: https://lore.kernel.org/r/20220608162447.666494-2-flaniel@linux.microsoft.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/processor.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 773ea8e0e442..f81074c68ff3 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -172,8 +172,9 @@ void tls_preserve_current_state(void);
 
 static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
 {
+	s32 previous_syscall = regs->syscallno;
 	memset(regs, 0, sizeof(*regs));
-	forget_syscall(regs);
+	regs->syscallno = previous_syscall;
 	regs->pc = pc;
 }
 
-- 
2.35.1



