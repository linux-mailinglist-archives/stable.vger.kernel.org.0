Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D83D5F30E5
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 15:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiJCNNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 09:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiJCNMv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 09:12:51 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E751411;
        Mon,  3 Oct 2022 06:12:40 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.174.77])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 303B242FB9;
        Mon,  3 Oct 2022 13:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1664802741;
        bh=vwlx1gbaZBmlCPWYfdDYGkITCw7MAKaMg2lBA+aHgD4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=R3R0oL01hIhfMR0qtm0I6v9vhEBKrPIqKQltJ20ZX2wbFWKWDpt04H7EkJGtHrz+D
         J9QsMnwx79bp1u1IqGJij+SOcj/1qACZeZ+rlieNb69jstv29SCPmG4Nt4udxgIQ1+
         4W3RH8cJIL5ginmoZw0Hhhixc9ugEgFnTr3baAhUf/iGVMQywED+w8mqxlJWeyQJ1a
         3EGK1FBgFcjlnP0EIhNYQG3QSg6GCwcZfg5Y1SVSppH6Mc9XJb9mAPWpXoO6oCTVcT
         m33dHF5ZPSaIBBcXisVfFiCQczSiYOQgudDeaA6bJs4/h0KeZAI8GuYFdUXzGeA/z9
         HjBJ0a6Kry5BQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org
Subject: [PATCH 5.4 24/37] KVM/VMX: Use TEST %REG,%REG instead of CMP $0,%REG in vmenter.S
Date:   Mon,  3 Oct 2022 10:10:25 -0300
Message-Id: <20221003131038.12645-25-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221003131038.12645-1-cascardo@canonical.com>
References: <20221003131038.12645-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 arch/x86/kvm/vmx/vmenter.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index ca4252f81bf8..63cd7fbab0ac 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -135,7 +135,7 @@ ENTRY(__vmx_vcpu_run)
 	mov (%_ASM_SP), %_ASM_AX
 
 	/* Check if vmlaunch or vmresume is needed */
-	cmpb $0, %bl
+	testb %bl, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
-- 
2.34.1

