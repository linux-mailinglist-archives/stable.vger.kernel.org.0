Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB056215E6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235294AbiKHOQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbiKHOQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECFB7055C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D499615A9
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517CFC433D6;
        Tue,  8 Nov 2022 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916995;
        bh=JHysnQnq3LdFTi8oBOOWP/GCSqogaDRalNMpwplJbuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYHZmhQ1F2ytGG/KLPFuRVoYRIiDFnwexiELgjz/bDw+22ii5G2G6n2z7zIMC69p5
         VyF94cq+pLamOfePd6wL2jRrrUS8saDjuWONsYuEgK0Voa9mrIyUEEWuCKvjuY9IYJ
         y+4AGtoTbFMzi3R9Dr5HDmv2H2zos4EmON5Q3MrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 184/197] KVM: x86: emulator: em_sysexit should update ctxt->mode
Date:   Tue,  8 Nov 2022 14:40:22 +0100
Message-Id: <20221108133403.267616953@linuxfoundation.org>
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

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 5015bb89b58225f97df6ac44383e7e8c8662c8c9 upstream.

SYSEXIT is one of the instructions that can change the
processor mode, thus ctxt->mode should be updated after it.

Note that this is likely a benign bug, because the only problematic
mode change is from 32 bit to 64 bit which can lead to truncation of RIP,
and it is not possible to do with sysexit,
since sysexit running in 32 bit mode will be limited to 32 bit version.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221025124741.228045-11-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2874,6 +2874,7 @@ static int em_sysexit(struct x86_emulate
 	ops->set_segment(ctxt, ss_sel, &ss, 0, VCPU_SREG_SS);
 
 	ctxt->_eip = rdx;
+	ctxt->mode = usermode;
 	*reg_write(ctxt, VCPU_REGS_RSP) = rcx;
 
 	return X86EMUL_CONTINUE;


