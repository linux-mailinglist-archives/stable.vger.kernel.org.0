Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D91C64E056
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLOSMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 13:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiLOSMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 13:12:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64B32ED5C
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 10:12:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EA2F61E59
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 18:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450E9C433EF;
        Thu, 15 Dec 2022 18:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671127923;
        bh=GqlCljcXYcLyLProTWx1L+qLCPI4QH6WP7FAKEXkoJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tstW8GKznt4wIqRf1qOhEiboT2mezSAVUG1skrZ40vMP39YhR9rPfd/CYe8aESR8q
         oac8qUFZIJHmVb3gLuTLSpF5AVAvigf+X4W/EmztFrvFsxOCiEFLAzB7ZGdSQkfE1l
         4lTCC2tJd00CDSCKFemF84rrGbKg8bmwWuUhl9P0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.15 01/14] x86/vdso: Conditionally export __vdso_sgx_enter_enclave()
Date:   Thu, 15 Dec 2022 19:10:37 +0100
Message-Id: <20221215172906.405983924@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Nathan Chancellor <nathan@kernel.org>

commit 45be2ad007a9c6bea70249c4cf3e4905afe4caeb upstream.

Recently, ld.lld moved from '--undefined-version' to
'--no-undefined-version' as the default, which breaks building the vDSO
when CONFIG_X86_SGX is not set:

  ld.lld: error: version script assignment of 'LINUX_2.6' to symbol '__vdso_sgx_enter_enclave' failed: symbol not defined

__vdso_sgx_enter_enclave is only included in the vDSO when
CONFIG_X86_SGX is set. Only export it if it will be present in the final
object, which clears up the error.

Fixes: 8466436952017 ("x86/vdso: Implement a vDSO for Intel SGX enclave call")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1756
Link: https://lore.kernel.org/r/20221109000306.1407357-1-nathan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/vdso/vdso.lds.S |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/entry/vdso/vdso.lds.S
+++ b/arch/x86/entry/vdso/vdso.lds.S
@@ -27,7 +27,9 @@ VERSION {
 		__vdso_time;
 		clock_getres;
 		__vdso_clock_getres;
+#ifdef CONFIG_X86_SGX
 		__vdso_sgx_enter_enclave;
+#endif
 	local: *;
 	};
 }


