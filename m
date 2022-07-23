Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B5757EE94
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbiGWKNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbiGWKMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:12:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D226D3657;
        Sat, 23 Jul 2022 03:03:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06985CE0B68;
        Sat, 23 Jul 2022 10:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB938C341C0;
        Sat, 23 Jul 2022 10:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570602;
        bh=/rrw6F0rSsfVQqxOLNWBcDP28QbOYy6khI9EDel11R8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAgPHxQlFmZuqi7ejQ7Wu+vPV19O5ug+d5u6BXY68ukis8GVRmjtb7jkGQrhH+Wat
         aTnFGUkuHz5LupAATJEkxMOvBskaXSHYHPBk1dXtgOqz4OhVDLLhmLPuDMBhU3PSo1
         ZmDXPso14agA8ZESVgT7HdatpQMEXpN/rXfz5o1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10 144/148] x86: Use -mindirect-branch-cs-prefix for RETPOLINE builds
Date:   Sat, 23 Jul 2022 11:55:56 +0200
Message-Id: <20220723095304.680881838@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 68cf4f2a72ef8786e6b7af6fd9a89f27ac0f520d upstream.

In order to further enable commit:

  bbe2df3f6b6d ("x86/alternative: Try inline spectre_v2=retpoline,amd")

add the new GCC flag -mindirect-branch-cs-prefix:

  https://gcc.gnu.org/g:2196a681d7810ad8b227bf983f38ba716620545e
  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=102952
  https://bugs.llvm.org/show_bug.cgi?id=52323

to RETPOLINE=y builds. This should allow fully inlining retpoline,amd
for GCC builds.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lkml.kernel.org/r/20211119165630.276205624@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -672,6 +672,7 @@ endif
 
 ifdef CONFIG_CC_IS_GCC
 RETPOLINE_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-extern -mindirect-branch-register)
+RETPOLINE_CFLAGS	+= $(call cc-option,-mindirect-branch-cs-prefix)
 RETPOLINE_VDSO_CFLAGS	:= $(call cc-option,-mindirect-branch=thunk-inline -mindirect-branch-register)
 endif
 ifdef CONFIG_CC_IS_CLANG


