Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63D5415FA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376407AbiFGUnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377298AbiFGUdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFF11E3B23;
        Tue,  7 Jun 2022 11:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D8B60B3D;
        Tue,  7 Jun 2022 18:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61785C385A5;
        Tue,  7 Jun 2022 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626884;
        bh=0hnrDxBMOqsivW40nLJd3AIIdOwo4+bA30YVTdbKlFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvMQ1Uyd7HYpeZlVg2EXBzOzkcUeydxwL1ZSp5vIAENMEWB56pUii7FjYEm3USeAZ
         6eAC4Ju1ny1qJeccOfaN6SGUUvnFaKkpNoL62yAddT4HrQ1OoNMYsGHjfiSM8ItZ+i
         i3JpApDdS4yEnbl0eIA0Rrs8TtNZzJne7858cfbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 539/772] KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint
Date:   Tue,  7 Jun 2022 19:02:11 +0200
Message-Id: <20220607165004.848635400@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabiano Rosas <farosas@linux.ibm.com>

[ Upstream commit ad55bae7dc364417434b69dd6c30104f20d0f84d ]

We removed most of the vcore logic from the P9 path but there's still
a tracepoint that tried to dereference vc->runner.

Fixes: ecb6a7207f92 ("KVM: PPC: Book3S HV P9: Remove most of the vcore logic")
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220328215831.320409-1-farosas@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 8 ++++----
 arch/powerpc/kvm/trace_hv.h  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 0da8c0df768d..85a3b756e0b0 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4238,13 +4238,13 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	start_wait = ktime_get();
 
 	vc->vcore_state = VCORE_SLEEPING;
-	trace_kvmppc_vcore_blocked(vc, 0);
+	trace_kvmppc_vcore_blocked(vc->runner, 0);
 	spin_unlock(&vc->lock);
 	schedule();
 	finish_rcuwait(&vc->wait);
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
-	trace_kvmppc_vcore_blocked(vc, 1);
+	trace_kvmppc_vcore_blocked(vc->runner, 1);
 	++vc->runner->stat.halt_successful_wait;
 
 	cur = ktime_get();
@@ -4624,9 +4624,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
 			if (kvmppc_vcpu_check_block(vcpu))
 				break;
 
-			trace_kvmppc_vcore_blocked(vc, 0);
+			trace_kvmppc_vcore_blocked(vcpu, 0);
 			schedule();
-			trace_kvmppc_vcore_blocked(vc, 1);
+			trace_kvmppc_vcore_blocked(vcpu, 1);
 		}
 		finish_rcuwait(wait);
 	}
diff --git a/arch/powerpc/kvm/trace_hv.h b/arch/powerpc/kvm/trace_hv.h
index 830a126e095d..9c56da21a075 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -408,9 +408,9 @@ TRACE_EVENT(kvmppc_run_core,
 );
 
 TRACE_EVENT(kvmppc_vcore_blocked,
-	TP_PROTO(struct kvmppc_vcore *vc, int where),
+	TP_PROTO(struct kvm_vcpu *vcpu, int where),
 
-	TP_ARGS(vc, where),
+	TP_ARGS(vcpu, where),
 
 	TP_STRUCT__entry(
 		__field(int,	n_runnable)
@@ -420,8 +420,8 @@ TRACE_EVENT(kvmppc_vcore_blocked,
 	),
 
 	TP_fast_assign(
-		__entry->runner_vcpu = vc->runner->vcpu_id;
-		__entry->n_runnable  = vc->n_runnable;
+		__entry->runner_vcpu = vcpu->vcpu_id;
+		__entry->n_runnable  = vcpu->arch.vcore->n_runnable;
 		__entry->where       = where;
 		__entry->tgid	     = current->tgid;
 	),
-- 
2.35.1



