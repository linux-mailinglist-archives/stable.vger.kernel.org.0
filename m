Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDBD11B051
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfLKPVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732461AbfLKPVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB66422527;
        Wed, 11 Dec 2019 15:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077692;
        bh=eIdXhAGFn/ispwl6WOaxmFhWcCg+DsVNdF85o1I24SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5Do0nxJJFi7yBZ0DIAbl5DRfcNlViYXa8bdde1DXKwDaWbPvg3NBryeKDEXx4tuK
         uO62km2FSCiLO61VAozxJN3gjmjXcWDWCNZSnCYDu6YKYC/gUnDUxK6GMacOH+oHn+
         qVHmTmY/fptl7FYuBl71fsNDSLlAz60iKATtWln8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/243] bpf: btf: check name validity for various types
Date:   Wed, 11 Dec 2019 16:04:56 +0100
Message-Id: <20191211150348.188128369@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit eb04bbb608e683f8fd3ef7f716e2fa32dd90861f ]

This patch added name checking for the following types:
 . BTF_KIND_PTR, BTF_KIND_ARRAY, BTF_KIND_VOLATILE,
   BTF_KIND_CONST, BTF_KIND_RESTRICT:
     the name must be null
 . BTF_KIND_STRUCT, BTF_KIND_UNION: the struct/member name
     is either null or a valid identifier
 . BTF_KIND_ENUM: the enum type name is either null or a valid
     identifier; the enumerator name must be a valid identifier.
 . BTF_KIND_FWD: the name must be a valid identifier
 . BTF_KIND_TYPEDEF: the name must be a valid identifier

For those places a valid name is required, the name must be
a valid C identifier. This can be relaxed later if we found
use cases for a different (non-C) frontend.

Fixes: 69b693f0aefa ("bpf: btf: Introduce BPF Type Format (BTF)")
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index f0f9109f59bac..3e2413345e718 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1168,6 +1168,22 @@ static int btf_ref_type_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	/* typedef type must have a valid name, and other ref types,
+	 * volatile, const, restrict, should have a null name.
+	 */
+	if (BTF_INFO_KIND(t->info) == BTF_KIND_TYPEDEF) {
+		if (!t->name_off ||
+		    !btf_name_valid_identifier(env->btf, t->name_off)) {
+			btf_verifier_log_type(env, t, "Invalid name");
+			return -EINVAL;
+		}
+	} else {
+		if (t->name_off) {
+			btf_verifier_log_type(env, t, "Invalid name");
+			return -EINVAL;
+		}
+	}
+
 	btf_verifier_log_type(env, t, NULL);
 
 	return 0;
@@ -1325,6 +1341,13 @@ static s32 btf_fwd_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	/* fwd type must have a valid name */
+	if (!t->name_off ||
+	    !btf_name_valid_identifier(env->btf, t->name_off)) {
+		btf_verifier_log_type(env, t, "Invalid name");
+		return -EINVAL;
+	}
+
 	btf_verifier_log_type(env, t, NULL);
 
 	return 0;
@@ -1381,6 +1404,12 @@ static s32 btf_array_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	/* array type should not have a name */
+	if (t->name_off) {
+		btf_verifier_log_type(env, t, "Invalid name");
+		return -EINVAL;
+	}
+
 	if (btf_type_vlen(t)) {
 		btf_verifier_log_type(env, t, "vlen != 0");
 		return -EINVAL;
@@ -1557,6 +1586,13 @@ static s32 btf_struct_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	/* struct type either no name or a valid one */
+	if (t->name_off &&
+	    !btf_name_valid_identifier(env->btf, t->name_off)) {
+		btf_verifier_log_type(env, t, "Invalid name");
+		return -EINVAL;
+	}
+
 	btf_verifier_log_type(env, t, NULL);
 
 	last_offset = 0;
@@ -1568,6 +1604,12 @@ static s32 btf_struct_check_meta(struct btf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		/* struct member either no name or a valid one */
+		if (member->name_off &&
+		    !btf_name_valid_identifier(btf, member->name_off)) {
+			btf_verifier_log_member(env, t, member, "Invalid name");
+			return -EINVAL;
+		}
 		/* A member cannot be in type void */
 		if (!member->type || !BTF_TYPE_ID_VALID(member->type)) {
 			btf_verifier_log_member(env, t, member,
@@ -1755,6 +1797,13 @@ static s32 btf_enum_check_meta(struct btf_verifier_env *env,
 		return -EINVAL;
 	}
 
+	/* enum type either no name or a valid one */
+	if (t->name_off &&
+	    !btf_name_valid_identifier(env->btf, t->name_off)) {
+		btf_verifier_log_type(env, t, "Invalid name");
+		return -EINVAL;
+	}
+
 	btf_verifier_log_type(env, t, NULL);
 
 	for (i = 0; i < nr_enums; i++) {
@@ -1764,6 +1813,14 @@ static s32 btf_enum_check_meta(struct btf_verifier_env *env,
 			return -EINVAL;
 		}
 
+		/* enum member must have a valid name */
+		if (!enums[i].name_off ||
+		    !btf_name_valid_identifier(btf, enums[i].name_off)) {
+			btf_verifier_log_type(env, t, "Invalid name");
+			return -EINVAL;
+		}
+
+
 		btf_verifier_log(env, "\t%s val=%d\n",
 				 btf_name_by_offset(btf, enums[i].name_off),
 				 enums[i].val);
-- 
2.20.1



