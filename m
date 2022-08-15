Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63661594204
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242166AbiHOVKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348114AbiHOVIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:08:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B9052E61;
        Mon, 15 Aug 2022 12:18:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 152EA60F6A;
        Mon, 15 Aug 2022 19:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AEAC433C1;
        Mon, 15 Aug 2022 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591105;
        bh=RQC04sJGMjT6XKh3t5k+vlRJIMq7XS4wkzF/QxCzlZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tevvKICWnMaeU/LeLgfJs3eg+X41mgYO1q0uElQF10i0hRwD6IaLX6otkrKrr01rQ
         5c30psAhyNQYyxhevlw01JdKu4LbYxOUMTlA1RlahEwRJoz+qF3FVU7T0PuMM0ikF2
         P2sa7F02s7OAYHHoYDgnlg2KAtvrILqQjLy2S4zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0474/1095] bpf: Make btf_find_field more generic
Date:   Mon, 15 Aug 2022 19:57:53 +0200
Message-Id: <20220815180449.194539098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 42ba1308074d9046386d58b56e793604be48ce22 ]

Next commit introduces field type 'kptr' whose kind will not be struct,
but pointer, and it will not be limited to one offset, but multiple
ones. Make existing btf_find_struct_field and btf_find_datasec_var
functions amenable to use for finding kptrs in map value, by moving
spin_lock and timer specific checks into their own function.

The alignment, and name are checked before the function is called, so it
is the last point where we can skip field or return an error before the
next loop iteration happens. Size of the field and type is meant to be
checked inside the function.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220415160354.1050687-2-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 120 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 89 insertions(+), 31 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index feef799884d1..1fd8400bda06 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3163,24 +3163,44 @@ static void btf_struct_log(struct btf_verifier_env *env,
 	btf_verifier_log(env, "size=%u vlen=%u", t->size, btf_type_vlen(t));
 }
 
+enum btf_field_type {
+	BTF_FIELD_SPIN_LOCK,
+	BTF_FIELD_TIMER,
+};
+
+struct btf_field_info {
+	u32 off;
+};
+
+static int btf_find_struct(const struct btf *btf, const struct btf_type *t,
+			   u32 off, int sz, struct btf_field_info *info)
+{
+	if (!__btf_type_is_struct(t))
+		return 0;
+	if (t->size != sz)
+		return 0;
+	if (info->off != -ENOENT)
+		/* only one such field is allowed */
+		return -E2BIG;
+	info->off = off;
+	return 0;
+}
+
 static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t,
-				 const char *name, int sz, int align)
+				 const char *name, int sz, int align,
+				 enum btf_field_type field_type,
+				 struct btf_field_info *info)
 {
 	const struct btf_member *member;
-	u32 i, off = -ENOENT;
+	u32 i, off;
 
 	for_each_member(i, t, member) {
 		const struct btf_type *member_type = btf_type_by_id(btf,
 								    member->type);
-		if (!__btf_type_is_struct(member_type))
-			continue;
-		if (member_type->size != sz)
-			continue;
+
 		if (strcmp(__btf_name_by_offset(btf, member_type->name_off), name))
 			continue;
-		if (off != -ENOENT)
-			/* only one such field is allowed */
-			return -E2BIG;
+
 		off = __btf_member_bit_offset(t, member);
 		if (off % 8)
 			/* valid C code cannot generate such BTF */
@@ -3188,46 +3208,76 @@ static int btf_find_struct_field(const struct btf *btf, const struct btf_type *t
 		off /= 8;
 		if (off % align)
 			return -EINVAL;
+
+		switch (field_type) {
+		case BTF_FIELD_SPIN_LOCK:
+		case BTF_FIELD_TIMER:
+			return btf_find_struct(btf, member_type, off, sz, info);
+		default:
+			return -EFAULT;
+		}
 	}
-	return off;
+	return 0;
 }
 
 static int btf_find_datasec_var(const struct btf *btf, const struct btf_type *t,
-				const char *name, int sz, int align)
+				const char *name, int sz, int align,
+				enum btf_field_type field_type,
+				struct btf_field_info *info)
 {
 	const struct btf_var_secinfo *vsi;
-	u32 i, off = -ENOENT;
+	u32 i, off;
 
 	for_each_vsi(i, t, vsi) {
 		const struct btf_type *var = btf_type_by_id(btf, vsi->type);
 		const struct btf_type *var_type = btf_type_by_id(btf, var->type);
 
-		if (!__btf_type_is_struct(var_type))
-			continue;
-		if (var_type->size != sz)
+		off = vsi->offset;
+
+		if (strcmp(__btf_name_by_offset(btf, var_type->name_off), name))
 			continue;
 		if (vsi->size != sz)
 			continue;
-		if (strcmp(__btf_name_by_offset(btf, var_type->name_off), name))
-			continue;
-		if (off != -ENOENT)
-			/* only one such field is allowed */
-			return -E2BIG;
-		off = vsi->offset;
 		if (off % align)
 			return -EINVAL;
+
+		switch (field_type) {
+		case BTF_FIELD_SPIN_LOCK:
+		case BTF_FIELD_TIMER:
+			return btf_find_struct(btf, var_type, off, sz, info);
+		default:
+			return -EFAULT;
+		}
 	}
-	return off;
+	return 0;
 }
 
 static int btf_find_field(const struct btf *btf, const struct btf_type *t,
-			  const char *name, int sz, int align)
+			  enum btf_field_type field_type,
+			  struct btf_field_info *info)
 {
+	const char *name;
+	int sz, align;
+
+	switch (field_type) {
+	case BTF_FIELD_SPIN_LOCK:
+		name = "bpf_spin_lock";
+		sz = sizeof(struct bpf_spin_lock);
+		align = __alignof__(struct bpf_spin_lock);
+		break;
+	case BTF_FIELD_TIMER:
+		name = "bpf_timer";
+		sz = sizeof(struct bpf_timer);
+		align = __alignof__(struct bpf_timer);
+		break;
+	default:
+		return -EFAULT;
+	}
 
 	if (__btf_type_is_struct(t))
-		return btf_find_struct_field(btf, t, name, sz, align);
+		return btf_find_struct_field(btf, t, name, sz, align, field_type, info);
 	else if (btf_type_is_datasec(t))
-		return btf_find_datasec_var(btf, t, name, sz, align);
+		return btf_find_datasec_var(btf, t, name, sz, align, field_type, info);
 	return -EINVAL;
 }
 
@@ -3237,16 +3287,24 @@ static int btf_find_field(const struct btf *btf, const struct btf_type *t,
  */
 int btf_find_spin_lock(const struct btf *btf, const struct btf_type *t)
 {
-	return btf_find_field(btf, t, "bpf_spin_lock",
-			      sizeof(struct bpf_spin_lock),
-			      __alignof__(struct bpf_spin_lock));
+	struct btf_field_info info = { .off = -ENOENT };
+	int ret;
+
+	ret = btf_find_field(btf, t, BTF_FIELD_SPIN_LOCK, &info);
+	if (ret < 0)
+		return ret;
+	return info.off;
 }
 
 int btf_find_timer(const struct btf *btf, const struct btf_type *t)
 {
-	return btf_find_field(btf, t, "bpf_timer",
-			      sizeof(struct bpf_timer),
-			      __alignof__(struct bpf_timer));
+	struct btf_field_info info = { .off = -ENOENT };
+	int ret;
+
+	ret = btf_find_field(btf, t, BTF_FIELD_TIMER, &info);
+	if (ret < 0)
+		return ret;
+	return info.off;
 }
 
 static void __btf_struct_show(const struct btf *btf, const struct btf_type *t,
-- 
2.35.1



