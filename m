Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A4D4FD895
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351657AbiDLHVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351866AbiDLHNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:13:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755A6100A;
        Mon, 11 Apr 2022 23:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28A59B81B43;
        Tue, 12 Apr 2022 06:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902EAC385A1;
        Tue, 12 Apr 2022 06:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746430;
        bh=9VK7Q9d8kUXkXOYxC5DYC7ucjglVOtJGawK4c7nKiDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VydAOwY2Lr7jZB8PG/zD00mgCOZiofSrd1ptnVCXbHTHvt9lmuOl0AvzJalMF46ga
         Lp35AZMMm38fXAcjWSfbAUCS3aRY+5CEH9TdoN0I3P6qCz8+h3lQeQ6Vxp920KqyjX
         VZOWw32gWccLd+WLCP7ftTT/r+vyXWGcPmNJ+exw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 271/277] x86,static_call: Fix __static_call_return0 for i386
Date:   Tue, 12 Apr 2022 08:31:14 +0200
Message-Id: <20220412062949.883964591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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


