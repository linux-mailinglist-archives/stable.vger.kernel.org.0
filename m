Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15A957EE5A
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiGWKKN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbiGWKJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9952CE50B;
        Sat, 23 Jul 2022 03:02:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F3CAB82B92;
        Sat, 23 Jul 2022 10:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDE8C341C0;
        Sat, 23 Jul 2022 10:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570570;
        bh=oUt1hCweBt6JC7gg1LyKIiRwNXtpWgJiF7uTPwGsvCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbcxIRZSnrX1Y17dDnDijJOy6K6w8WExwDQivR1WPxofNrkrUPDkYo9YHmLAQ3nAS
         2jNij8v3AIaEn6/9Y6QKMZhRG2/jfXufAuUDmk49WcTGRc5YginU6wecSH+8qetlvg
         aORkTXlK+Nb+pZXo4pyOo4XtPyAq8iCML6FXXTGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <bwh@kernel.org>
Subject: [PATCH 5.10 132/148] x86, kvm: use proper ASM macros for kvm_vcpu_is_preempted
Date:   Sat, 23 Jul 2022 11:55:44 +0200
Message-Id: <20220723095301.320884513@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit edbaf6e5e93acda96aae23ba134ef3c1466da3b5 upstream.

The build rightfully complains about:
	arch/x86/kernel/kvm.o: warning: objtool: __raw_callee_save___kvm_vcpu_is_preempted()+0x12: missing int3 after ret

because the ASM_RET call is not being used correctly in kvm_vcpu_is_preempted().

This was hand-fixed-up in the kvm merge commit a4cfff3f0f8c ("Merge branch
'kvm-older-features' into HEAD") which of course can not be backported to
stable kernels, so just fix this up directly instead.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Hutchings <bwh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -953,7 +953,7 @@ asm(
 "movq	__per_cpu_offset(,%rdi,8), %rax;"
 "cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
 "setne	%al;"
-"ret;"
+ASM_RET
 ".size __raw_callee_save___kvm_vcpu_is_preempted, .-__raw_callee_save___kvm_vcpu_is_preempted;"
 ".popsection");
 


