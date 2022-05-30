Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058F9537C20
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbiE3Nbo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237443AbiE3Naa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5193E8CB12;
        Mon, 30 May 2022 06:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1481B80B3A;
        Mon, 30 May 2022 13:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B824C3411C;
        Mon, 30 May 2022 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917243;
        bh=vCRnmPPAkAz3/aZj4ABaUxpyCMnNCPoQsR3C6GEciKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNcjQrhAG7LEgD4EkeXKsyVBYVthmt7YinLGIxVd2EpEysKS6e4x1pa8eU4u4QW3k
         g3RsTttrN7iG6uYwBD0Jwxcwdt+ztk+8ehWtDc3ETFcsRdRVwF83K7VwhL4mhqw0E/
         /ipb3uXQBozMpnojAEvUuXRT7fhqz2X6d7Gt4RudmUxxNUavMWKqiZ28e9BJXP0prq
         BjnCWaQIWu0uMFRdpeBZyIr9jnVUKsIQqXSxi/oTIouckC/Ngz136a++YCF+NtU+fb
         mZJaA76ewVtp12RNcniAWOVuqlNPw4vXIRePaIpDGouMTx50KkezVA2rb+qtpYBrPb
         BiyyqVJXM/oTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, will@kernel.org,
        sagarmp@cs.unc.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.18 069/159] arm64: compat: Do not treat syscall number as ESR_ELx for a bad syscall
Date:   Mon, 30 May 2022 09:22:54 -0400
Message-Id: <20220530132425.1929512-69-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

[ Upstream commit 3fed9e551417b84038b15117732ea4505eee386b ]

If a compat process tries to execute an unknown system call above the
__ARM_NR_COMPAT_END number, the kernel sends a SIGILL signal to the
offending process. Information about the error is printed to dmesg in
compat_arm_syscall() -> arm64_notify_die() -> arm64_force_sig_fault() ->
arm64_show_signal().

arm64_show_signal() interprets a non-zero value for
current->thread.fault_code as an exception syndrome and displays the
message associated with the ESR_ELx.EC field (bits 31:26).
current->thread.fault_code is set in compat_arm_syscall() ->
arm64_notify_die() with the bad syscall number instead of a valid ESR_ELx
value. This means that the ESR_ELx.EC field has the value that the user set
for the syscall number and the kernel can end up printing bogus exception
messages*. For example, for the syscall number 0x68000000, which evaluates
to ESR_ELx.EC value of 0x1A (ESR_ELx_EC_FPAC) the kernel prints this error:

[   18.349161] syscall[300]: unhandled exception: ERET/ERETAA/ERETAB, ESR 0x68000000, Oops - bad compat syscall(2) in syscall[10000+50000]
[   18.350639] CPU: 2 PID: 300 Comm: syscall Not tainted 5.18.0-rc1 #79
[   18.351249] Hardware name: Pine64 RockPro64 v2.0 (DT)
[..]

which is misleading, as the bad compat syscall has nothing to do with
pointer authentication.

Stop arm64_show_signal() from printing exception syndrome information by
having compat_arm_syscall() set the ESR_ELx value to 0, as it has no
meaning for an invalid system call number. The example above now becomes:

[   19.935275] syscall[301]: unhandled exception: Oops - bad compat syscall(2) in syscall[10000+50000]
[   19.936124] CPU: 1 PID: 301 Comm: syscall Not tainted 5.18.0-rc1-00005-g7e08006d4102 #80
[   19.936894] Hardware name: Pine64 RockPro64 v2.0 (DT)
[..]

which although shows less information because the syscall number,
wrongfully advertised as the ESR value, is missing, it is better than
showing plainly wrong information. The syscall number can be easily
obtained with strace.

*A 32-bit value above or equal to 0x8000_0000 is interpreted as a negative
integer in compat_arm_syscal() and the condition scno < __ARM_NR_COMPAT_END
evaluates to true; the syscall will exit to userspace in this case with the
ENOSYS error code instead of arm64_notify_die() being called.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220425114444.368693-3-alexandru.elisei@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/sys_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/sys_compat.c b/arch/arm64/kernel/sys_compat.c
index 12c6864e51e1..df14336c3a29 100644
--- a/arch/arm64/kernel/sys_compat.c
+++ b/arch/arm64/kernel/sys_compat.c
@@ -113,6 +113,6 @@ long compat_arm_syscall(struct pt_regs *regs, int scno)
 	addr = instruction_pointer(regs) - (compat_thumb_mode(regs) ? 2 : 4);
 
 	arm64_notify_die("Oops - bad compat syscall(2)", regs,
-			 SIGILL, ILL_ILLTRP, addr, scno);
+			 SIGILL, ILL_ILLTRP, addr, 0);
 	return 0;
 }
-- 
2.35.1

