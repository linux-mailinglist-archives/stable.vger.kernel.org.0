Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FC36214D4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiKHOFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbiKHOFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A207C69DF0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C0A1B81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45C4C433D6;
        Tue,  8 Nov 2022 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916328;
        bh=Kr0ry15g4+LRr42FnUWwIR4u5Ozo3si+c0Mdg4HKY5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdAL7Vo2doUEia0OCH1nkxMEmwuvK71BHMFBhBfAUFo4DArmXfFf2CXPHbrFd3kFl
         F6xKna3hzvrJ9LkRWUE4ctIYGbFlknDbleCQdt19irKuFWyZaVG/PT0FqKb5hhsJMN
         GtDAs4P24tYkw/7WNWdEqMc66PM5NBpjc5cbwIgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 130/144] KVM: x86: Mask off reserved bits in CPUID.8000001FH
Date:   Tue,  8 Nov 2022 14:40:07 +0100
Message-Id: <20221108133350.769413970@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
@@ -968,7 +968,8 @@ static inline int __do_cpuid_func(struct
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		} else {
 			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
-
+			/* Clear NumVMPL since KVM does not support VMPL.  */
+			entry->ebx &= ~GENMASK(31, 12);
 			/*
 			 * Enumerate '0' for "PA bits reduction", the adjusted
 			 * MAXPHYADDR is enumerated directly (see 0x80000008).


