Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBCB196B4
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 04:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfEJCd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 22:33:58 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:42816 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfEJCd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 22:33:57 -0400
Received: by mail-qk1-f202.google.com with SMTP id f82so4135438qkb.9
        for <stable@vger.kernel.org>; Thu, 09 May 2019 19:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mGuCACXMov7W3BwH4y6oNYAc9W4ThFxzn4lKrzck6NA=;
        b=Bhj0+d7KDgyGqHThBrOkufEI2ydIenVSEY8DgSAeLumsuRN8vo4MzhIcachz6AwyEw
         aGE4ZU3lnl8gM/tSH1kdsFXSJ7JNbybGZHwe/lDt0IknVsk9mP9q1Gy41xZcOrjKTnET
         ayH5ZhXvTVRa11eXeAZNSy/WIcq8MAPHzHdgAtN67oaAzc6q/CA0y8lF7MxGD7EixfKA
         ck0MjvzImKxxiRe90+GMCg+F9TAbdUKEo3oedtHaDAqxE2r2MdthG0WLGUiy7obfML0L
         +fDstCI/8ne6UoPD/OGGRSqTwvB9alvGwCVCd0YLTi3Y3q0dU6EBV4dZ/YSIUGMnwJWE
         5GQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mGuCACXMov7W3BwH4y6oNYAc9W4ThFxzn4lKrzck6NA=;
        b=lBiRxYZ0/KwxdDmZCoja908GIdhtylRJgra0IsFleIeNfHIOy/iyVJVVzP9JK1+i9B
         akvofo3i59FPsY18mcNESI21gu5vIj9rZdcXTvyUmvkfXB92XQGiA86nnM7JyGSb+Vsi
         m2shCHRgbDrfJSQa1LMncBKtwODVbfOKpjEqUWYDDAvtMe3yF6FJZqP1P8P9fQxhdf67
         4u6wz4/N37h/30/i2fNo0DPtx/GXQdrnXEcgPmVsCw6ifekyIo6KIRsdYQzf9AkkwiAz
         0n6Myaa5amXcqLVlnu6VufKaL66Cweuo3NJbd8EjCt9Ywz7ImEz3SjzkisqslNwt9ley
         LY1A==
X-Gm-Message-State: APjAAAX5c3nRDvalH02wxWNxtb6PF7T5SOTE2rs9kDVn6C63gEwAtfrm
        gVye0k8Dq5j+o01wZzPUoCDRZOs2A6lDzoRgNRqlaXreI3xFx4f3ZrQsqL7uvmeJtHFPzICFzn6
        AqRKq0QsSIKpq8MCBH2LkY8O8+vt401mI2+Gq/9tU37tGvonoF9AF3iAdW+Y=
X-Google-Smtp-Source: APXvYqxQl/7T+fYZ7AIUIusjAzpP6FyPhkZTtsYZGYDiOjx+8zykYmumg8j+bO0hTQJZ5i7VDNi0hPJ9Ow==
X-Received: by 2002:ac8:35fb:: with SMTP id l56mr7123668qtb.130.1557455636895;
 Thu, 09 May 2019 19:33:56 -0700 (PDT)
Date:   Thu,  9 May 2019 19:33:53 -0700
Message-Id: <20190510023354.182171-1-fengc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [stable 4.9.y 1/2] bpf: fix struct htab_elem layout
From:   Chenbo Feng <fengc@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kernel-team@android.com,
        maze@google.com, lorenzo@google.com,
        Jonathan Perry <jonperry@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Chenbo Feng <fengc@google.com>
Content-Type: text/plain; charset="utf-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@fb.com>

commit 9f691549f76d488a0c74397b3e51e943865ea01f upstream.

when htab_elem is removed from the bucket list the htab_elem.hash_node.next
field should not be overridden too early otherwise we have a tiny race window
between lookup and delete.
The bug was discovered by manual code analysis and reproducible
only with explicit udelay() in lookup_elem_raw().

Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
Reported-by: Jonathan Perry <jonperry@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chenbo Feng <fengc@google.com>
---
 kernel/bpf/hashtab.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index a36a532c056d..f9d53ac57f64 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -41,8 +41,13 @@ enum extra_elem_state {
 struct htab_elem {
 	union {
 		struct hlist_node hash_node;
-		struct bpf_htab *htab;
-		struct pcpu_freelist_node fnode;
+		struct {
+			void *padding;
+			union {
+				struct bpf_htab *htab;
+				struct pcpu_freelist_node fnode;
+			};
+		};
 	};
 	union {
 		struct rcu_head rcu;
@@ -114,8 +119,10 @@ static int prealloc_elems_and_freelist(struct bpf_htab *htab)
 	if (err)
 		goto free_elems;
 
-	pcpu_freelist_populate(&htab->freelist, htab->elems, htab->elem_size,
-			       htab->map.max_entries);
+	pcpu_freelist_populate(&htab->freelist,
+			       htab->elems + offsetof(struct htab_elem, fnode),
+			       htab->elem_size, htab->map.max_entries);
+
 	return 0;
 
 free_elems:
@@ -148,6 +155,11 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	int err, i;
 	u64 cost;
 
+	BUILD_BUG_ON(offsetof(struct htab_elem, htab) !=
+		     offsetof(struct htab_elem, hash_node.pprev));
+	BUILD_BUG_ON(offsetof(struct htab_elem, fnode.next) !=
+		     offsetof(struct htab_elem, hash_node.pprev));
+
 	if (attr->map_flags & ~BPF_F_NO_PREALLOC)
 		/* reserved bits should not be used */
 		return ERR_PTR(-EINVAL);
@@ -429,9 +441,13 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 	int err = 0;
 
 	if (prealloc) {
-		l_new = (struct htab_elem *)pcpu_freelist_pop(&htab->freelist);
-		if (!l_new)
+		struct pcpu_freelist_node *l;
+
+		l = pcpu_freelist_pop(&htab->freelist);
+		if (!l)
 			err = -E2BIG;
+		else
+			l_new = container_of(l, struct htab_elem, fnode);
 	} else {
 		if (atomic_inc_return(&htab->count) > htab->map.max_entries) {
 			atomic_dec(&htab->count);
-- 
2.21.0.1020.gf2820cf01a-goog

