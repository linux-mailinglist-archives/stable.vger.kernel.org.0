Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF1E11B520
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732472AbfLKPVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732466AbfLKPVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A31022527;
        Wed, 11 Dec 2019 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077694;
        bh=YHffAVzO53Mk2+ObzZ0K8rxtywwRmIrlOpEu3DE0RqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNk0NlWS0/JydKNwB0L5oGo2FSEiuqPhyPZi7gmgEC+Myhh5S2XL/JkbeYsZE27Gv
         G5X+67tmf76AMdyzdRjn+98Drk6PpRxHjnQ0NkGK75wCARBjLslYUgFeZf9RoHKLY5
         FIlu0/+TmV2FmiGLMy5Rqas0DM9VkbdgMwb6r7cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 135/243] tools: bpftool: fix a bitfield pretty print issue
Date:   Wed, 11 Dec 2019 16:04:57 +0100
Message-Id: <20191211150348.264327551@linuxfoundation.org>
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

[ Upstream commit 528bff0cdb6649f97f2c4802e4ac7a4b50645f2f ]

Commit b12d6ec09730 ("bpf: btf: add btf print functionality")
added btf pretty print functionality to bpftool.
There is a problem though in printing a bitfield whose type
has modifiers.

For example, for a type like
  typedef int ___int;
  struct tmp_t {
          int a:3;
          ___int b:3;
  };
Suppose we have a map
  struct bpf_map_def SEC("maps") tmpmap = {
          .type = BPF_MAP_TYPE_HASH,
          .key_size = sizeof(__u32),
          .value_size = sizeof(struct tmp_t),
          .max_entries = 1,
  };
and the hash table is populated with one element with
key 0 and value (.a = 1 and .b = 2).

In BTF, the struct member "b" will have a type "typedef" which
points to an int type. The current implementation does not
pass the bit offset during transition from typedef to int type,
hence incorrectly print the value as
  $ bpftool m d id 79
  [{
          "key": 0,
          "value": {
              "a": 0x1,
              "b": 0x1
          }
      }
  ]

This patch fixed the issue by carrying bit_offset along the type
chain during bit_field print. The correct result can be printed as
  $ bpftool m d id 76
  [{
          "key": 0,
          "value": {
              "a": 0x1,
              "b": 0x2
          }
      }
  ]

The kernel pretty print is implemented correctly and does not
have this issue.

Fixes: b12d6ec09730 ("bpf: btf: add btf print functionality")
Signed-off-by: Yonghong Song <yhs@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf_dumper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 55bc512a18318..e4e6e2b3fd847 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -32,7 +32,7 @@ static void btf_dumper_ptr(const void *data, json_writer_t *jw,
 }
 
 static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
-			       const void *data)
+			       __u8 bit_offset, const void *data)
 {
 	int actual_type_id;
 
@@ -40,7 +40,7 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
 	if (actual_type_id < 0)
 		return actual_type_id;
 
-	return btf_dumper_do_type(d, actual_type_id, 0, data);
+	return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
 }
 
 static void btf_dumper_enum(const void *data, json_writer_t *jw)
@@ -237,7 +237,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
 	case BTF_KIND_VOLATILE:
 	case BTF_KIND_CONST:
 	case BTF_KIND_RESTRICT:
-		return btf_dumper_modifier(d, type_id, data);
+		return btf_dumper_modifier(d, type_id, bit_offset, data);
 	default:
 		jsonw_printf(d->jw, "(unsupported-kind");
 		return -EINVAL;
-- 
2.20.1



