Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CB36BB36F
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbjCOMof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbjCOMoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:44:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4969A5927
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A461C61CC2
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC92AC433EF;
        Wed, 15 Mar 2023 12:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884147;
        bh=d7+kc+gWXq5ZyIrrqwOoh9kM+3TAzAMMcA49QzJ/0RI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huDYAUmocw2w0JxMHEaqWN/Z5LMFxlPufY2/cr6bAoEv8zaZTPWULPzgwVjZ9B1uW
         Mv6//7/bz12/DDvKvW1Z5lL/r7ErHn7AcEV8PxXuvKxgiTSFP+H3mLTc+c22CexoZh
         bSYLiko7UoeZw72aLQ5TeFqjWqgl+JoJi79MKCsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 124/141] powerpc: Remove __kernel_text_address() in show_instructions()
Date:   Wed, 15 Mar 2023 13:13:47 +0100
Message-Id: <20230315115743.770086211@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit d9ab6da64fd15608c9feb20d769d8df1a32fe212 ]

That test was introducted in 2006 by
commit 00ae36de49cc ("[POWERPC] Better check in show_instructions").
At that time, there was no BPF progs.

As seen in message of commit 89d21e259a94 ("powerpc/bpf/32: Fix Oops
on tail call tests"), when a page fault occurs in test_bpf.ko for
instance, the code is dumped as XXXXXXXXs. Allthough
__kernel_text_address() checks is_bpf_text_address(), it seems it is
not enough.

Today, show_instructions() uses get_kernel_nofault() to read the code,
so there is no real need for additional verifications.

ARM64 and x86 don't do any additional check before dumping
instructions. Do the same and remove __kernel_text_address()
in show_instructions().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4fd69ef7945518c3e27f96b95046a5c1468d35bf.1675245773.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/process.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index c22cc234672f9..effe9697905dc 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1405,8 +1405,7 @@ static void show_instructions(struct pt_regs *regs)
 	for (i = 0; i < NR_INSN_TO_PRINT; i++) {
 		int instr;
 
-		if (!__kernel_text_address(pc) ||
-		    get_kernel_nofault(instr, (const void *)pc)) {
+		if (get_kernel_nofault(instr, (const void *)pc)) {
 			pr_cont("XXXXXXXX ");
 		} else {
 			if (nip == pc)
-- 
2.39.2



