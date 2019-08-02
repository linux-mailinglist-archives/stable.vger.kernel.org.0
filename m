Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D447F392
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406744AbfHBJ60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406993AbfHBJ5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 761DB2064A;
        Fri,  2 Aug 2019 09:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739873;
        bh=Lb/WH7nAb3QrLSpwl5l5ok2QhABYzpciuz1j6ldGmbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wazmnBeYRm1vmI/xFOByp9oqwGoYMoRvK1MLcWm4dA3M50k/UpuYm9GG9f5vh9p+u
         alWWlWqw2iQI3Ov4FuB4EhoGe9Zuk+W7mFZOIIAe22HdBG5qEJC67/Txa341TJlnxc
         nEHoahPEF7e+UFlwJoAMfQtj4cBnpBTmOHqDLDvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.2 04/20] bpf: fix NULL deref in btf_type_is_resolve_source_only
Date:   Fri,  2 Aug 2019 11:39:58 +0200
Message-Id: <20190802092058.345293259@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

commit e4f07120210a1794c1f1ae64d209a2fbc7bd2682 upstream.

Commit 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
added invocations of btf_type_is_resolve_source_only before
btf_type_nosize_or_null which checks for the NULL pointer.
Swap the order of btf_type_nosize_or_null and
btf_type_is_resolve_source_only to make sure the do the NULL pointer
check first.

Fixes: 1dc92851849c ("bpf: kernel side support for BTF Var and DataSec")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/btf.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1928,8 +1928,8 @@ static int btf_array_resolve(struct btf_
 	/* Check array->index_type */
 	index_type_id = array->index_type;
 	index_type = btf_type_by_id(btf, index_type_id);
-	if (btf_type_is_resolve_source_only(index_type) ||
-	    btf_type_nosize_or_null(index_type)) {
+	if (btf_type_nosize_or_null(index_type) ||
+	    btf_type_is_resolve_source_only(index_type)) {
 		btf_verifier_log_type(env, v->t, "Invalid index");
 		return -EINVAL;
 	}
@@ -1948,8 +1948,8 @@ static int btf_array_resolve(struct btf_
 	/* Check array->type */
 	elem_type_id = array->type;
 	elem_type = btf_type_by_id(btf, elem_type_id);
-	if (btf_type_is_resolve_source_only(elem_type) ||
-	    btf_type_nosize_or_null(elem_type)) {
+	if (btf_type_nosize_or_null(elem_type) ||
+	    btf_type_is_resolve_source_only(elem_type)) {
 		btf_verifier_log_type(env, v->t,
 				      "Invalid elem");
 		return -EINVAL;
@@ -2170,8 +2170,8 @@ static int btf_struct_resolve(struct btf
 		const struct btf_type *member_type = btf_type_by_id(env->btf,
 								member_type_id);
 
-		if (btf_type_is_resolve_source_only(member_type) ||
-		    btf_type_nosize_or_null(member_type)) {
+		if (btf_type_nosize_or_null(member_type) ||
+		    btf_type_is_resolve_source_only(member_type)) {
 			btf_verifier_log_member(env, v->t, member,
 						"Invalid member");
 			return -EINVAL;


