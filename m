Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB657AC11
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbiGTBQN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241116AbiGTBPr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:15:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657D46A9C4;
        Tue, 19 Jul 2022 18:13:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B2056172E;
        Wed, 20 Jul 2022 01:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A31C385A2;
        Wed, 20 Jul 2022 01:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279626;
        bh=BFRNXG82zN5fDX4BiXByhaveTpDwgz8NI7Uuk60vbTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pg4JukBxTzY7dQg1MOOaRoZTseD4j504durBivbRY9MXqxxxLGZWzEx9qhmtPZhAg
         Fd7kZ4uhc3l+GYEEffsNUH5J6YyQnTVii6Yu6ZR3Joq5BYZZf3TxV7VW/43l2RijS3
         iijzQXXZ2c8vNwfy2tx42XQ0u+XdDCU6B5vBwhFFGfbq1TSVb61Run/srzWI9V+Yuo
         xwhNgNonLqBVXAXF2pk5JQTzVwG9eYWnHK9xC7RAW0r9c/6wZ4l3x4FwNMurpBnOfI
         8rssmsPUiTgY0XJYof1njWlFy2GnW2KHVPVXE4JJm6doDQ29A8eB9j0NgCN2XCkWhy
         g4xZTZ7/dJqCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 53/54] KVM: nVMX: Always enable TSC scaling for L2 when it was enabled for L1
Date:   Tue, 19 Jul 2022 21:10:30 -0400
Message-Id: <20220720011031.1023305-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 99482726452bdf8be9325199022b17fa6d7d58fe ]

Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
hang upon boot or shortly after when a non-default TSC frequency was
set for L1. The issue is observed on a host where TSC scaling is
supported. The problem appears to be that Windows doesn't use TSC
frequency for its guests even when the feature is advertised and KVM
filters SECONDARY_EXEC_TSC_SCALING out when creating L2 controls from
L1's. This leads to L2 running with the default frequency (matching
host's) while L1 is running with an altered one.

Keep SECONDARY_EXEC_TSC_SCALING in secondary exec controls for L2 when
it was set for L1. TSC_MULTIPLIER is already correctly computed and
written by prepare_vmcs02().

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20220712135009.952805-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 28ccf25c4124..223de8e0dd5f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2279,7 +2279,6 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				  SECONDARY_EXEC_ENABLE_VMFUNC |
-				  SECONDARY_EXEC_TSC_SCALING |
 				  SECONDARY_EXEC_DESC);
 
 		if (nested_cpu_has(vmcs12,
-- 
2.35.1

