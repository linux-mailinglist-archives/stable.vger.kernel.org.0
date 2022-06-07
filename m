Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A80E541936
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378334AbiFGVTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380107AbiFGVPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:15:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9081721B12C;
        Tue,  7 Jun 2022 11:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 040B5612F2;
        Tue,  7 Jun 2022 18:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DECEC385A2;
        Tue,  7 Jun 2022 18:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628091;
        bh=cYbqQ0dMuwCZflYozzYeRbTkmB9Hzvvc14PryXL08Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaFNuiqj96H7HsOVWQCTJREH8pLgnZ712YkexUwb9OHERK064GRTJ/Uu21uXAGDdU
         pzOXuItlpeUivYgRJxJYWrUhMTh5F66Lsl+jzFUoclxOM2HcaN7IcFEAgnT9pd9K5s
         7UKkc0HzeraJjteL67nrzWZLjgHT4a2bpl3aRcbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mykola Lysenko <mykolal@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 204/879] selftests/bpf: fix btf_dump/btf_dump due to recent clang change
Date:   Tue,  7 Jun 2022 18:55:22 +0200
Message-Id: <20220607165008.768192981@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 4050764cbaa25760aab40857f723393c07898474 ]

Latest llvm-project upstream had a change of behavior
related to qualifiers on function return type ([1]).
This caused selftests btf_dump/btf_dump failure.
The following example shows what changed.

  $ cat t.c
  typedef const char * const (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
  struct t {
    int a;
    fn_ptr_arr2_t l;
  };
  int foo(struct t *arg) {
    return arg->a;
  }

Compiled with latest upstream llvm15,
  $ clang -O2 -g -target bpf -S -emit-llvm t.c
The related generated debuginfo IR looks like:
  !16 = !DIDerivedType(tag: DW_TAG_typedef, name: "fn_ptr_arr2_t", file: !1, line: 1, baseType: !17)
  !17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 320, elements: !32)
  !18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
  !19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
  !20 = !DISubroutineType(types: !21)
  !21 = !{!22, null}
  !22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
  !23 = !DISubroutineType(types: !24)
  !24 = !{!25, !28}
  !25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
  !26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
  !27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
You can see two intermediate const qualifier to pointer are dropped in debuginfo IR.

With llvm14, we have following debuginfo IR:
  !16 = !DIDerivedType(tag: DW_TAG_typedef, name: "fn_ptr_arr2_t", file: !1, line: 1, baseType: !17)
  !17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 320, elements: !34)
  !18 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !19)
  !19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
  !20 = !DISubroutineType(types: !21)
  !21 = !{!22, null}
  !22 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
  !23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
  !24 = !DISubroutineType(types: !25)
  !25 = !{!26, !30}
  !26 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
  !27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !28, size: 64)
  !28 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !29)
  !29 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
All const qualifiers are preserved.

To adapt the selftest to both old and new llvm, this patch removed
the intermediate const qualifier in const-to-ptr types, to make the
test succeed again.

  [1] https://reviews.llvm.org/D125919

Reported-by: Mykola Lysenko <mykolal@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20220523152044.3905809-1-yhs@fb.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index 1c7105fcae3c..4ee4748133fe 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -94,7 +94,7 @@ typedef void (* (*signal_t)(int, void (*)(int)))(int);
 
 typedef char * (*fn_ptr_arr1_t[10])(int **);
 
-typedef char * (* const (* const fn_ptr_arr2_t[5])())(char * (*)(int));
+typedef char * (* (* const fn_ptr_arr2_t[5])())(char * (*)(int));
 
 struct struct_w_typedefs {
 	int_t a;
-- 
2.35.1



