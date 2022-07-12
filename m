Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39338572526
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiGLTLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbiGLTKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:10:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F97FFE0F;
        Tue, 12 Jul 2022 11:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D324A61274;
        Tue, 12 Jul 2022 18:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03BFC3411C;
        Tue, 12 Jul 2022 18:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651962;
        bh=H1oq4uVfA8R9mjZ/zPPVepCseKRffdac0+kAYkJLC2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgSvlz2M72LsGJNkdMXaWI4ItTktsFuWBdIvgAq1pSTBJkvrGDDCSZ1ZS2MiGuwP9
         WKMlG+TAcMWg/HiTqmIbEDTTdhG8Tu55kWGAj6J4Dfk9GrIRs7Ce5GE9+K8Mrhg1Qp
         IycGPmYbhLNuh9R+TOh7cjFFdPA68ZbJ4lYOC4JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.18 09/61] x86/retpoline: Swizzle retpoline thunk
Date:   Tue, 12 Jul 2022 20:39:06 +0200
Message-Id: <20220712183237.319446654@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 00e1533325fd1fb5459229fe37f235462649f668 upstream.

Put the actual retpoline thunk as the original code so that it can
become more complicated. Specifically, it allows RET to be a JMP,
which can't be .altinstr_replacement since that doesn't do relocations
(except for the very first instruction).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -33,9 +33,9 @@ SYM_INNER_LABEL(__x86_indirect_thunk_\re
 	UNWIND_HINT_EMPTY
 	ANNOTATE_NOENDBR
 
-	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
-		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
+	ALTERNATIVE_2 __stringify(RETPOLINE \reg), \
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE, \
+		      __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), ALT_NOT(X86_FEATURE_RETPOLINE)
 
 .endm
 


