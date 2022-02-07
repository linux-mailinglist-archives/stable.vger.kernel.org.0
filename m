Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE534ABCB8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387071AbiBGLi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385760AbiBGLc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF456C043181;
        Mon,  7 Feb 2022 03:32:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7290460C99;
        Mon,  7 Feb 2022 11:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1F7C004E1;
        Mon,  7 Feb 2022 11:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233547;
        bh=pejCLm/dhWAINZ/EwhvHtPsSwaQldnRAQnd2fBpHpUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9hWeim76AJ8AxFR+JuDdCbICabx/yEa0DJVRJ6hk4e+uN1oAPLJ0aUYsEW3+IoPi
         5neydjqRmgYNRYX/J+w74Ip9hzbP9EULMLqANiRKnNj6ZGglZK1bR1lsLw7+2CWLLM
         xfY5dt4qluHWwaYloXEA7UhXDduQuPiUmu9AmoBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.16 046/126] KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
Date:   Mon,  7 Feb 2022 12:06:17 +0100
Message-Id: <20220207103805.706627373@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 1229630af88620f6e3a621a1ebd1ca14d9340df7 upstream.

Prior to commit defe21f49bc9 ("KVM: arm64: Move PC rollback on SError to
HYP"), when an SError is synchronised due to another exception, KVM
handles the SError first. If the guest survives, the instruction that
triggered the original exception is re-exectued to handle the first
exception. HVC is treated as a special case as the instruction wouldn't
normally be re-exectued, as its not a trap.

Commit defe21f49bc9 didn't preserve the behaviour of the 'return 1'
that skips the rest of handle_exit().

Since commit defe21f49bc9, KVM will try to handle the SError and the
original exception at the same time. When the exception was an HVC,
fixup_guest_exit() has already rolled back ELR_EL2, meaning if the
guest has virtual SError masked, it will execute and handle the HVC
twice.

Restore the original behaviour.

Fixes: defe21f49bc9 ("KVM: arm64: Move PC rollback on SError to HYP")
Cc: stable@vger.kernel.org
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127122052.1584324-4-james.morse@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/handle_exit.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -226,6 +226,14 @@ int handle_exit(struct kvm_vcpu *vcpu, i
 {
 	struct kvm_run *run = vcpu->run;
 
+	if (ARM_SERROR_PENDING(exception_index)) {
+		/*
+		 * The SError is handled by handle_exit_early(). If the guest
+		 * survives it will re-execute the original instruction.
+		 */
+		return 1;
+	}
+
 	exception_index = ARM_EXCEPTION_CODE(exception_index);
 
 	switch (exception_index) {


