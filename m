Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6249459241A
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbiHNQ21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242362AbiHNQ1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:27:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785BE108A;
        Sun, 14 Aug 2022 09:23:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C86CB80B7E;
        Sun, 14 Aug 2022 16:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C21C433D6;
        Sun, 14 Aug 2022 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494219;
        bh=VziyZwYaiI2XjJAGJqmfymcTUHj6O9Hj9Y370mGm6oQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEy0XDk5tTYVGDV/RQBSVF7s9JEFgfHFEZVjxz5S73ztAKYjr5WzhoG/i9+0SYZLr
         AexmFBThsZLJXizt2uOc7T8k7RCs6A+vO59n4UpxcGwRl4zveeUy+tJ8Il2JAr5UoX
         +tk3RlOFg86JyRvJF3hAcxm6vmQJZwsoNf5Sw77OAKig6v41Ff/hbNcagJdIQ1od+U
         gKBC9xd43T69QwrftCBysLsgnyTEOqfgSwuLARP9Woq2p2VirvrmMPeWScqSH+unGm
         r8DaGqMrt1cyTKO3MirWlGFnn5F8MMu9bMSejS77HXckA99AqNLedBdNZX/aEg0fL7
         VQcxgA/R6G9SQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, npiggin@gmail.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.18 03/39] KVM: PPC: Book3S HV: Fix "rm_exit" entry in debugfs timings
Date:   Sun, 14 Aug 2022 12:22:52 -0400
Message-Id: <20220814162332.2396012-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
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

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit 9981bace85d816ed8724ac46e49285e8488d29e6 ]

At debugfs/kvm/<pid>/vcpu0/timings we show how long each part of the
code takes to run:

$ cat /sys/kernel/debug/kvm/*-*/vcpu0/timings
rm_entry: 123785 49398892 118 4898
rm_intr: 123780 6075890 22 390
rm_exit: 0 0 0 0                     <-- NOK
guest: 123780 46732919988 402 9997638
cede: 0 0 0 0                        <-- OK, no cede napping in P9

The "rm_exit" is always showing zero because it is the last one and
end_timing does not increment the counter of the previous entry.

We can fix it by calling accumulate_time again instead of
end_timing. That way the counter gets incremented. The rest of the
arithmetic can be ignored because there are no timing points after
this and the accumulators are reset before the next round.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220525130554.2614394-2-farosas@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv_p9_entry.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index a28e5b3daabd..f7591b6c92d1 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -438,15 +438,6 @@ void restore_p9_host_os_sprs(struct kvm_vcpu *vcpu,
 EXPORT_SYMBOL_GPL(restore_p9_host_os_sprs);
 
 #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING
-static void __start_timing(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
-{
-	struct kvmppc_vcore *vc = vcpu->arch.vcore;
-	u64 tb = mftb() - vc->tb_offset_applied;
-
-	vcpu->arch.cur_activity = next;
-	vcpu->arch.cur_tb_start = tb;
-}
-
 static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator *next)
 {
 	struct kvmppc_vcore *vc = vcpu->arch.vcore;
@@ -478,8 +469,8 @@ static void __accumulate_time(struct kvm_vcpu *vcpu, struct kvmhv_tb_accumulator
 	curr->seqcount = seq + 2;
 }
 
-#define start_timing(vcpu, next) __start_timing(vcpu, next)
-#define end_timing(vcpu) __start_timing(vcpu, NULL)
+#define start_timing(vcpu, next) __accumulate_time(vcpu, next)
+#define end_timing(vcpu) __accumulate_time(vcpu, NULL)
 #define accumulate_time(vcpu, next) __accumulate_time(vcpu, next)
 #else
 #define start_timing(vcpu, next) do {} while (0)
-- 
2.35.1

