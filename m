Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0906215CB
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiKHOPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiKHOPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1807759847
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7BF6615C2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E6DC433D6;
        Tue,  8 Nov 2022 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916922;
        bh=fVsO/CKFQlYxd9SRTzt4NN7uLePA+BJxKjUyldhDinQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2fu5QwOigkEZ03BDalFePLY+lJBDV8VxRYCLwmoBbPjbGxkV3FgZAVA6n0xldxl0k
         V0DD0IUBInS1g6UvA1bbXrRPvlCqhvzrY7YeWHw7SAOKMq0Cu54DI2XBufDSlU5nDr
         Y9vfd1P6tRPja6QDUZLGD7sL6B/8VYAeSlSpvoQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 174/197] KVM: x86: Mask off reserved bits in CPUID.8000001FH
Date:   Tue,  8 Nov 2022 14:40:12 +0100
Message-Id: <20221108133402.832992575@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

commit 86c4f0d547f6460d0426ebb3ba0614f1134b8cda upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.8000001FH:EBX[31:16] are reserved bits and
should be masked off.

Fixes: 8765d75329a3 ("KVM: X86: Extend CPUID range to include new leaf")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-6-jmattson@google.com>
Cc: stable@vger.kernel.org
[Clear NumVMPL too. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1183,7 +1183,8 @@ static inline int __do_cpuid_func(struct
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		} else {
 			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
-
+			/* Clear NumVMPL since KVM does not support VMPL.  */
+			entry->ebx &= ~GENMASK(31, 12);
 			/*
 			 * Enumerate '0' for "PA bits reduction", the adjusted
 			 * MAXPHYADDR is enumerated directly (see 0x80000008).


