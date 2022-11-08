Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5015B6214D2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiKHOF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbiKHOFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA07B69DDF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 479C56152D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534A3C433D6;
        Tue,  8 Nov 2022 14:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916320;
        bh=eokMzurQobSd5yycrtbLa1aYYDumYAyYLlHYvxwyaB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqlgnB72d2/BZ1ZZZ2r4y8t3a5tcT9dM6HTOOb3S6sLe03BXn5sjFFbAjC5GoI6bV
         hkir+h4cmSodjGsLUjdP4OGQrY22sbZiR/sNZmGwBjKRyFeZ2uMjV/bjZn8fLnlmum
         omHYnY4YPds9g8zPoVnXEP0YJK4EnBqvX7BeEBrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 128/144] KVM: x86: Mask off reserved bits in CPUID.80000008H
Date:   Tue,  8 Nov 2022 14:40:05 +0100
Message-Id: <20221108133350.674130988@linuxfoundation.org>
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

commit 7030d8530e533844e2f4b0e7476498afcd324634 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. The following ranges of CPUID.80000008H are reserved
and should be masked off:
    ECX[31:18]
    ECX[11:8]

In addition, the PerfTscSize field at ECX[17:16] should also be zero
because KVM does not set the PERFTSC bit at CPUID.80000001H.ECX[27].

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-3-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -937,6 +937,7 @@ static inline int __do_cpuid_func(struct
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
+		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
 		break;


