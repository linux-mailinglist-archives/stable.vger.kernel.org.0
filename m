Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2959DA65
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352487AbiHWKHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352867AbiHWKGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:06:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB856408;
        Tue, 23 Aug 2022 01:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90C76B81BF8;
        Tue, 23 Aug 2022 08:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C022BC433C1;
        Tue, 23 Aug 2022 08:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244803;
        bh=69ovCRcumfGslh/oGLivZ4DIr8oJgQGwFuXGEqHGW5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BFGcUPhy3FdlJSs4xPaJ6Isyeg9C7IGbrGfh01GoRRPeTMr2xXjgGHHYvg2ih2GyQ
         jlBFXGAln7J1kUeFcuOc/a91Uqn+LtrSqUBOGyk1o017DjQ3O6Vr7D4nNBldzZEIPi
         7f6I4SVPUjKg4eT0rCUGVeXftPNCTixV0LlMi/mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, llvm@lists.linux.dev,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nick Terrell <terrelln@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 194/229] tools build: Switch to new openssl API for test-libcrypto
Date:   Tue, 23 Aug 2022 10:25:55 +0200
Message-Id: <20220823080100.563952280@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 5b245985a6de5ac18b5088c37068816d413fb8ed upstream.

Switch to new EVP API for detecting libcrypto, as Fedora 36 returns an
error when it encounters the deprecated function MD5_Init() and the others.

The error would be interpreted as missing libcrypto, while in reality it is
not.

Fixes: 6e8ccb4f624a73c5 ("tools/bpf: properly account for libbfd variations")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: llvm@lists.linux.dev
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Song Liu <song@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20220719170555.2576993-4-roberto.sassu@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/feature/test-libcrypto.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/tools/build/feature/test-libcrypto.c
+++ b/tools/build/feature/test-libcrypto.c
@@ -1,16 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <openssl/evp.h>
 #include <openssl/sha.h>
 #include <openssl/md5.h>
 
 int main(void)
 {
-	MD5_CTX context;
+	EVP_MD_CTX *mdctx;
 	unsigned char md[MD5_DIGEST_LENGTH + SHA_DIGEST_LENGTH];
 	unsigned char dat[] = "12345";
+	unsigned int digest_len;
 
-	MD5_Init(&context);
-	MD5_Update(&context, &dat[0], sizeof(dat));
-	MD5_Final(&md[0], &context);
+	mdctx = EVP_MD_CTX_new();
+	if (!mdctx)
+		return 0;
+
+	EVP_DigestInit_ex(mdctx, EVP_md5(), NULL);
+	EVP_DigestUpdate(mdctx, &dat[0], sizeof(dat));
+	EVP_DigestFinal_ex(mdctx, &md[0], &digest_len);
+	EVP_MD_CTX_free(mdctx);
 
 	SHA1(&dat[0], sizeof(dat), &md[0]);
 


