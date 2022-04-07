Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA2A4F779D
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241859AbiDGHgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241864AbiDGHgJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD111903C8;
        Thu,  7 Apr 2022 00:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A298B826B6;
        Thu,  7 Apr 2022 07:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393E2C385A9;
        Thu,  7 Apr 2022 07:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649316845;
        bh=Lq9EhyRijx1cfe4dEDp+AdieXvyyIhRaAjpvB7W8v1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMVhkWDgaKW7xR+gIWxFoU2fJjcz2m9cvJ8rHJeSJCXIE8aZFvMrAW/BStymn+T2e
         0rQr1eouZWS72DT7IKe+1k5LDSIb14lGiB+icEK/brzv4tOvm8icRFHRL95VcKxtUL
         WKlxZBpH7tUCydPdcBBWDN6RxszZJ113iYYEws+rF9PPybUOBUyLvUzANlkMGkcX6J
         V+sqIB/OYIjO02NwbgMFGYlRo3P75PgRvJOHwQGjrpv/mhYTLklZFHQlBWW93nWPqX
         2nkdfKPS73HXnFtJXT6u/bToYSDyfA66rkbKPTRPvu2a9yU44xYRjRQmhcb0/elX+b
         bV5un3MkOIEFw==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V4 2/4] riscv: patch_text: Fixup last cpu should be master
Date:   Thu,  7 Apr 2022 15:33:21 +0800
Message-Id: <20220407073323.743224-3-guoren@kernel.org>
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

Fixes: 043cb41a85de ("riscv: introduce interfaces to patch kernel code")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/riscv/kernel/patch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 0b552873a577..765004b60513 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -104,7 +104,7 @@ static int patch_text_cb(void *data)
 	struct patch_insn *patch = data;
 	int ret = 0;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		ret =
 		    patch_text_nosync(patch->addr, &patch->insn,
 					    GET_INSN_LENGTH(patch->insn));
-- 
2.25.1

