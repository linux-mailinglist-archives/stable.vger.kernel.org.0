Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7454FD593
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351802AbiDLHgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354857AbiDLH0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391FA47384;
        Tue, 12 Apr 2022 00:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9DDD6146F;
        Tue, 12 Apr 2022 07:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1EFC385A6;
        Tue, 12 Apr 2022 07:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747206;
        bh=9VK7Q9d8kUXkXOYxC5DYC7ucjglVOtJGawK4c7nKiDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F43f+qRBYxl7s2JwFmOszL1eurK6nXct+5AkDg/zY5ZJIhvXv3Ier9mF0JbPUCVgP
         f0TALr1TTQHxsUMkYkmbPLOGMAhX2PURKgfab1FUv46i32rS4C4V/P7nGJretUD/Eu
         BL5zAp1c3Fog8TSYv5BZHzyARGstukvbp8swSRjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.16 280/285] x86,static_call: Fix __static_call_return0 for i386
Date:   Tue, 12 Apr 2022 08:32:17 +0200
Message-Id: <20220412062951.734171923@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 1cd5f059d956e6f614ba6666ecdbcf95db05d5f5 upstream.

Paolo reported that the instruction sequence that is used to replace:

    call __static_call_return0

namely:

    66 66 48 31 c0	data16 data16 xor %rax,%rax

decodes to something else on i386, namely:

    66 66 48		data16 dec %ax
    31 c0		xor    %eax,%eax

Which is a nonsensical sequence that happens to have the same outcome.
*However* an important distinction is that it consists of 2
instructions which is a problem when the thing needs to be overwriten
with a regular call instruction again.

As such, replace the instruction with something that decodes the same
on both i386 and x86_64.

Fixes: 3f2a8fc4b15d ("static_call/x86: Add __static_call_return0()")
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20220318204419.GT8939@worktop.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/static_call.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -12,10 +12,9 @@ enum insn_type {
 };
 
 /*
- * data16 data16 xorq %rax, %rax - a single 5 byte instruction that clears %rax
- * The REX.W cancels the effect of any data16.
+ * cs cs cs xorl %eax, %eax - a single 5 byte instruction that clears %[er]ax
  */
-static const u8 xor5rax[] = { 0x66, 0x66, 0x48, 0x31, 0xc0 };
+static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
 static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
 {


