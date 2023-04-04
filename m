Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734166D5D8A
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 12:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbjDDKbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 06:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbjDDKba (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 06:31:30 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C66D19A6
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 03:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1680604289; x=1712140289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZpKuVv6XZH9IkEN7mzm3MxN+ijsWERa5Nxv3VbPzKD8=;
  b=cOSWpIjXa3i93AuoBzmTsR2x1hjgGoAL0GjTixqdKIKgHqu5VLsE95Vm
   Z/9JilEWcQ/ab2mA3bZxt4A84HD+Y6Bf12C0O1W1AlUkEh2BMt7OM6MOC
   7htTMc1pSuiPsUlVORose3XQVbQSXlP7m1MnYaGaduowetfw6HzgtiL9+
   w=;
X-IronPort-AV: E=Sophos;i="5.98,317,1673913600"; 
   d="scan'208";a="1119289659"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:31:22 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-b538c141.us-east-1.amazon.com (Postfix) with ESMTPS id 8F61CA3BC8;
        Tue,  4 Apr 2023 10:31:19 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 4 Apr 2023 10:31:18 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.136.176) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 4 Apr 2023 10:31:13 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        "Takahiro Itazuri" <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH v3 stable 4.14 4.19 3/3] arm64: KVM: Fix system register enumeration
Date:   Tue, 4 Apr 2023 11:30:50 +0100
Message-ID: <20230404103050.27202-4-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230404103050.27202-1-itazur@amazon.com>
References: <20230404103050.27202-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.136.176]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-8.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

[ Upstream commit 5d8d4af24460d079ecdb190254b14b528add1228 ]

The introduction of the SVE registers to userspace started with a
refactoring of the way we expose any register via the ONE_REG
interface.

Unfortunately, this change doesn't exactly behave as expected
if the number of registers is non-zero and consider everything
to be an error. The visible result is that QEMU barfs very early
when creating vcpus.

Make sure we only exit early in case there is an actual error, rather
than a positive number of registers...

Fixes: be25bbb392fa ("KVM: arm64: Factor out core register ID enumeration")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/arm64/kvm/guest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 6835ddf598a7..8ae0f408b89c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -326,17 +326,17 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	int ret;
 
 	ret = kvm_arm_copy_core_reg_indices(uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += ret;
 
 	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += kvm_arm_get_fw_num_regs(vcpu);
 
 	ret = copy_timer_indices(vcpu, uindices);
-	if (ret)
+	if (ret < 0)
 		return ret;
 	uindices += NUM_TIMER_REGS;
 
-- 
2.39.2

