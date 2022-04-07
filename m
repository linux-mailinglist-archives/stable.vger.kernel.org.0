Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439B24F7797
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241834AbiDGHf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241822AbiDGHf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B0018B300;
        Thu,  7 Apr 2022 00:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A00861D95;
        Thu,  7 Apr 2022 07:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CB7C385A4;
        Thu,  7 Apr 2022 07:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649316838;
        bh=4wIhTQJZp3+FhQY+sjwWCoJ1fY2jda3dTtRoplMPuzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qT2zXYE3CQHTLuX5QZZPQHikYbHh7VPe0bAHwwvmUvmMUnWQIyfU+k7F3AfDIvyRi
         DbQJ6qiQIryUX2TPGaCeCLRIsJKYDUtVi2eW9wk/oS4lUJw8TeMVaDawYhr+g7X8U3
         BD/tIW0R3G5pA+cnnSBuTCL9yC6b2NqcdjvEtbeyIEFds6kbkFoaEJ60l1CqnYGp5C
         wuxNx22nM3sMr0zTrDhJ0Z36oEmgAqj8rk2NkpqWkUNRDlvhwyx3zToIQurA2FvotF
         fTUpZW/MoL2A1cwRv4njUeB8q1emqKBkULf3pSwP3zJi7/NivB+2LX/3X/WfQDDEH9
         88qBx7bdrkZLg==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V4 1/4] arm64: patch_text: Fixup last cpu should be master
Date:   Thu,  7 Apr 2022 15:33:20 +0800
Message-Id: <20220407073323.743224-2-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407073323.743224-1-guoren@kernel.org>
References: <20220407073323.743224-1-guoren@kernel.org>
MIME-Version: 1.0
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

From: Guo Ren <guoren@linux.alibaba.com>

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Fixes: ae16480785de ("arm64: introduce interfaces to hotpatch kernel and module code")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/arm64/kernel/patching.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/patching.c b/arch/arm64/kernel/patching.c
index 771f543464e0..33e0fabc0b79 100644
--- a/arch/arm64/kernel/patching.c
+++ b/arch/arm64/kernel/patching.c
@@ -117,8 +117,8 @@ static int __kprobes aarch64_insn_patch_text_cb(void *arg)
 	int i, ret = 0;
 	struct aarch64_insn_patch *pp = arg;
 
-	/* The first CPU becomes master */
-	if (atomic_inc_return(&pp->cpu_count) == 1) {
+	/* The last CPU becomes master */
+	if (atomic_inc_return(&pp->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
 			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
 							     pp->new_insns[i]);
-- 
2.25.1

