Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C795D572576
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiGLTOv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbiGLTO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:14:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC8CE6837;
        Tue, 12 Jul 2022 11:54:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F414B81BBC;
        Tue, 12 Jul 2022 18:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FD5C3411C;
        Tue, 12 Jul 2022 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657652047;
        bh=t55yt/LMlIfpbPsw7IS/Yaxzn6Vb7UHsPvECtfrxVOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaf8xUgj2MoUu6TRWVRjm/0SOTv2XDRHnmuMkGGKLmoxr5EMoIBUtUM7A3khgsRCi
         1RkqIAeY8/FgwPvRWN+JvKD/JPy9o4WdSbWOikUQe/h2/Reblg7SKmf3DK0WbkC/am
         MDCBFXSXGmCa2vFGDe4SaDmuBBp1WwMdc1iQZwyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 42/61] x86/speculation: Fix firmware entry SPEC_CTRL handling
Date:   Tue, 12 Jul 2022 20:39:39 +0200
Message-Id: <20220712183238.642675838@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
References: <20220712183236.931648980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -285,18 +285,16 @@ extern u64 spec_ctrl_current(void);
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


