Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BDD6512DA
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiLSTYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiLSTXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:23:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF5613F05
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:23:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B67BB80EF7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31392C433F1;
        Mon, 19 Dec 2022 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477787;
        bh=GqlCljcXYcLyLProTWx1L+qLCPI4QH6WP7FAKEXkoJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bapva+Jp7y4A9sy6VLJkNLO6qY5aVOguHvTwHqFAP7Ob4EheTh9pxJJIi5368s8Zf
         pFbWsZ2nTbVUCn9NLehW5MztspaEdRZzzgKiB47yg0Z6oyELVEKI72uRukm2Vf141Q
         3w3UJqvTR+7koBLSi2m5yNPMmF55aQ2SW3h87gbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 6.1 01/25] x86/vdso: Conditionally export __vdso_sgx_enter_enclave()
Date:   Mon, 19 Dec 2022 20:22:40 +0100
Message-Id: <20221219182943.454694192@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
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


