Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA97603DAF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbiJSJFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiJSJE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:04:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CCDAF1BC;
        Wed, 19 Oct 2022 01:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E9646182C;
        Wed, 19 Oct 2022 08:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD034C43470;
        Wed, 19 Oct 2022 08:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666169793;
        bh=scqpA+ha7SzlbjXpyjkq6PnxKVFNnwZoNtO5fqgmj+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEo3G+RClphBrxr72vNpX2vPrejo35VbzycOkLHYEL23oO57LelB9Vr+wXn3tkL9A
         /gWvmcTiGhe6XYhUwdUow55Q/WxMT5g0zTdGDLz5WWiD4UbYbcyXpBn/T4hQquEeqr
         LGmTeBBmEqGS1pMve40cbjxbM0wY5//DSaGKjnNi9pAScR0lHCJj+7yUM3NjL7Ao/L
         6o35DE7EONjiPhE1XFn17bP8LR64JcQy8UhdL5+v3CzPp9YNXjBxPCMJI8DbNxRcTC
         FzjOJB/Ls1CEqCaiDaaaYWYGrgvK6QJQuRLZ3025WJruBMBGToVj74xSh9Hywis7be
         TvI2SCTrbGiMA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH stable 5.10 2/5] kbuild: Quote OBJCOPY var to avoid a pahole call break the build
Date:   Wed, 19 Oct 2022 10:56:01 +0200
Message-Id: <20221019085604.1017583-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019085604.1017583-1-jolsa@kernel.org>
References: <20221019085604.1017583-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

commit ff2e6efda0d5c51b33e2bcc0b0b981ac0a0ef214 upstream.

[backported for dependency, skipped Makefile.modfinal change,
because module BTF is not supported in 5.10]

The ccache tool can be used to speed up cross-compilation, by calling the
compiler and binutils through ccache. For example, following should work:

    $ export ARCH=arm64 CROSS_COMPILE="ccache aarch64-linux-gnu-"

    $ make M=drivers/gpu/drm/rockchip/

but pahole fails to extract the BTF info from DWARF, breaking the build:

      CC [M]  drivers/gpu/drm/rockchip//rockchipdrm.mod.o
      LD [M]  drivers/gpu/drm/rockchip//rockchipdrm.ko
      BTF [M] drivers/gpu/drm/rockchip//rockchipdrm.ko
    aarch64-linux-gnu-objcopy: invalid option -- 'J'
    Usage: aarch64-linux-gnu-objcopy [option(s)] in-file [out-file]
     Copies a binary file, possibly transforming it in the process
    ...
    make[1]: *** [scripts/Makefile.modpost:156: __modpost] Error 2
    make: *** [Makefile:1866: modules] Error 2

this fails because OBJCOPY is set to "ccache aarch64-linux-gnu-copy" and
later pahole is executed with the following command line:

    LLVM_OBJCOPY=$(OBJCOPY) $(PAHOLE) -J --btf_base vmlinux $@

which gets expanded to:

    LLVM_OBJCOPY=ccache aarch64-linux-gnu-objcopy pahole -J ...

instead of:

    LLVM_OBJCOPY="ccache aarch64-linux-gnu-objcopy" pahole -J ...

Fixes: 5f9ae91f7c0d ("kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/bpf/20210526215228.3729875-1-javierm@redhat.com
---
 scripts/link-vmlinux.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index cdfccbfed452..72bf14df6903 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -162,7 +162,7 @@ gen_btf()
 	vmlinux_link ${1}
 
 	info "BTF" ${2}
-	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${extra_paholeopt} ${1}
+	LLVM_OBJCOPY="${OBJCOPY}" ${PAHOLE} -J ${extra_paholeopt} ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
-- 
2.37.3

