Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338B5541CF1
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378838AbiFGWHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382686AbiFGWEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:04:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D453025025A;
        Tue,  7 Jun 2022 12:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87236B823C6;
        Tue,  7 Jun 2022 19:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6906C385A5;
        Tue,  7 Jun 2022 19:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629291;
        bh=Qf0riGe9jag1RYINbAwIoHFgerM8YVcYGRZBgOZVPGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0q1OAIDTASiJVC6Fb3FK8+5VPgj6Yn33g7vq8d0FtLaj8OOUenBIJoOBP3UzxEgE
         /DAMTDTnP4wUQT333YTYP/2owt/pCZqoWe/D6y/eKepZpkzg2CwuJBOm5VPmuK2H0y
         Q24VuAkGsmFGEQplPbh+RvHyY+CIa9UcYsAGzkDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabiano Rosas <farosas@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 631/879] KVM: PPC: Book3S HV: Fix vcore_blocked tracepoint
Date:   Tue,  7 Jun 2022 19:02:29 +0200
Message-Id: <20220607165021.164568507@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 43af871383c2..aef0a6b423d8 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4233,13 +4233,13 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
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
@@ -4619,9 +4619,9 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
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
index 38cd0ed0a617..32e2cb5811cc 100644
--- a/arch/powerpc/kvm/trace_hv.h
+++ b/arch/powerpc/kvm/trace_hv.h
@@ -409,9 +409,9 @@ TRACE_EVENT(kvmppc_run_core,
 );
 
 TRACE_EVENT(kvmppc_vcore_blocked,
-	TP_PROTO(struct kvmppc_vcore *vc, int where),
+	TP_PROTO(struct kvm_vcpu *vcpu, int where),
 
-	TP_ARGS(vc, where),
+	TP_ARGS(vcpu, where),
 
 	TP_STRUCT__entry(
 		__field(int,	n_runnable)
@@ -421,8 +421,8 @@ TRACE_EVENT(kvmppc_vcore_blocked,
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



