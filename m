Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83900658123
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiL1QZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbiL1QYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 839C9193FD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ECED61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F6DC433EF;
        Wed, 28 Dec 2022 16:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244500;
        bh=47Y3qKzYRJ0T50+xPuYBHm9CLjHCJ3hCHFjrybI+lDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6lwrq2bcVZK84D/++wIy+1bmEPWRm3IQoFer2xblpZnykqdjqZayv7GZA1aQJ41M
         jj7VqMM+G5H7xCshL8fWgRHgSCxC+XnMS5GPu6mrJtQeJWQVdSySveBhYmcLKbyjtB
         F/TEYQusYAjMYKpDN7vOhjpuNdyBnWA1arlH+qEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0684/1146] RISC-V: Align the shadow stack
Date:   Wed, 28 Dec 2022 15:37:03 +0100
Message-Id: <20221228144348.721955025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit b003b3b77d65133a0011ae3b7b255347438c12f6 ]

The standard RISC-V ABIs all require 16-byte stack alignment.  We're
only calling that one function on the shadow stack so I doubt it'd
result in a real issue, but might as well keep this lined up.

Fixes: 31da94c25aea ("riscv: add VMAP_STACK overflow detection")
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20221130023515.20217-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 7abd8e4c4df6..f77cb8e42bd2 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -214,7 +214,7 @@ static DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)],
  * shadow stack, handled_ kernel_ stack_ overflow(in kernel/entry.S) is used
  * to get per-cpu overflow stack(get_overflow_stack).
  */
-long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE/sizeof(long)];
+long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE/sizeof(long)] __aligned(16);
 asmlinkage unsigned long get_overflow_stack(void)
 {
 	return (unsigned long)this_cpu_ptr(overflow_stack) +
-- 
2.35.1



