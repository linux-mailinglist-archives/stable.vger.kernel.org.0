Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD06536C8A
	for <lists+stable@lfdr.de>; Sat, 28 May 2022 13:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiE1Lik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 May 2022 07:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234701AbiE1Lij (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 May 2022 07:38:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A113167DF;
        Sat, 28 May 2022 04:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9851F60E75;
        Sat, 28 May 2022 11:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA91DC34119;
        Sat, 28 May 2022 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653737916;
        bh=kXKKxImpCbgciZyHH2R0XiBp9gJjnAYWLI6di9ntV/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXgOJbDRgow1757V/kGoLloDZOE3YnSoqmMghd58TUaRRKKKq8Y6mcQvZpYIo/TMu
         VWyTUdRjERQGnXN7k5Dzlb5V6+Q4JZjP8nK58tXM/0zmLAE3dCMtZO3QIpw9miCBCg
         XMP3uP2EFAfe/i0jEgKPM56fiK+PQWEGWhwqWQmN+GTT/UIaUObtBeASFZ7t1xzt47
         9DLeXmlkeNa/8Ktreckd8glfiMq/499RCISZcVAYwui9u5zYL5M6cNkqHCf3tWxC2t
         SY0uyHsScfRFGxktZHQf/6m1TnP7+uuvi/kWKpTjQN0Spw7bztH/WYNZIlUSQZN/9t
         5Sto92NSm1avA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nuum9-00EEGh-KR; Sat, 28 May 2022 12:38:33 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH 01/18] KVM: arm64: Always start with clearing SVE flag on load
Date:   Sat, 28 May 2022 12:38:11 +0100
Message-Id: <20220528113829.1043361-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com, will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On each vcpu load, we set the KVM_ARM64_HOST_SVE_ENABLED
flag if SVE is enabled for EL0 on the host. This is used to restore
the correct state on vpcu put.

However, it appears that nothing ever clears this flag. Once
set, it will stick until the vcpu is destroyed, which has the
potential to spuriously enable SVE for userspace.

We probably never saw the issue because no VMM uses SVE, but
that's still pretty bad. Unconditionally clearing the flag
on vcpu load addresses the issue.

Fixes: 8383741ab2e7 ("KVM: arm64: Get rid of host SVE tracking/saving")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/fpsimd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 441edb9c398c..3c2cfc3adc51 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -80,6 +80,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	vcpu->arch.flags &= ~KVM_ARM64_FP_ENABLED;
 	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
 
+	vcpu->arch.flags &= ~KVM_ARM64_HOST_SVE_ENABLED;
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
 
-- 
2.34.1

