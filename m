Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFB66D49F8
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjDCOmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjDCOmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:42:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D8D280E2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5B161EED
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F31BC4339C;
        Mon,  3 Apr 2023 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532946;
        bh=x721Ns2IQhG4NILRKHvE444P7IS9AyMiYmAngU6wpZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tumS5rPWqaFj+7Ic1WuTOWb00hQ4bWBn8KX/onfnIpHHESnO9QgHcnzspY61xzUc3
         hC2uqqd16VhVwySdaN6NnO2fyXAHNiZJUpwgfUSMEH/85I7VEMKWVVGUJlnui1P5Kh
         Z2igv/ROARj5MMk++dMI3ixQ8qRrraS3f3OM34oQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eduard Zingerman <eddyz87@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/181] libbpf: Fix btf_dumps packed struct determination
Date:   Mon,  3 Apr 2023 16:10:12 +0200
Message-Id: <20230403140420.885270789@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 4fb877aaa179dcdb1676d55216482febaada457e ]

Fix bug in btf_dump's logic of determining if a given struct type is
packed or not. The notion of "natural alignment" is not needed and is
even harmful in this case, so drop it altogether. The biggest difference
in btf_is_struct_packed() compared to its original implementation is
that we don't really use btf__align_of() to determine overall alignment
of a struct type (because it could be 1 for both packed and non-packed
struct, depending on specifci field definitions), and just use field's
actual alignment to calculate whether any field is requiring packing or
struct's size overall necessitates packing.

Add two simple test cases that demonstrate the difference this change
would make.

Fixes: ea2ce1ba99aa ("libbpf: Fix BTF-to-C converter's padding logic")
Reported-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20221215183605.4149488-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c                      | 33 ++++---------------
 .../bpf/progs/btf_dump_test_case_packing.c    | 19 +++++++++++
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 09c78a7975184..56102711f395a 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -829,47 +829,26 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 	}
 }
 
-static int btf_natural_align_of(const struct btf *btf, __u32 id)
-{
-	const struct btf_type *t = btf__type_by_id(btf, id);
-	int i, align, vlen;
-	const struct btf_member *m;
-
-	if (!btf_is_composite(t))
-		return btf__align_of(btf, id);
-
-	align = 1;
-	m = btf_members(t);
-	vlen = btf_vlen(t);
-	for (i = 0; i < vlen; i++, m++) {
-		align = max(align, btf__align_of(btf, m->type));
-	}
-
-	return align;
-}
-
 static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 				 const struct btf_type *t)
 {
 	const struct btf_member *m;
-	int align, i, bit_sz;
+	int max_align = 1, align, i, bit_sz;
 	__u16 vlen;
 
-	align = btf_natural_align_of(btf, id);
-	/* size of a non-packed struct has to be a multiple of its alignment */
-	if (align && (t->size % align) != 0)
-		return true;
-
 	m = btf_members(t);
 	vlen = btf_vlen(t);
 	/* all non-bitfield fields have to be naturally aligned */
 	for (i = 0; i < vlen; i++, m++) {
-		align = btf_natural_align_of(btf, m->type);
+		align = btf__align_of(btf, m->type);
 		bit_sz = btf_member_bitfield_size(t, i);
 		if (align && bit_sz == 0 && m->offset % (8 * align) != 0)
 			return true;
+		max_align = max(align, max_align);
 	}
-
+	/* size of a non-packed struct has to be a multiple of its alignment */
+	if (t->size % max_align != 0)
+		return true;
 	/*
 	 * if original struct was marked as packed, but its layout is
 	 * naturally aligned, we'll detect that it's not packed
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
index 5c6c62f7ed328..7998f27df7ddd 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -116,6 +116,23 @@ struct usb_host_endpoint {
 	long: 0;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct nested_packed_struct {
+	int a;
+	char b;
+} __attribute__((packed));
+
+struct outer_nonpacked_struct {
+	short a;
+	struct nested_packed_struct b;
+};
+
+struct outer_packed_struct {
+	short a;
+	struct nested_packed_struct b;
+} __attribute__((packed));
+
+/* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
 	struct packed_trailing_space _1;
@@ -128,6 +145,8 @@ int f(struct {
 	union jump_code_union _8;
 	struct outer_implicitly_packed_struct _9;
 	struct usb_host_endpoint _10;
+	struct outer_nonpacked_struct _11;
+	struct outer_packed_struct _12;
 } *_)
 {
 	return 0;
-- 
2.39.2



