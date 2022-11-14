Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802E3627F40
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiKNM5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237631AbiKNM4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:56:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB8A27FD2
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:56:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20F876117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CE7C433C1;
        Mon, 14 Nov 2022 12:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430607;
        bh=j9yKFrhA/F0giMI4oDwD+edFBDBBlDPzqW5eSZVCI0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgAnX1mclhh0Pu/9GsZfMqMmbmS7ITPj4Q4yQCS18ShsvuGHxmPFfLGEDIMyocR8I
         7HHSUDj4WPidpWx1VrXFVJ+t5GGWNqFVRAZvGkohwSE3yv6kmwJ74gmLqt3aYFhGEE
         dAiLaeOTSjJ+RMXkR/UAn2Wc4tD/QGkuprydreZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jisheng Zhang <jszhang@kernel.org>,
        Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/131] riscv: process: fix kernel info leakage
Date:   Mon, 14 Nov 2022 13:45:48 +0100
Message-Id: <20221114124452.032206892@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 6510c78490c490a6636e48b61eeaa6fb65981f4b ]

thread_struct's s[12] may contain random kernel memory content, which
may be finally leaked to userspace. This is a security hole. Fix it
by clearing the s[12] array in thread_struct when fork.

As for kthread case, it's better to clear the s[12] array as well.

Fixes: 7db91e57a0ac ("RISC-V: Task implementation")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Tested-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/20221029113450.4027-1-jszhang@kernel.org
Reviewed-by: Guo Ren <guoren@kernel.org>
Link: https://lore.kernel.org/r/CAJF2gTSdVyAaM12T%2B7kXAdRPGS4VyuO08X1c7paE-n4Fr8OtRA@mail.gmail.com/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 03ac3aa611f5..bda3bc294718 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -124,6 +124,8 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 
+	memset(&p->thread.s, 0, sizeof(p->thread.s));
+
 	/* p->thread holds context to be restored by __switch_to() */
 	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
 		/* Kernel thread */
-- 
2.35.1



