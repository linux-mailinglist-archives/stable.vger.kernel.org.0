Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFD85B5C48
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 16:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiILOeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 10:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiILOet (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 10:34:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F620BE0D
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 07:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2DE5B80CAA
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A93C433D6;
        Mon, 12 Sep 2022 14:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662993285;
        bh=5zQFluWRz/IQqXI8c1ueRD9CzzCEMHl16SI7AxwzNV8=;
        h=Subject:To:Cc:From:Date:From;
        b=DT8wOpjX9YsmKLX6RqTH1/kI3eZewbC6CqZJq+owqsckFCdgqpJmw+2/3d9QPrSLu
         GId3YDHQ6IzPIzrmb3A7Uor2EbymttJQ8oNzYlE9NWThQJzY+71+XDRX9xyh3zIjj+
         c4zVhbsc1j07U3eYFYpBSwXhtLcq164cvCSVwMS0=
Subject: FAILED: patch "[PATCH] arm64/bti: Disable in kernel BTI when cross section thunks" failed to apply to 5.10-stable tree
To:     broonie@kernel.org, scott@os.amperecomputing.com,
        stable@vger.kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 12 Sep 2022 16:35:09 +0200
Message-ID: <166299330913126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c0a454b9044f ("arm64/bti: Disable in kernel BTI when cross section thunks are broken")
8cdd23c23c3d ("arm64: Restrict ARM64_BTI_KERNEL to clang 12.0.0 and newer")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c0a454b9044fdc99486853aa424e5b3be2107078 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@kernel.org>
Date: Mon, 5 Sep 2022 15:22:55 +0100
Subject: [PATCH] arm64/bti: Disable in kernel BTI when cross section thunks
 are broken

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

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9fb9fff08c94..1ce7685ad5de 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1887,6 +1887,8 @@ config ARM64_BTI_KERNEL
 	depends on CC_HAS_BRANCH_PROT_PAC_RET_BTI
 	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=94697
 	depends on !CC_IS_GCC || GCC_VERSION >= 100100
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106671
+	depends on !CC_IS_GCC
 	# https://github.com/llvm/llvm-project/commit/a88c722e687e6780dcd6a58718350dc76fcc4cc9
 	depends on !CC_IS_CLANG || CLANG_VERSION >= 120000
 	depends on (!FUNCTION_GRAPH_TRACER || DYNAMIC_FTRACE_WITH_REGS)

