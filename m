Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAEF657C20
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbiL1P3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbiL1P3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:29:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E101571B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:29:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 550BDB8171F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFDBC433D2;
        Wed, 28 Dec 2022 15:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241347;
        bh=PILbjRp90qWjoTB2Lopo8KcaS9aNu38DFlN44/05uKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOSyQWF/jG+6H85iMgzhN7Xz7LU+04p1rmoqnyNuw/VS1mpcGGILXbHgM5D5lp+QG
         h7jnVQHoUJmzR2rJxnF+RW1bhuPGZoVQkiKjZ6ImrADsFCNdgOeH3X8l1R4ewIzRXf
         unF2/b1NiomOy6mVkGUfY908lLOY5Rnxy9PMrqTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0269/1073] bpf: Fix slot type check in check_stack_write_var_off
Date:   Wed, 28 Dec 2022 15:30:57 +0100
Message-Id: <20221228144335.325344950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit f5e477a861e4a20d8a1c5f7a245f3a3c3c376b03 ]

For the case where allow_ptr_leaks is false, code is checking whether
slot type is STACK_INVALID and STACK_SPILL and rejecting other cases.
This is a consequence of incorrectly checking for register type instead
of the slot type (NOT_INIT and SCALAR_VALUE respectively). Fix the
check.

Fixes: 01f810ace9ed ("bpf: Allow variable-offset stack access")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20221103191013.1236066-5-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 65c627571e33..95479562a64a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3169,14 +3169,17 @@ static int check_stack_write_var_off(struct bpf_verifier_env *env,
 		stype = &state->stack[spi].slot_type[slot % BPF_REG_SIZE];
 		mark_stack_slot_scratched(env, spi);
 
-		if (!env->allow_ptr_leaks
-				&& *stype != NOT_INIT
-				&& *stype != SCALAR_VALUE) {
-			/* Reject the write if there's are spilled pointers in
-			 * range. If we didn't reject here, the ptr status
-			 * would be erased below (even though not all slots are
-			 * actually overwritten), possibly opening the door to
-			 * leaks.
+		if (!env->allow_ptr_leaks && *stype != STACK_MISC && *stype != STACK_ZERO) {
+			/* Reject the write if range we may write to has not
+			 * been initialized beforehand. If we didn't reject
+			 * here, the ptr status would be erased below (even
+			 * though not all slots are actually overwritten),
+			 * possibly opening the door to leaks.
+			 *
+			 * We do however catch STACK_INVALID case below, and
+			 * only allow reading possibly uninitialized memory
+			 * later for CAP_PERFMON, as the write may not happen to
+			 * that slot.
 			 */
 			verbose(env, "spilled ptr in range of var-offset stack write; insn %d, ptr off: %d",
 				insn_idx, i);
-- 
2.35.1



