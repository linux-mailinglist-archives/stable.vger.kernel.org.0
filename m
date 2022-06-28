Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE5055EBBB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiF1SDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 14:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiF1SC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 14:02:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1369213CC2;
        Tue, 28 Jun 2022 11:02:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3C0761A7B;
        Tue, 28 Jun 2022 18:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5F9C341CA;
        Tue, 28 Jun 2022 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656439346;
        bh=Q9TQo1YpqN5c0AN7PcviO9s8yzNZpGDadJSGpTvGND8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKiiaPzf2ZvHFLudRBkGB21dFDVzVaSbQQHMWq0KyyzxdxN871GhxPOoIK0ZjgIaI
         xjGSO0xKxWknDuxYwa0rK0HcYswkrrUUVcHBZ29G5uC3R4vnyKpDpxvXjproBWDJIH
         /L7DuPZE4pWblmD2QiBgnSmfGclV5jQ5NFOKnO0Jrh1dAFcMCwVAYXV35c7fMvgohr
         vFmI74CAVk+Mb2omqoTl83GdIpB+1U1p4dhZo/oeYREiwY5KgQZqvJ5xKWsLeHwpLZ
         gAgAVOufdBYK3UJlKLIERiVA++LWOsinbqwoNuELI4PD6bcDMd4YRrjzgJX71gdXAK
         +h7jenDRStdZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, maz@kernel.org,
        shuah@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH MANUALSEL 5.18 2/3] selftests: KVM: Handle compiler optimizations in ucall
Date:   Tue, 28 Jun 2022 14:02:16 -0400
Message-Id: <20220628180220.621172-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628180220.621172-1-sashal@kernel.org>
References: <20220628180220.621172-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raghavendra Rao Ananta <rananta@google.com>

[ Upstream commit 9e2f6498efbbc880d7caa7935839e682b64fe5a6 ]

The selftests, when built with newer versions of clang, is found
to have over optimized guests' ucall() function, and eliminating
the stores for uc.cmd (perhaps due to no immediate readers). This
resulted in the userspace side always reading a value of '0', and
causing multiple test failures.

As a result, prevent the compiler from optimizing the stores in
ucall() with WRITE_ONCE().

Suggested-by: Ricardo Koller <ricarkol@google.com>
Suggested-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Message-Id: <20220615185706.1099208-1-rananta@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/ucall.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index e0b0164e9af8..be1d9728c4ce 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -73,20 +73,19 @@ void ucall_uninit(struct kvm_vm *vm)
 
 void ucall(uint64_t cmd, int nargs, ...)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
+	struct ucall uc = {};
 	va_list va;
 	int i;
 
+	WRITE_ONCE(uc.cmd, cmd);
 	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
 
 	va_start(va, nargs);
 	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
+		WRITE_ONCE(uc.args[i], va_arg(va, uint64_t));
 	va_end(va);
 
-	*ucall_exit_mmio_addr = (vm_vaddr_t)&uc;
+	WRITE_ONCE(*ucall_exit_mmio_addr, (vm_vaddr_t)&uc);
 }
 
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
-- 
2.35.1

