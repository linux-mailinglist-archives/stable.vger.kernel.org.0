Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE36D489C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbjDCOaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjDCOaN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:30:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A72C31996
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A98B81C4E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CC8C433EF;
        Mon,  3 Apr 2023 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532208;
        bh=AsbYOx2QXmqs9J+Y6IVM024ej3VXx5InMUhILcRA2hI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh3QFHRFdRu14nyd6QJbi42JB+mbGsEiZHDYd0bLvO9c0okr8vRUdz1RjVtb6Z33H
         HUn7mjVUc4NTxnNDcA2ivwS5lhv3ngWN6UEr48snNW1nNnId4UHQ8sPawDxK1qybGv
         YeedZpH39GJFW6Z1aYljqGlPr0m8stlBwhiQfgPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Per=20Sundstr=C3=B6m=20XP?= 
        <per.xp.sundstrom@ericsson.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/173] libbpf: Fix BTF-to-C converters padding logic
Date:   Mon,  3 Apr 2023 16:09:43 +0200
Message-Id: <20230403140419.884963576@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit ea2ce1ba99aa6a60c8d8a706e3abadf3de372163 ]

Turns out that btf_dump API doesn't handle a bunch of tricky corner
cases, as reported by Per, and further discovered using his testing
Python script ([0]).

This patch revamps btf_dump's padding logic significantly, making it
more correct and also avoiding unnecessary explicit padding, where
compiler would pad naturally. This overall topic turned out to be very
tricky and subtle, there are lots of subtle corner cases. The comments
in the code tries to give some clues, but comments themselves are
supposed to be paired with good understanding of C alignment and padding
rules. Plus some experimentation to figure out subtle things like
whether `long :0;` means that struct is now forced to be long-aligned
(no, it's not, turns out).

Anyways, Per's script, while not completely correct in some known
situations, doesn't show any obvious cases where this logic breaks, so
this is a nice improvement over the previous state of this logic.

Some selftests had to be adjusted to accommodate better use of natural
alignment rules, eliminating some unnecessary padding, or changing it to
`type: 0;` alignment markers.

Note also that for when we are in between bitfields, we emit explicit
bit size, while otherwise we use `: 0`, this feels much more natural in
practice.

Next patch will add few more test cases, found through randomized Per's
script.

  [0] https://lore.kernel.org/bpf/85f83c333f5355c8ac026f835b18d15060725fcb.camel@ericsson.com/

Reported-by: Per Sundström XP <per.xp.sundstrom@ericsson.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221212211505.558851-6-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c                      | 169 +++++++++++++-----
 .../bpf/progs/btf_dump_test_case_bitfields.c  |   2 +-
 .../bpf/progs/btf_dump_test_case_padding.c    |  58 ++++--
 3 files changed, 164 insertions(+), 65 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 0e2d63da24e91..4d27b08074a56 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -788,6 +788,25 @@ static void btf_dump_emit_type(struct btf_dump *d, __u32 id, __u32 cont_id)
 	}
 }
 
+static int btf_natural_align_of(const struct btf *btf, __u32 id)
+{
+	const struct btf_type *t = btf__type_by_id(btf, id);
+	int i, align, vlen;
+	const struct btf_member *m;
+
+	if (!btf_is_composite(t))
+		return btf__align_of(btf, id);
+
+	align = 1;
+	m = btf_members(t);
+	vlen = btf_vlen(t);
+	for (i = 0; i < vlen; i++, m++) {
+		align = max(align, btf__align_of(btf, m->type));
+	}
+
+	return align;
+}
+
 static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 				 const struct btf_type *t)
 {
@@ -795,16 +814,16 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 	int align, i, bit_sz;
 	__u16 vlen;
 
-	align = btf__align_of(btf, id);
-	/* size of a non-packed struct has to be a multiple of its alignment*/
-	if (align && t->size % align)
+	align = btf_natural_align_of(btf, id);
+	/* size of a non-packed struct has to be a multiple of its alignment */
+	if (align && (t->size % align) != 0)
 		return true;
 
 	m = btf_members(t);
 	vlen = btf_vlen(t);
 	/* all non-bitfield fields have to be naturally aligned */
 	for (i = 0; i < vlen; i++, m++) {
-		align = btf__align_of(btf, m->type);
+		align = btf_natural_align_of(btf, m->type);
 		bit_sz = btf_member_bitfield_size(t, i);
 		if (align && bit_sz == 0 && m->offset % (8 * align) != 0)
 			return true;
@@ -817,44 +836,97 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 	return false;
 }
 
-static int chip_away_bits(int total, int at_most)
-{
-	return total % at_most ? : at_most;
-}
-
 static void btf_dump_emit_bit_padding(const struct btf_dump *d,
-				      int cur_off, int m_off, int m_bit_sz,
-				      int align, int lvl)
+				      int cur_off, int next_off, int next_align,
+				      bool in_bitfield, int lvl)
 {
-	int off_diff = m_off - cur_off;
-	int ptr_bits = d->ptr_sz * 8;
+	const struct {
+		const char *name;
+		int bits;
+	} pads[] = {
+		{"long", d->ptr_sz * 8}, {"int", 32}, {"short", 16}, {"char", 8}
+	};
+	int new_off, pad_bits, bits, i;
+	const char *pad_type;
+
+	if (cur_off >= next_off)
+		return; /* no gap */
+
+	/* For filling out padding we want to take advantage of
+	 * natural alignment rules to minimize unnecessary explicit
+	 * padding. First, we find the largest type (among long, int,
+	 * short, or char) that can be used to force naturally aligned
+	 * boundary. Once determined, we'll use such type to fill in
+	 * the remaining padding gap. In some cases we can rely on
+	 * compiler filling some gaps, but sometimes we need to force
+	 * alignment to close natural alignment with markers like
+	 * `long: 0` (this is always the case for bitfields).  Note
+	 * that even if struct itself has, let's say 4-byte alignment
+	 * (i.e., it only uses up to int-aligned types), using `long:
+	 * X;` explicit padding doesn't actually change struct's
+	 * overall alignment requirements, but compiler does take into
+	 * account that type's (long, in this example) natural
+	 * alignment requirements when adding implicit padding. We use
+	 * this fact heavily and don't worry about ruining correct
+	 * struct alignment requirement.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pads); i++) {
+		pad_bits = pads[i].bits;
+		pad_type = pads[i].name;
 
-	if (off_diff <= 0)
-		/* no gap */
-		return;
-	if (m_bit_sz == 0 && off_diff < align * 8)
-		/* natural padding will take care of a gap */
-		return;
+		new_off = roundup(cur_off, pad_bits);
+		if (new_off <= next_off)
+			break;
+	}
 
-	while (off_diff > 0) {
-		const char *pad_type;
-		int pad_bits;
-
-		if (ptr_bits > 32 && off_diff > 32) {
-			pad_type = "long";
-			pad_bits = chip_away_bits(off_diff, ptr_bits);
-		} else if (off_diff > 16) {
-			pad_type = "int";
-			pad_bits = chip_away_bits(off_diff, 32);
-		} else if (off_diff > 8) {
-			pad_type = "short";
-			pad_bits = chip_away_bits(off_diff, 16);
-		} else {
-			pad_type = "char";
-			pad_bits = chip_away_bits(off_diff, 8);
+	if (new_off > cur_off && new_off <= next_off) {
+		/* We need explicit `<type>: 0` aligning mark if next
+		 * field is right on alignment offset and its
+		 * alignment requirement is less strict than <type>'s
+		 * alignment (so compiler won't naturally align to the
+		 * offset we expect), or if subsequent `<type>: X`,
+		 * will actually completely fit in the remaining hole,
+		 * making compiler basically ignore `<type>: X`
+		 * completely.
+		 */
+		if (in_bitfield ||
+		    (new_off == next_off && roundup(cur_off, next_align * 8) != new_off) ||
+		    (new_off != next_off && next_off - new_off <= new_off - cur_off))
+			/* but for bitfields we'll emit explicit bit count */
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type,
+					in_bitfield ? new_off - cur_off : 0);
+		cur_off = new_off;
+	}
+
+	/* Now we know we start at naturally aligned offset for a chosen
+	 * padding type (long, int, short, or char), and so the rest is just
+	 * a straightforward filling of remaining padding gap with full
+	 * `<type>: sizeof(<type>);` markers, except for the last one, which
+	 * might need smaller than sizeof(<type>) padding.
+	 */
+	while (cur_off != next_off) {
+		bits = min(next_off - cur_off, pad_bits);
+		if (bits == pad_bits) {
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, pad_bits);
+			cur_off += bits;
+			continue;
+		}
+		/* For the remainder padding that doesn't cover entire
+		 * pad_type bit length, we pick the smallest necessary type.
+		 * This is pure aesthetics, we could have just used `long`,
+		 * but having smallest necessary one communicates better the
+		 * scale of the padding gap.
+		 */
+		for (i = ARRAY_SIZE(pads) - 1; i >= 0; i--) {
+			pad_type = pads[i].name;
+			pad_bits = pads[i].bits;
+			if (pad_bits < bits)
+				continue;
+
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, bits);
+			cur_off += bits;
+			break;
 		}
-		btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, pad_bits);
-		off_diff -= pad_bits;
 	}
 }
 
@@ -873,9 +945,11 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 {
 	const struct btf_member *m = btf_members(t);
 	bool is_struct = btf_is_struct(t);
-	int align, i, packed, off = 0;
+	bool packed, prev_bitfield = false;
+	int align, i, off = 0;
 	__u16 vlen = btf_vlen(t);
 
+	align = btf__align_of(d->btf, id);
 	packed = is_struct ? btf_is_struct_packed(d->btf, id, t) : 0;
 
 	btf_dump_printf(d, "%s%s%s {",
@@ -885,33 +959,36 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 
 	for (i = 0; i < vlen; i++, m++) {
 		const char *fname;
-		int m_off, m_sz;
+		int m_off, m_sz, m_align;
+		bool in_bitfield;
 
 		fname = btf_name_of(d, m->name_off);
 		m_sz = btf_member_bitfield_size(t, i);
 		m_off = btf_member_bit_offset(t, i);
-		align = packed ? 1 : btf__align_of(d->btf, m->type);
+		m_align = packed ? 1 : btf__align_of(d->btf, m->type);
 
-		btf_dump_emit_bit_padding(d, off, m_off, m_sz, align, lvl + 1);
+		in_bitfield = prev_bitfield && m_sz != 0;
+
+		btf_dump_emit_bit_padding(d, off, m_off, m_align, in_bitfield, lvl + 1);
 		btf_dump_printf(d, "\n%s", pfx(lvl + 1));
 		btf_dump_emit_type_decl(d, m->type, fname, lvl + 1);
 
 		if (m_sz) {
 			btf_dump_printf(d, ": %d", m_sz);
 			off = m_off + m_sz;
+			prev_bitfield = true;
 		} else {
 			m_sz = max((__s64)0, btf__resolve_size(d->btf, m->type));
 			off = m_off + m_sz * 8;
+			prev_bitfield = false;
 		}
+
 		btf_dump_printf(d, ";");
 	}
 
 	/* pad at the end, if necessary */
-	if (is_struct) {
-		align = packed ? 1 : btf__align_of(d->btf, id);
-		btf_dump_emit_bit_padding(d, off, t->size * 8, 0, align,
-					  lvl + 1);
-	}
+	if (is_struct)
+		btf_dump_emit_bit_padding(d, off, t->size * 8, align, false, lvl + 1);
 
 	if (vlen)
 		btf_dump_printf(d, "\n");
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
index 8f44767a75fa5..22a7cd8fd9acf 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
@@ -53,7 +53,7 @@ struct bitfields_only_mixed_types {
  */
 /* ------ END-EXPECTED-OUTPUT ------ */
 struct bitfield_mixed_with_others {
-	long: 4; /* char is enough as a backing field */
+	char: 4; /* char is enough as a backing field */
 	int a: 4;
 	/* 8-bit implicit padding */
 	short b; /* combined with previous bitfield */
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index db5458da61826..28833f2694e9c 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -19,7 +19,7 @@ struct padded_implicitly {
 /*
  *struct padded_explicitly {
  *	int a;
- *	int: 32;
+ *	long: 0;
  *	int b;
  *};
  *
@@ -28,41 +28,28 @@ struct padded_implicitly {
 
 struct padded_explicitly {
 	int a;
-	int: 1; /* algo will explicitly pad with full 32 bits here */
+	int: 1; /* algo will emit aligning `long: 0;` here */
 	int b;
 };
 
 /* ----- START-EXPECTED-OUTPUT ----- */
-/*
- *struct padded_a_lot {
- *	int a;
- *	long: 32;
- *	long: 64;
- *	long: 64;
- *	int b;
- *};
- *
- */
-/* ------ END-EXPECTED-OUTPUT ------ */
-
 struct padded_a_lot {
 	int a;
-	/* 32 bit of implicit padding here, which algo will make explicit */
 	long: 64;
 	long: 64;
 	int b;
 };
 
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 /* ----- START-EXPECTED-OUTPUT ----- */
 /*
  *struct padded_cache_line {
  *	int a;
- *	long: 32;
  *	long: 64;
  *	long: 64;
  *	long: 64;
  *	int b;
- *	long: 32;
  *	long: 64;
  *	long: 64;
  *	long: 64;
@@ -85,7 +72,7 @@ struct padded_cache_line {
  *struct zone {
  *	int a;
  *	short b;
- *	short: 16;
+ *	long: 0;
  *	struct zone_padding __pad__;
  *};
  *
@@ -108,6 +95,39 @@ struct padding_wo_named_members {
 	long: 64;
 };
 
+struct padding_weird_1 {
+	int a;
+	long: 64;
+	short: 16;
+	short b;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padding_weird_2 {
+ *	long: 56;
+ *	char a;
+ *	long: 56;
+ *	char b;
+ *	char: 8;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct padding_weird_2 {
+	int: 32;	/* these paddings will be collapsed into `long: 56;` */
+	short: 16;
+	char: 8;
+	char a;
+	int: 32;	/* these paddings will be collapsed into `long: 56;` */
+	short: 16;
+	char: 8;
+	char b;
+	char: 8;
+};
+
 /* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
@@ -117,6 +137,8 @@ int f(struct {
 	struct padded_cache_line _4;
 	struct zone _5;
 	struct padding_wo_named_members _6;
+	struct padding_weird_1 _7;
+	struct padding_weird_2 _8;
 } *_)
 {
 	return 0;
-- 
2.39.2



