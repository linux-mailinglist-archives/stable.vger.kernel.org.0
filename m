Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B914FD45D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377619AbiDLHux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359395AbiDLHnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED102C133;
        Tue, 12 Apr 2022 00:22:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F7D3B81B4F;
        Tue, 12 Apr 2022 07:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF05C385A5;
        Tue, 12 Apr 2022 07:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748136;
        bh=uWWbWAFiJjTX83lC6DgCnZBOURJrl4U1pob1qP3NhQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaktoVgU4crXzxOARhUi+WVok4PMs26nb0sIAPC+RsXIgZ69CKNP/PRU0p/+M7gWb
         J2seiakeMCn2/J8eLsBdEKukLkHkbuWhYsPvQQ+hsfvbm0N+tNnxbxHyLopyTCnf9Q
         BHRsqYF2+oAwpg3j/zh/vyo1EsrwCqIPalqDMvAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.17 333/343] x86,static_call: Fix __static_call_return0 for i386
Date:   Tue, 12 Apr 2022 08:32:31 +0200
Message-Id: <20220412063000.930534859@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
 
 static const u8 retinsn[] = { RET_INSN_OPCODE, 0xcc, 0xcc, 0xcc, 0xcc };
 


