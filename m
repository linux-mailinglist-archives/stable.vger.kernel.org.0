Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA45B7180
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiIMOnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiIMOmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:42:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7636D9F9;
        Tue, 13 Sep 2022 07:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52D8DB80F98;
        Tue, 13 Sep 2022 14:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19B5C433D7;
        Tue, 13 Sep 2022 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078876;
        bh=NvuCnZsdy//Lgp/eK1ZTe2E40unrB1TaTfxhw1EWBGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMJJ27ByAfFBCxcakpNuXLXYvy4gxoAUIgr0/xb/sroc5f2QHrXg6wNSCSp9hEI2u
         fNU5qxyA9bCt1JXBVCh8JtroD2bauDjxSaFQ1XxSf1RSuq1auhrwe59Zka43Ta7PD0
         tVXG4T4tFmQ3FO5oTkXGYeXhl0UXw6bbSMGlCbR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        D Scott Phillips <scott@os.amperecomputing.com>,
        Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 116/121] arm64/bti: Disable in kernel BTI when cross section thunks are broken
Date:   Tue, 13 Sep 2022 16:05:07 +0200
Message-Id: <20220913140402.351314534@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Brown <broonie@kernel.org>

commit c0a454b9044fdc99486853aa424e5b3be2107078 upstream.

GCC does not insert a `bti c` instruction at the beginning of a function
when it believes that all callers reach the function through a direct
branch[1]. Unfortunately the logic it uses to determine this is not
sufficiently robust, for example not taking account of functions being
placed in different sections which may be loaded separately, so we may
still see thunks being generated to these functions. If that happens,
the first instruction in the callee function will result in a Branch
Target Exception due to the missing landing pad.

While this has currently only been observed in the case of modules
having their main code loaded sufficiently far from their init section
to require thunks it could potentially happen for other cases so the
safest thing is to disable BTI for the kernel when building with an
affected toolchain.

[1]: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106671

Reported-by: D Scott Phillips <scott@os.amperecomputing.com>
[Bits of the commit message are lifted from his report & workaround]
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220905142255.591990-1-broonie@kernel.org
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1626,6 +1626,8 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106671
+	depends on !CC_IS_GCC
 	# https://github.com/llvm/llvm-project/commit/a88c722e687e6780dcd6a58718350dc76fcc4cc9
 	depends on !CC_IS_CLANG || CLANG_VERSION >= 120000
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)


