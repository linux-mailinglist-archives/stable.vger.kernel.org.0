Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96219594CD5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiHPA7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbiHPA5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:57:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7AF19F4A0;
        Mon, 15 Aug 2022 13:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88A03B8114A;
        Mon, 15 Aug 2022 20:48:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE34C433C1;
        Mon, 15 Aug 2022 20:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596516;
        bh=MNbRGbvKx0Fc3/CMG/a0YCGf2f9m+V0seGwzfqfY6lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eo8ad7eeuSTefL7kaQBld7takvdyk3sOUM/vCGt7vr4Zy3jOkq7whOZSsfDHP/xHz
         JXtxCC2g5pYFET/7a83xcrUgs8dEtZLZW5WImr7nbVuLCFif0nTz18O9brVvU+bWoL
         wQyzyJRvVUYIsnBnSQrOl4VWTdck69QtfwkQ0Z7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1104/1157] KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesnt support global_ctrl
Date:   Mon, 15 Aug 2022 20:07:40 +0200
Message-Id: <20220815180524.429254962@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit 98defd2e17803263f49548fea930cfc974d505aa ]

MSR_CORE_PERF_GLOBAL_CTRL is introduced as part of Architecture PMU V2,
as indicated by Intel SDM 19.2.2 and the intel_is_valid_msr() function.

So in the absence of global_ctrl support, all PMCs are enabled as AMD does.

Signed-off-by: Like Xu <likexu@tencent.com>
Message-Id: <20220509102204.62389-1-likexu@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/pmu_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2696b16f9283..8faac421171f 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -98,6 +98,9 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
+	if (pmu->version < 2)
+		return true;
+
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
-- 
2.35.1



