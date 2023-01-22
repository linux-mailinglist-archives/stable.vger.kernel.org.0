Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135DD676EDC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjAVPPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjAVPPK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E9722025
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51DC060C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6962BC433D2;
        Sun, 22 Jan 2023 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400508;
        bh=OqxWEtiTOn4kTu3mdysvMJoqky85DyyHjpgSTRcjVfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1lWYcUiZw9sqM7VYN+nP+hnKyjEuZobn9VQxGmH/WgXDVxQ0dhazlx1YZNozzqKXJ
         BPliCrWF4iMSVTvWkKis8YPlp17IpkzvdlbUWG59vT8wLnFLs+sgblt9YZ6VbHjiAR
         BKle2AYibKFMPx24bdYM/f+PrwfS1jP9MfI0S/DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YingChi Long <me@inclyc.cn>,
        Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 83/98] x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN
Date:   Sun, 22 Jan 2023 16:04:39 +0100
Message-Id: <20230122150232.957258261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YingChi Long <me@inclyc.cn>

commit 55228db2697c09abddcb9487c3d9fa5854a932cd upstream.

WG14 N2350 specifies that it is an undefined behavior to have type
definitions within offsetof", see

  https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2350.htm

This specification is also part of C23.

Therefore, replace the TYPE_ALIGN macro with the _Alignof builtin to
avoid undefined behavior. (_Alignof itself is C11 and the kernel is
built with -gnu11).

ISO C11 _Alignof is subtly different from the GNU C extension
__alignof__. Latter is the preferred alignment and _Alignof the
minimal alignment. For long long on x86 these are 8 and 4
respectively.

The macro TYPE_ALIGN's behavior matches _Alignof rather than
__alignof__.

  [ bp: Massage commit message. ]

Signed-off-by: YingChi Long <me@inclyc.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20220925153151.2467884-1-me@inclyc.cn
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/init.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,9 +138,6 @@ static void __init fpu__init_system_gene
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
-/* Get alignment of the TYPE. */
-#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
-
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -148,8 +145,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
-					   TYPE_ALIGN(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) !=         \
+		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:


