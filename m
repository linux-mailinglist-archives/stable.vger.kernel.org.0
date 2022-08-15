Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76F7593AFC
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345790AbiHOUAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241858AbiHOT7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:59:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A317796B5;
        Mon, 15 Aug 2022 11:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 716D9B810A6;
        Mon, 15 Aug 2022 18:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AD9C433C1;
        Mon, 15 Aug 2022 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589588;
        bh=WFP8opjL5wR21vO6sG4t40QfsjTNuVfWGHPP07Rlybo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtzVKsv/EIu50ovEQn3dS1UPbheZ2qYSZeHhJGWbv9NFg70W5hWRsTVgf874cVeee
         uxQylTKNmtR6P2Hihvo72DzgeqnbfTu9Lwn71aSO6xH37PpL1f+5YCRu66sXvsNsUH
         vgbtuHjBL5XIoc0wgAeoFoFogepf56MGBPSWsKX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 734/779] KVM: x86/pmu: Ignore pmu->global_ctrl check if vPMU doesnt support global_ctrl
Date:   Mon, 15 Aug 2022 20:06:18 +0200
Message-Id: <20220815180408.824384578@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index c66edf93e4a8..f9054e7ec89e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -104,6 +104,9 @@ static bool intel_pmc_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
+	if (pmu->version < 2)
+		return true;
+
 	return test_bit(pmc->idx, (unsigned long *)&pmu->global_ctrl);
 }
 
-- 
2.35.1



