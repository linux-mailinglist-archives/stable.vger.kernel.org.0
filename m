Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300D4171FDC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgB0NzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731967AbgB0NzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 119A72469B;
        Thu, 27 Feb 2020 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811719;
        bh=zGuNwgBkEi5yvKSF45AMZe+eW5wo5oCZKqvBCQSxQBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0/XHrQ84oQB0LsqSZb44c++4i3nGjU5vHzXNum+Kxpn3YXISrl0DGcysongfiti1
         j2dADA4evjLVx5xXLwy/4i7L8iswSWHVmVMI4JGT5bhuRBXlowjdGJ6NS3Cf0F0VUa
         BbGXsR4Fywq+DnFquHsSu2BJfEPLkDE8Kt55ivkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/237] Revert "KVM: nVMX: Use correct root level for nested EPT shadow page tables"
Date:   Thu, 27 Feb 2020 14:34:10 +0100
Message-Id: <20200227132259.367739216@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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



