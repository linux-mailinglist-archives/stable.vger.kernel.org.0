Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2D3472ECF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhLMOU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238991AbhLMOUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579D8C061748;
        Mon, 13 Dec 2021 06:20:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7B3B6111A;
        Mon, 13 Dec 2021 14:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667D3C34602;
        Mon, 13 Dec 2021 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405224;
        bh=SZf/fyvo6x7HzqcTmLZPoTzAFtGreyN0CA800IADxMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmv0fXmhSYSQ+rPsSNkxd42dVurhv3M+UDrxxYYfb1uWZX89NcisW7YZwq+x7ealf
         MRoDcYkq1DK9+ExNQWXIUM4GGRz44NdHKl7yHUw+l53LgDASGWH/jjuKfoEj+fAV7C
         A4rcY+J0Cg+1Qh9y/1wlpbycBEcvEVYrbm0miNVFbpRJyP/lL/ES+MzKpdNfU5wCMn
         BO+yq8foCksoiN+FjhZG0QYu6Lk7z0LWVEM3QGXSrCSb2GFvSS7bPXYtAol78u3fYw
         RSyux75bnUq5IEaAPW/6rmtUdXLruaWd+6tNyFj80Vx8tROZYFtOfKK62rJfJ8JlCp
         A6ASTBjCenlAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 2/4] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Date:   Mon, 13 Dec 2021 09:20:16 -0500
Message-Id: <20211213142020.352376-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213142020.352376-1-sashal@kernel.org>
References: <20211213142020.352376-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit e90e51d5f01d2baae5dcce280866bbb96816e978 ]

There is nothing to synchronize if APICv is disabled, since neither
other vCPUs nor assigned devices can set PIR.ON.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5b7664d51dc2b..dff8ab5a53280 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7814,10 +7814,10 @@ static __init int hardware_setup(void)
 		ple_window_shrink = 0;
 	}
 
-	if (!cpu_has_vmx_apicv()) {
+	if (!cpu_has_vmx_apicv())
 		enable_apicv = 0;
+	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
-	}
 
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
-- 
2.33.0

