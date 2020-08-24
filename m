Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E624F4F6
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgHXImz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgHXImz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:42:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FEAB2074D;
        Mon, 24 Aug 2020 08:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258574;
        bh=wjpowUP7dx0cGLzUNx9C8EZ8qkL6/g1Hxp1R20UAaC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZfnhWYv3uDnG9sRiwnFK0CN74KAlBJzzpl5MWR7FxukbxW464Kj3X6+w4gcRgFhZ
         VaCFV2LowxtPGrcJpSWaXRT8bD/nq3+xRGVotjkj+cXkvAKl1dGnNWMs0xikhZcg5T
         qUhoem37xnWK5l1SYzDag7Z0NfD4WjLfR11NJds4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 067/124] tools/bpftool: Make skeleton code C++17-friendly by dropping typeof()
Date:   Mon, 24 Aug 2020 10:30:01 +0200
Message-Id: <20200824082412.715248898@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 8faf7fc597d59b142af41ddd4a2d59485f75f88a ]

Seems like C++17 standard mode doesn't recognize typeof() anymore. This can
be tested by compiling test_cpp test with -std=c++17 or -std=c++1z options.
The use of typeof in skeleton generated code is unnecessary, all types are
well-known at the time of code generation, so remove all typeof()'s to make
skeleton code more future-proof when interacting with C++ compilers.

Fixes: 985ead416df3 ("bpftool: Add skeleton codegen command")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20200812025907.1371956-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/gen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 5ff951e08c740..52ebe400e9ca4 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -402,7 +402,7 @@ static int do_skeleton(int argc, char **argv)
 		{							    \n\
 			struct %1$s *obj;				    \n\
 									    \n\
-			obj = (typeof(obj))calloc(1, sizeof(*obj));	    \n\
+			obj = (struct %1$s *)calloc(1, sizeof(*obj));	    \n\
 			if (!obj)					    \n\
 				return NULL;				    \n\
 			if (%1$s__create_skeleton(obj))			    \n\
@@ -466,7 +466,7 @@ static int do_skeleton(int argc, char **argv)
 		{							    \n\
 			struct bpf_object_skeleton *s;			    \n\
 									    \n\
-			s = (typeof(s))calloc(1, sizeof(*s));		    \n\
+			s = (struct bpf_object_skeleton *)calloc(1, sizeof(*s));\n\
 			if (!s)						    \n\
 				return -1;				    \n\
 			obj->skeleton = s;				    \n\
@@ -484,7 +484,7 @@ static int do_skeleton(int argc, char **argv)
 				/* maps */				    \n\
 				s->map_cnt = %zu;			    \n\
 				s->map_skel_sz = sizeof(*s->maps);	    \n\
-				s->maps = (typeof(s->maps))calloc(s->map_cnt, s->map_skel_sz);\n\
+				s->maps = (struct bpf_map_skeleton *)calloc(s->map_cnt, s->map_skel_sz);\n\
 				if (!s->maps)				    \n\
 					goto err;			    \n\
 			",
@@ -520,7 +520,7 @@ static int do_skeleton(int argc, char **argv)
 				/* programs */				    \n\
 				s->prog_cnt = %zu;			    \n\
 				s->prog_skel_sz = sizeof(*s->progs);	    \n\
-				s->progs = (typeof(s->progs))calloc(s->prog_cnt, s->prog_skel_sz);\n\
+				s->progs = (struct bpf_prog_skeleton *)calloc(s->prog_cnt, s->prog_skel_sz);\n\
 				if (!s->progs)				    \n\
 					goto err;			    \n\
 			",
-- 
2.25.1



