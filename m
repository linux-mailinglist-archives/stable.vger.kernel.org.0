Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DAB572436
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiGLS6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiGLS5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:57:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D56DC8B8;
        Tue, 12 Jul 2022 11:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0FE9B81B96;
        Tue, 12 Jul 2022 18:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79B2C341C0;
        Tue, 12 Jul 2022 18:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651630;
        bh=p/gFMJFw+0KXPwGqJWjVQcM1S+G3M3UFlYzAwYKkkCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ryvi51HhLRM8fCIEfjMdGf/DCKgkhTjry/XQo67UN7ItFq5QSTyrUS9J79j/TgPi/
         T2eJuxOGTqHzcxZDmIFOnV1M1DA/rC2LCAMBO/OOEGYF9sy9qQU6xhlQQ8R6DVQtxr
         7CdZYobke40dtZOZ0Wl7voCB4XeZSAtZ3/KDWqmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 114/130] x86/speculation: Fix SPEC_CTRL write on SMT state change
Date:   Tue, 12 Jul 2022 20:39:20 +0200
Message-Id: <20220712183251.726523641@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
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

commit 56aa4d221f1ee2c3a49b45b800778ec6e0ab73c5 upstream.

If the SMT state changes, SSBD might get accidentally disabled.  Fix
that.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1414,7 +1414,8 @@ static void __init spectre_v2_select_mit
 
 static void update_stibp_msr(void * __unused)
 {
-	write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
+	write_spec_ctrl_current(val, true);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */


