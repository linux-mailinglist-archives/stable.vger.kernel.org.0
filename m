Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4100C69CC65
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjBTNjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjBTNjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2B71C33A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B82B60CBA
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72332C433EF;
        Mon, 20 Feb 2023 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900388;
        bh=NEOwVndLnbZZBmbOXpKeLgQsmHk4tPs1HHT8GqvoVZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgSSMcE4Ty7R6Crha6xDLHDQC+fytHznQMVdfh2rLJUEBRGyN/TQJcvhRUaAbiYl6
         s04DIe00JbPQgQG3akr4ksROBY+FSL/b6bsYxqUEn0IaK07ebOUX2g1turyuYN+Qse
         3BlLz8jmgo/jiEO5+J1MBtoc0Pa/otpqYfeGM71g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Nies <michael.nies@netclusive.com>,
        YingChi Long <me@inclyc.cn>, Borislav Petkov <bp@suse.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.14 38/53] Revert "x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN"
Date:   Mon, 20 Feb 2023 14:36:04 +0100
Message-Id: <20230220133549.532754726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 67c6d79777cf5d3165d6d2e2d7c5e37333d1a76e which is
commit 55228db2697c09abddcb9487c3d9fa5854a932cd upstream.

_Alignof is not in the gcc version that the 4.14.y kernel still
supports (3.2), so this change needs to be reverted as it breaks the
build on those older compiler versions.

Reported-by: Michael Nies <michael.nies@netclusive.com>
Link: https://lore.kernel.org/r/HE1PR0902MB188277E37DED663AE440510BE1D99@HE1PR0902MB1882.eurprd09.prod.outlook.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217013
Cc: YingChi Long <me@inclyc.cn>
Cc: Borislav Petkov <bp@suse.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/init.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -138,6 +138,9 @@ static void __init fpu__init_system_gene
 unsigned int fpu_kernel_xstate_size;
 EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
+/* Get alignment of the TYPE. */
+#define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
+
 /*
  * Enforce that 'MEMBER' is the last field of 'TYPE'.
  *
@@ -145,8 +148,8 @@ EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size
  * because that's how C aligns structs.
  */
 #define CHECK_MEMBER_AT_END_OF(TYPE, MEMBER) \
-	BUILD_BUG_ON(sizeof(TYPE) !=         \
-		     ALIGN(offsetofend(TYPE, MEMBER), _Alignof(TYPE)))
+	BUILD_BUG_ON(sizeof(TYPE) != ALIGN(offsetofend(TYPE, MEMBER), \
+					   TYPE_ALIGN(TYPE)))
 
 /*
  * We append the 'struct fpu' to the task_struct:


