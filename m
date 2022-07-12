Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E785722CC
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiGLSkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGLSkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE67BFAD8;
        Tue, 12 Jul 2022 11:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E17BAB81BAC;
        Tue, 12 Jul 2022 18:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8EDC341C8;
        Tue, 12 Jul 2022 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651215;
        bh=94KCIESH3xJDnFEmSbONd5NtuihgFvmDI4tfqbS1O0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxeDhCXHE6HSC/Ol1KBGDKJvIGYqeXC+oy1BonNa2BOlv8s9EW8GnLge1rhYLG+PQ
         OJlje4Ka22IySCiYycYZPzhs6z7vq4hVk+JYDAWnVoQPsXdaLWLKj0CJq5m+dSJ2KL
         7wxZm1jl6gCfRbE/DSp5P9hVKqFXcW7+uNcLtWTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 001/130] KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S
Date:   Tue, 12 Jul 2022 20:37:27 +0200
Message-Id: <20220712183246.461863210@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

commit 6c44221b05236cc65d76cb5dc2463f738edff39d upstream.

Saves one byte in __vmx_vcpu_run for the same functionality.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Message-Id: <20201029140457.126965-1-ubizjak@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmenter.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -132,7 +132,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	cmpb $0, %bl
+	testb %bl, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX


