Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5FB615B863
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgBMEPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:15:06 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37997 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729443AbgBMEPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:15:06 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 996FF22056;
        Wed, 12 Feb 2020 23:15:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=s7HJOZ
        V9xE+MJcxeyz/aORLgMuUPo+jppjbndy+F1r4=; b=MhM1unObOqkQh3hv9+8YkY
        dMtv+wDoW++K/e32IgzVmvoLtEeYF+h20AsW5iIk1aYTtYwIItk/Q7gowQ1e1Ylk
        oRdAzhUTmdGgkS1ss1yQomAoEUvbyys/1Qf8ZH69jsobQf4dQccZXuOxPWFoRxwu
        OtwBpy4LhaywiRI87FWxz+naFqRsJte0nmCMzuoyIy+309QOlKtGnaVfUvjNdD2U
        Dp9klT+P1EX54aAxmYvGQ/JdEkZUAWVXOmy7P/x6W9G1Z6YRFWBHNPfj+nQAY6zO
        gvr5XuNhnWyEbYvKrHjPgAOY+M/UCBCRl2MnfgybPRL+BeWAUrqa/MeuwUiJ9sIw
        ==
X-ME-Sender: <xms:Sc1EXpg4utJXSIaOapL6U5sgaOdvLc-WZU1gSUWdG2Nd5dy2RwS2Ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvtdelrdefjedrleejrd
    duleegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Sc1EXjSyQRM7n2atCVTn3Jfd-eYfYT3JD0QO-GoMEX42VMXQ4MM5YA>
    <xmx:Sc1EXqw3l3E2t3d2Aschp8pYoQ_7K83DDwSubz_cEscXHa7VG4BXvw>
    <xmx:Sc1EXmcyQOg15fTKiHIBS67c9pEPKKlHfy5iUxPToFerzGUY3KX1uA>
    <xmx:Sc1EXtsH2eb3gf2nBeqWpQavnDeUo7IhczB8EhA824SMcPwtsphNAQ>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id 308533280059;
        Wed, 12 Feb 2020 23:15:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset" failed to apply to 4.14-stable tree
To:     eric.auger@redhat.com, andrew.murray@arm.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:15:04 -0800
Message-ID: <1581567304238176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3837407c1aa1101ed5e214c7d6041e7a23335c6e Mon Sep 17 00:00:00 2001
From: Eric Auger <eric.auger@redhat.com>
Date: Fri, 24 Jan 2020 15:25:32 +0100
Subject: [PATCH] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset

The specification says PMSWINC increments PMEVCNTR<n>_EL1 by 1
if PMEVCNTR<n>_EL0 is enabled and configured to count SW_INCR.

For PMEVCNTR<n>_EL0 to be enabled, we need both PMCNTENSET to
be set for the corresponding event counter but we also need
the PMCR.E bit to be set.

Fixes: 7a0adc7064b8 ("arm64: KVM: Add access handler for PMSWINC register")
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200124142535.29386-2-eric.auger@redhat.com

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 8731dfeced8b..c3f8b059881e 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -486,6 +486,9 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	if (val == 0)
 		return;
 
+	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+		return;
+
 	enable = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++) {
 		if (!(val & BIT(i)))

