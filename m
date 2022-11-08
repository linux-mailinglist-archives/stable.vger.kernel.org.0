Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD426214D1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbiKHOFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235032AbiKHOFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3949686AA
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:05:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80E966152D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B92C433D6;
        Tue,  8 Nov 2022 14:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916317;
        bh=AGluLAOLOa/TlrmykXTYI8b4jMiuMMRIVkU9V1X1+TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuLT1JIKHYK7pKGBqfDM0oA/jX66l4UWydUkLCKpwKv1qhmkPc24zwRfcvlmVNaP2
         EfQr6sKEVu16El7olR4xjxbb/mUf+ixod/QvkSXEQ4zgHR43NyweJgEYYuc7f576Gh
         D+zSQXwpceb+aVagyTTTLTaAUYLeBJnpchYd4+WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 127/144] KVM: x86: Mask off reserved bits in CPUID.8000001AH
Date:   Tue,  8 Nov 2022 14:40:04 +0100
Message-Id: <20221108133350.643104217@linuxfoundation.org>
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

commit 079f6889818dd07903fb36c252532ab47ebb6d48 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. In the case of CPUID.8000001AH, only three bits are
currently defined. The 125 reserved bits should be masked off.

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-4-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -956,6 +956,9 @@ static inline int __do_cpuid_func(struct
 		entry->ecx = entry->edx = 0;
 		break;
 	case 0x8000001a:
+		entry->eax &= GENMASK(2, 0);
+		entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x8000001e:
 		break;
 	case 0x8000001F:


