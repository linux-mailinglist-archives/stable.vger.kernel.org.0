Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A54E15978
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfEGFhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728215AbfEGFhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E7A214AE;
        Tue,  7 May 2019 05:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207421;
        bh=7/mtC7Ba7ycSvP1hl8RMihDYeDNslaXhlLtrjI31ik0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL6aIWi2Ky7gcmqXbycJKpRHlYbLRiwU/wlWPR/Bh632R74u7HNN9a+TWBIQ+GE9T
         QUBHmNcMdkH/OFmoh5Z1beddLGxz170XPokmyR6/93crs6zsz4KgNjwGVGbLKtoBTQ
         al1/FMJUl/3T+BlD7lFRo5TGcSGOXRan2T/Cs/KE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 33/81] KVM: x86: Raise #GP when guest vCPU do not support PMU
Date:   Tue,  7 May 2019 01:35:04 -0400
Message-Id: <20190507053554.30848-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

[ Upstream commit 672ff6cff80ca43bf3258410d2b887036969df5f ]

Before this change, reading a VMware pseduo PMC will succeed even when
PMU is not supported by guest. This can easily be seen by running
kvm-unit-test vmware_backdoors with "-cpu host,-pmu" option.

Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/pmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 58ead7db71a3..e39741997893 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -281,9 +281,13 @@ static int kvm_pmu_rdpmc_vmware(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
 {
 	bool fast_mode = idx & (1u << 31);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
 	u64 ctr_val;
 
+	if (!pmu->version)
+		return 1;
+
 	if (is_vmware_backdoor_pmc(idx))
 		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
 
-- 
2.20.1

