Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38272167596
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbgBUI3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:29:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387586AbgBUIQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:16:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15BF724670;
        Fri, 21 Feb 2020 08:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273012;
        bh=zGuNwgBkEi5yvKSF45AMZe+eW5wo5oCZKqvBCQSxQBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoqzsGISfR885ylQbmYBTa2uOi+dJ7w6VMqwRxrLjREoRnYpuVl24uwyWTohx85g7
         s10l67CCOF27oB99voK1lKopxMWnIzWnsUn599NrpdNqfWHdrySVLiaiyXL9XY8j+y
         uaNzEI7zg980AWoFdztRTzpFRSd377z9SmuMaEt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/191] Revert "KVM: nVMX: Use correct root level for nested EPT shadow page tables"
Date:   Fri, 21 Feb 2020 08:39:40 +0100
Message-Id: <20200221072251.830134783@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 740d876bd9565857a695ce7c05efda4eba5bc585.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 997926a9121c0..3791ce8d269e0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2968,9 +2968,6 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static int get_ept_level(struct kvm_vcpu *vcpu)
 {
-	/* Nested EPT currently only supports 4-level walks. */
-	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
-		return 4;
 	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;
-- 
2.20.1



