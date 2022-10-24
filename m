Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EF560A342
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiJXLxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiJXLwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:52:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757AC140D1;
        Mon, 24 Oct 2022 04:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DE38CE1331;
        Mon, 24 Oct 2022 11:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B31AC433D6;
        Mon, 24 Oct 2022 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611657;
        bh=pS5WP/5RnEfDdJOQcfOSKRNblYIG0koFCLEF4yVIa44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUIeEzcB+TygSa55iKR8/Z/zeBgrEPL+nPX9/SIy/4pIYbHyA+oOi/nF1lLdMmqFs
         q0yMrHr2PwLTK9GP0wBaVWDTMLZgpZccS/YrG8tWi4AulZYFVW0mMvDh6KkmjO7V0Q
         0ZIw+Hyi8D5eYxOC6B7CXhg7x9TCgIgPIBqCHfiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Luczaj <mhal@rbox.co>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 4.9 062/159] KVM: x86/emulator: Fix handing of POP SS to correctly set interruptibility
Date:   Mon, 24 Oct 2022 13:30:16 +0200
Message-Id: <20221024112951.717779337@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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
@@ -1980,7 +1980,7 @@ static int em_pop_sreg(struct x86_emulat
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	if (ctxt->modrm_reg == VCPU_SREG_SS)
+	if (seg == VCPU_SREG_SS)
 		ctxt->interruptibility = KVM_X86_SHADOW_INT_MOV_SS;
 	if (ctxt->op_bytes > 2)
 		rsp_increment(ctxt, ctxt->op_bytes - 2);


