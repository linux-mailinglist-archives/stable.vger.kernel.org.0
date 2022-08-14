Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5000B5921A2
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240929AbiHNPiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239944AbiHNPhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E19205F2;
        Sun, 14 Aug 2022 08:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CFF660BC9;
        Sun, 14 Aug 2022 15:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83224C433D7;
        Sun, 14 Aug 2022 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491138;
        bh=wx7auUZauTUrHSIJMex3tejmGanZog/dMv720xCvWTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ijf/sVlqE0jSmuqda603FRotRLuFP0X/Plpd+/36M4aYGpqsQfuTx26FLVtHGHFNF
         kkZJSbeR2e5ZWOyBl/hXEsiqQt9c+iTY5PmYgEu8xxbd1a/A+fLluU4ByGrDM1h5cm
         6ttulPlQ2oA3CNjsB3DqR7eECmmS+OcRufOWXEaKNW2Om8pOwnU2DroyvMrffsVBjn
         27VaLU/4Z5I9gKfRdW9DSZkiylbPRy3X06a6nPjAhUJVM/ks65Q2FtrMHtMDKwigJZ
         yOuMfKmYp8dzQj0ASIRH/2xZV7MTOljaJMJ0mbRFQDJUrm4NzLL7+ggrPpRy5MmXdm
         lO2EAOJFXXRcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liao Chang <liaochang1@huawei.com>,
        Chen Guokai <chenguokai17@mails.ucas.ac.cn>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Guo Ren <guoren@kernel.org>, Sasha Levin <sashal@kernel.org>,
        rostedt@goodmis.org, lkp@intel.com, linux-csky@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 43/56] csky/kprobe: reclaim insn_slot on kprobe unregistration
Date:   Sun, 14 Aug 2022 11:30:13 -0400
Message-Id: <20220814153026.2377377-43-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit a2310c74d418deca0f1d749c45f1f43162510f51 ]

On kprobe registration kernel allocate one insn_slot for new kprobe,
but it forget to reclaim the insn_slot on unregistration, leading to a
potential leakage.

Reported-by: Chen Guokai <chenguokai17@mails.ucas.ac.cn>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/kernel/probes/kprobes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/csky/kernel/probes/kprobes.c b/arch/csky/kernel/probes/kprobes.c
index 34ba684d5962..3c6e5c725d81 100644
--- a/arch/csky/kernel/probes/kprobes.c
+++ b/arch/csky/kernel/probes/kprobes.c
@@ -124,6 +124,10 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
+	if (p->ainsn.api.insn) {
+		free_insn_slot(p->ainsn.api.insn, 0);
+		p->ainsn.api.insn = NULL;
+	}
 }
 
 static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-- 
2.35.1

