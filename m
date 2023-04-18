Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B066E6285
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjDRMdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjDRMdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:33:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BDECC01
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 758ED6321D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E3DC433EF;
        Tue, 18 Apr 2023 12:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821174;
        bh=Yb+sicrT9QnIywc7BHLzgYolBPRKwKY1ilYO8nKPqt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bp5sviqPob3U8J1W/FCQJ1kgfYf1f9vrJk8WoPBvZzCUs81faRGzSG1nPgn55PD06
         q8gO8vtnyvHpKeVay94t9t2Pe8zBJo5QROwf76+WxEMA+m6aegjjUCfus5I1pJcCwN
         X41pCZZf3vD3v6Fqp/u0AVBuw5v3KC4tvogEbPtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nico Boehr <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/124] KVM: s390: pv: fix external interruption loop not always detected
Date:   Tue, 18 Apr 2023 14:20:24 +0200
Message-Id: <20230418120309.785775133@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

[ Upstream commit 21f27df854008b86349a203bf97fef79bb11f53e ]

To determine whether the guest has caused an external interruption loop
upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
be inspected to see whether external interrupts are enabled.

Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
PV, KVM can only access the encrypted guest lowcore and hence the
ext_new_psw must not be taken from guest lowcore.

handle_external_interrupt() incorrectly did that and hence was not able
to reliably tell whether an external interruption loop is happening or
not. False negatives cause spurious failures of my kvm-unit-test
for extint loops[1] under PV.

Since code 20 is only caused under PV if and only if the guest's
ext_new_psw is enabled for external interrupts, false positive detection
of a external interruption loop can not happen.

Fix this issue by instead looking at the guest PSW in the state
description. Since the PSW swap for external interrupt is done by the
ultravisor before the intercept is caused, this reliably tells whether
the guest is enabled for external interrupts in the ext_new_psw.

Also update the comments to explain better what is happening.

[1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")
Link: https://lore.kernel.org/r/20230213085520.100756-2-nrb@linux.ibm.com
Message-Id: <20230213085520.100756-2-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/intercept.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 77909d362b78f..5be68190901f9 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -270,10 +270,18 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 /**
  * handle_external_interrupt - used for external interruption interceptions
  *
- * This interception only occurs if the CPUSTAT_EXT_INT bit was set, or if
- * the new PSW does not have external interrupts disabled. In the first case,
- * we've got to deliver the interrupt manually, and in the second case, we
- * drop to userspace to handle the situation there.
+ * This interception occurs if:
+ * - the CPUSTAT_EXT_INT bit was already set when the external interrupt
+ *   occurred. In this case, the interrupt needs to be injected manually to
+ *   preserve interrupt priority.
+ * - the external new PSW has external interrupts enabled, which will cause an
+ *   interruption loop. We drop to userspace in this case.
+ *
+ * The latter case can be detected by inspecting the external mask bit in the
+ * external new psw.
+ *
+ * Under PV, only the latter case can occur, since interrupt priorities are
+ * handled in the ultravisor.
  */
 static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 {
@@ -284,10 +292,18 @@ static int handle_external_interrupt(struct kvm_vcpu *vcpu)
 
 	vcpu->stat.exit_external_interrupt++;
 
-	rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
-	if (rc)
-		return rc;
-	/* We can not handle clock comparator or timer interrupt with bad PSW */
+	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
+		newpsw = vcpu->arch.sie_block->gpsw;
+	} else {
+		rc = read_guest_lc(vcpu, __LC_EXT_NEW_PSW, &newpsw, sizeof(psw_t));
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * Clock comparator or timer interrupt with external interrupt enabled
+	 * will cause interrupt loop. Drop to userspace.
+	 */
 	if ((eic == EXT_IRQ_CLK_COMP || eic == EXT_IRQ_CPU_TIMER) &&
 	    (newpsw.mask & PSW_MASK_EXT))
 		return -EOPNOTSUPP;
-- 
2.39.2



