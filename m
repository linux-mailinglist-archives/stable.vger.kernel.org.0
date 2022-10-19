Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A957604858
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbiJSN4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiJSNxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:53:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59D6104D1F;
        Wed, 19 Oct 2022 06:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D34EB8232D;
        Wed, 19 Oct 2022 08:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26F0C433D7;
        Wed, 19 Oct 2022 08:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666169783;
        bh=mvgC1sP7uki5sMmm9a+x8WWds1qQzBdFAjhKUtv4gYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VgQ8SnAtiJlkWF/Wq1jsStnXkVIh+gJsVUNJgtT2xghBUrT+FsoQa7uWVbX2327zu
         UZXNrVoAfb+P659lrYG+yH2RnucGgVGXBdfuCwL7G0io0JAUyrz8YS1Kr6jVimByzQ
         btqAJm6vcSiwgoEnwFqm5w/kPPB3rC/y8tNbfeGXC7zB3pjGM3YEU9mUwxt2iaEjIf
         AQF8pj6kiXRc71KHrRm3u2em2Rs8UU55lR14vI22Jsp/MHSHCb9aRNR9ztZGKyJy2n
         a6P/jd44+UvYb3ocIp9zneLt6wtRQNba64JyB0sy0iRA1U/Ql0GGG37SdnQ8gqPmNl
         hL+HmuP4bxJEA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        =?UTF-8?q?Philip=20M=C3=BCller?= <philm@manjaro.org>
Subject: [PATCH stable 5.10 1/5] bpf: Generate BTF_KIND_FLOAT when linking vmlinux
Date:   Wed, 19 Oct 2022 10:56:00 +0200
Message-Id: <20221019085604.1017583-2-jolsa@kernel.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit db16c1fe92d7ba7d39061faef897842baee2c887  upstream.

[backported for dependency only extra_paholeopt variable setup and
usage, we don't want floats generated in 5.10]

pahole v1.21 supports the --btf_gen_floats flag, which makes it
generate the information about the floating-point types [1].

Adjust link-vmlinux.sh to pass this flag to pahole in case it's
supported, which is determined using a simple version check.

[1] https://lore.kernel.org/dwarves/YHRiXNX1JUF2Az0A@kernel.org/

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210413190043.21918-1-iii@linux.ibm.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 scripts/link-vmlinux.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d0b44bee9286..cdfccbfed452 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -146,6 +146,7 @@ vmlinux_link()
 gen_btf()
 {
 	local pahole_ver
+	local extra_paholeopt=
 
 	if ! [ -x "$(command -v ${PAHOLE})" ]; then
 		echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
@@ -161,7 +162,7 @@ gen_btf()
 	vmlinux_link ${1}
 
 	info "BTF" ${2}
-	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
+	LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${extra_paholeopt} ${1}
 
 	# Create ${2} which contains just .BTF section but no symbols. Add
 	# SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
-- 
2.37.3

