Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A9D6214D3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiKHOFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiKHOF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6BA69DCE
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC1BBB81ADD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B05C433D6;
        Tue,  8 Nov 2022 14:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916324;
        bh=OIBxIDoZ41ZyfKZ6TNNevZ1WjvyfZQuan+qyoQgmWrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CW2iC+UqaDv2+STUSk2sWOTM6xpukylA/yLbXaRso9MQf+WI4Bqtd9yYt+OOKOpom
         I33u5Oa7553coVuWv+LYkg9ApB9OGpRRbDKR3kLknAmL8rxg3HNyG7N5adoEgL32JD
         Bh9PBgD1QhVIZmlOmWZ5fByC+BUqeCvRWzAIH6c0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 129/144] KVM: x86: Mask off reserved bits in CPUID.80000001H
Date:   Tue,  8 Nov 2022 14:40:06 +0100
Message-Id: <20221108133350.721128425@linuxfoundation.org>
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
@@ -902,6 +902,7 @@ static inline int __do_cpuid_func(struct
 		entry->eax = min(entry->eax, 0x8000001f);
 		break;
 	case 0x80000001:
+		entry->ebx &= ~GENMASK(27, 16);
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;


