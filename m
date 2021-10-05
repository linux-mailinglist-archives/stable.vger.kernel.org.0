Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46181422890
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbhJENxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235495AbhJENwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D82617E3;
        Tue,  5 Oct 2021 13:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441856;
        bh=+Zz8nIxHkcfBTCM4F23ZXRh80YwkMvyTTEPJ/v4wdQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0WiQV/JEjVkh19uSlGKjmsuuRfkR2JKMOoXPmF1y50Y9AvGqU7A1dy9nUBUv0Yws
         j3TMwm9myuX9LxigKZs8Pj3nVUrrRq23GrbCVW9n68qWuGRUflfjsvlC4/rrEQNPZD
         EaezPF0JnUOgD7ykVWpbmEdb3FVew9H3olwGWzxbHXuEt10ksfXLgg4ncI+E+FVMns
         /WOMEQpIKQoItIAoFfVCDrF/OpweOBoTxYkk9awSTw//C//dSohqcZzl8q/5rH+9V/
         bpTEz9iZnlAbriSsxffos9QwoxwsVqPeZYUnP7m1fmg3tt+bZlfIULf1YYIjKxKaZe
         NyR8WMbS/jU6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        David Brazdil <dbrazdil@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
        keescook@chromium.org, samitolvanen@google.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.14 16/40] KVM: arm64: nvhe: Fix missing FORCE for hyp-reloc.S build rule
Date:   Tue,  5 Oct 2021 09:49:55 -0400
Message-Id: <20211005135020.214291-16-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit a49b50a3c1c3226d26e1dd11e8b763f27e477623 ]

Add FORCE so that if_changed can detect the command line change.

We'll otherwise see a compilation warning since commit e1f86d7b4b2a
("kbuild: warn if FORCE is missing for if_changed(_dep,_rule) and
filechk").

arch/arm64/kvm/hyp/nvhe/Makefile:58: FORCE prerequisite is missing

Cc: David Brazdil <dbrazdil@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210907052137.1059-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 5df6193fc430..8d741f71377f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -54,7 +54,7 @@ $(obj)/kvm_nvhe.tmp.o: $(obj)/hyp.lds $(addprefix $(obj)/,$(hyp-obj)) FORCE
 #    runtime. Because the hypervisor is part of the kernel binary, relocations
 #    produce a kernel VA. We enumerate relocations targeting hyp at build time
 #    and convert the kernel VAs at those positions to hyp VAs.
-$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel
+$(obj)/hyp-reloc.S: $(obj)/kvm_nvhe.tmp.o $(obj)/gen-hyprel FORCE
 	$(call if_changed,hyprel)
 
 # 5) Compile hyp-reloc.S and link it into the existing partially linked object.
-- 
2.33.0

