Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B393559E02A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352371AbiHWKJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352365AbiHWKH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F451F60D;
        Tue, 23 Aug 2022 01:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 969FD61377;
        Tue, 23 Aug 2022 08:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4A0C433C1;
        Tue, 23 Aug 2022 08:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244845;
        bh=KhAVJVsW5ZyI4JPgfcT2xD3IGyGxt0aYxQfG8+XJ4rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4bv1op8gjrrcLkiOUIKMfLSRWCABnA023SncTtwYysLJiDw8x/qddjrEnKT0nPQD
         hc8zsTxtOGIfaVUTkONLzgDnPL4lS0NlSusyPyNtBe5zVGEkkANS+kK/WU/0oJYzYF
         eFRfNwv/xLM17DEExm/JDFslZtQaDXJni3WkoAFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/244] KVM: arm64: Reject 32bit user PSTATE on asymmetric systems
Date:   Tue, 23 Aug 2022 10:25:20 +0200
Message-Id: <20220823080104.571890862@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit b10d86fb8e46cc812171728bcd326df2f34e9ed5 ]

KVM does not support AArch32 EL0 on asymmetric systems. To that end,
prevent userspace from configuring a vCPU in such a state through
setting PSTATE.

It is already ABI that KVM rejects such a write on a system where
AArch32 EL0 is unsupported. Though the kernel's definition of a 32bit
system changed in commit 2122a833316f ("arm64: Allow mismatched
32-bit EL0 support"), KVM's did not.

Fixes: 2122a833316f ("arm64: Allow mismatched 32-bit EL0 support")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220816192554.1455559-3-oliver.upton@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..94108e2e0917 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -242,7 +242,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		u64 mode = (*(u64 *)valp) & PSR_AA32_MODE_MASK;
 		switch (mode) {
 		case PSR_AA32_MODE_USR:
-			if (!system_supports_32bit_el0())
+			if (!kvm_supports_32bit_el0())
 				return -EINVAL;
 			break;
 		case PSR_AA32_MODE_FIQ:
-- 
2.35.1



