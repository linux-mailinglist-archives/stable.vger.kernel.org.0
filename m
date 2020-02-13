Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A015B864
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 05:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbgBMEPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 23:15:15 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59507 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729443AbgBMEPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Feb 2020 23:15:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DE28721FB7;
        Wed, 12 Feb 2020 23:15:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 12 Feb 2020 23:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bXRCip
        Yss9iUDD6XPIJRxcfr7mw43KclxBsCJFLCRs8=; b=Z8guLXSSfYF2I0w54c5jw2
        8su6ooqa7qJarBCy0YDW1XX5vA91MGCG6sWYcqMb1IS/VGynY/NMIsxTqLKqHd1A
        HYgiu7jdH/0XOnPRPw2dVDtyWT+gSpuPNDG9MLQEsQHcp7F9GpKYqxDP2MFLpNj5
        Xlj6GdkM55g+aM2Ijh6IgpXOtso9gQcgRfXm5PbEj9Zef8tr/q63r0iFmBFwwbKG
        A8cxRTTzZPfFBXd6teJiieKU77rBX972bS1bt/vHUegQhmy7Mb+9yN1FIndbLYSr
        i4dq+Wqs7sZBStUnk/8AIF4hl/YqU9Pkp1S5CX6q+s1V/hQtjHGnDY+QIp/BPUUg
        ==
X-ME-Sender: <xms:Uc1EXkzN8gwN6_VflT4KidxgBnWGzIUFdyDQQ8yoV2UOoZyQfHeLqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieejgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppedvtdelrdefjedrleejrd
    duleegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Uc1EXg71MclhEVqGvjTjHlT-qZDP-XJX_Kr556qJaNkZrTl4cKmvZg>
    <xmx:Uc1EXty9PJBaEth9G4aZu-B_d_UNHm905u7z-1AAI5-G8vJwBAowIQ>
    <xmx:Uc1EXseZC5tGugOYnTUjwQ8ffSu3YWGtvws6SVpsazlnj4utf04mOw>
    <xmx:Uc1EXhL-YkymMC996oHA0YWh9xtk0INsThZ-KK27rR_reh-YoItbBg>
Received: from localhost (unknown [209.37.97.194])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9CD823060A88;
        Wed, 12 Feb 2020 23:15:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: arm64: pmu: Don't increment SW_INCR if PMCR.E is unset" failed to apply to 4.9-stable tree
To:     eric.auger@redhat.com, andrew.murray@arm.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 Feb 2020 20:15:04 -0800
Message-ID: <1581567304216184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

