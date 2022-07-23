Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B7C57EE5B
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiGWKJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239051AbiGWKJO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:09:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE2E7C1B5;
        Sat, 23 Jul 2022 03:02:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A92361212;
        Sat, 23 Jul 2022 10:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56433C341C0;
        Sat, 23 Jul 2022 10:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570515;
        bh=wNMpLzoGPFxhjiSNYi0HVZ8hNKaw3idO+yUyf00eJdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dmp8QKo3aabOsXf54FH1TrjeiuJP5vWZUWzluV8MCwqS169nz1c2auMiB3P9xlPBK
         2ucp9CaYIUW+VZnYYSeFPYZxF6bX/se52iqeaX70WcmfaPyeHnTZp43t3oyBi5eS8y
         fhulXngVzHQTzKu8VqkgeOhUMF77Zvp778dc1Cmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 113/148] x86/speculation: Fix firmware entry SPEC_CTRL handling
Date:   Sat, 23 Jul 2022 11:55:25 +0200
Message-Id: <20220723095256.025267059@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit e6aa13622ea8283cc699cac5d018cc40a2ba2010 upstream.

The firmware entry code may accidentally clear STIBP or SSBD. Fix that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -286,18 +286,16 @@ extern u64 spec_ctrl_current(void);
  */
 #define firmware_restrict_branch_speculation_start()			\
 do {									\
-	u64 val = x86_spec_ctrl_base | SPEC_CTRL_IBRS;			\
-									\
 	preempt_disable();						\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
 			      X86_FEATURE_USE_IBRS_FW);			\
 } while (0)
 
 #define firmware_restrict_branch_speculation_end()			\
 do {									\
-	u64 val = x86_spec_ctrl_base;					\
-									\
-	alternative_msr_write(MSR_IA32_SPEC_CTRL, val,			\
+	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
+			      spec_ctrl_current(),			\
 			      X86_FEATURE_USE_IBRS_FW);			\
 	preempt_enable();						\
 } while (0)


