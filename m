Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5513560861D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiJVHpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJVHnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:43:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A9C57884;
        Sat, 22 Oct 2022 00:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C705B82E0A;
        Sat, 22 Oct 2022 07:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AABC433C1;
        Sat, 22 Oct 2022 07:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424479;
        bh=06sUnyiUUf5pAI439nFvDLqDo5NANVTJ7UYdi7Hv6zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZyYmiy6Nx3dbOYaJCgYfPvdI+dDOrGIp8eIoDY+FIKxnnfniTziJ/6dRgO81mr4C
         dj0vRhYPAWS2PG/tSes02tz+C4wyXRjZ5VTa+HcyJxjDJ66ASwy6wtXDN32atdP7Hb
         TBEz6L4w0I7t11BLarZ0V0nNW+9BIlRRM3hyQ7mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.19 160/717] KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility
Date:   Sat, 22 Oct 2022 09:20:39 +0200
Message-Id: <20221022072443.800987816@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1955,7 +1955,7 @@ static int em_pop_sreg(struct x86_emulat
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (ctxt->modrm_reg == VCPU_SREG_SS)
+	if (seg == VCPU_SREG_SS)
 		ctxt->interruptibility = KVM_X86_SHADOW_INT_MOV_SS;
 	if (ctxt->op_bytes > 2)
 		rsp_increment(ctxt, ctxt->op_bytes - 2);


