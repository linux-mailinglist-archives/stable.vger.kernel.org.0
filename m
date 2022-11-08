Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9D5F6215CA
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbiKHOPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbiKHOPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:15:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0AA59847
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:15:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0868C6157D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BC1C433C1;
        Tue,  8 Nov 2022 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916919;
        bh=uPNS/ScmtwKXSZKJHzwLxBgXVWobJzLLJ7P26XKec/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBRHY1elV7mXqgcDWVrRN7SmjWaSKHzqLyKOloXk3mC2XQ9B/LwtNm0W5qhsk0uWr
         tFi9ibMO+EnFGapprq+KqXFBLtmACnUAYqBUFGW0LQ84JCh2pzjYsHpn5LbhAcLbRy
         1tVjmwuH2pPH2h1+hf9nObdmb63scTAJJoLHo1Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 173/197] KVM: x86: Mask off reserved bits in CPUID.80000001H
Date:   Tue,  8 Nov 2022 14:40:11 +0100
Message-Id: <20221108133402.794821872@linuxfoundation.org>
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

commit 0469e56a14bf8cfb80507e51b7aeec0332cdbc13 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.80000001:EBX[27:16] are reserved bits and
should be masked off.

Fixes: 0771671749b5 ("KVM: Enhance guest cpuid management")
Signed-off-by: Jim Mattson <jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1117,6 +1117,7 @@ static inline int __do_cpuid_func(struct
 			entry->eax = max(entry->eax, 0x80000021);
 		break;
 	case 0x80000001:
+		entry->ebx &= ~GENMASK(27, 16);
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;


