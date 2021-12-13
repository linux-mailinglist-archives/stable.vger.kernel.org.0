Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EBF472EB7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238859AbhLMOUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:20:07 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34902 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238827AbhLMOUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:20:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9322B8106E;
        Mon, 13 Dec 2021 14:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0D8C3460C;
        Mon, 13 Dec 2021 14:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405201;
        bh=uvDO1gO3GWnwgec+4b41HamvBhDgDRLnqSjArncZ2sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aH09V1En4XEaEhBqTc+E4U3C6zY2Aw8NXIl9gaQnxS3Q0U12aQRnFFdrayaWSgmX3
         gUGfxsa8k+sbWdO73ESIYZ0hCe6XvyH/4w3Obp+g5DxENUt3M299NbCz08R68SXFUZ
         dvlhdZrF1LaUwkhKkY/Hj+wM8ZBygTzjw225IXZCU8axThSdVkxKCwYYM2CJOC7Mce
         qUhaTOVVQSsADORb0f59YlWGy84R3+PB1Tyt/pHkikRI5TCYhPkuYdvltk6BglIn/4
         CZq++cLkIKDEDMp3i9hJDk/jjw0/qHUsaEDEBsHoONvTUFt7pe3biFXpQwRiW/QqIs
         z8U8kPaqwpz6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 3/9] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Date:   Mon, 13 Dec 2021 09:19:36 -0500
Message-Id: <20211213141944.352249-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213141944.352249-1-sashal@kernel.org>
References: <20211213141944.352249-1-sashal@kernel.org>
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
index dacdf2395f01a..4e212f04268bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7776,10 +7776,10 @@ static __init int hardware_setup(void)
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

