Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A57D60ABD1
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiJXN5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiJXN52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:57:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9E754181;
        Mon, 24 Oct 2022 05:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77339612A4;
        Mon, 24 Oct 2022 12:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A3CC433C1;
        Mon, 24 Oct 2022 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614013;
        bh=AEDN9xuNlbHo/e5IAl0M+CHnwhGvTQQAttrpcw65NuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0UWxV8Cx6I5E2mMOj1nPEBHZS69QDf14bAs0kiDv9BtP3o95wDNRI6EKpTOlQ/uV
         qwXRzY34eyiN7ZEQdNBRRc+wNN4i3TDma6c9aHRRh/9ec9jJVHcKxt1J3k9GvrTp4Q
         hIDWmuHEAC+4RqNfXH8HFu5JqLWUXPp1x/kJIlsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 082/390] KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility
Date:   Mon, 24 Oct 2022 13:27:59 +0200
Message-Id: <20221024113026.102951946@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

commit 6aa5c47c351b22c21205c87977c84809cd015fcf upstream.

The emulator checks the wrong variable while setting the CPU
interruptibility state, the target segment is embedded in the instruction
opcode, not the ModR/M register.  Fix the condition.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Fixes: a5457e7bcf9a ("KVM: emulate: POP SS triggers a MOV SS shadow too")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20220821215900.1419215-1-mhal@rbox.co
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2039,7 +2039,7 @@ static int em_pop_sreg(struct x86_emulat
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (ctxt->modrm_reg == VCPU_SREG_SS)
+	if (seg == VCPU_SREG_SS)
 		ctxt->interruptibility = KVM_X86_SHADOW_INT_MOV_SS;
 	if (ctxt->op_bytes > 2)
 		rsp_increment(ctxt, ctxt->op_bytes - 2);


