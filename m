Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036AC23CD56
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 19:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgHERYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 13:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgHERPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 13:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEEF923384;
        Wed,  5 Aug 2020 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596642782;
        bh=55ImbTZSiSPPA9GXLqv9nVZ5RfqFyKFAvaDtqHpltEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJyBkVDYBpCHsPQim5eJPH5kxbTNMbTKgDz1BSe+e52w/FdKSM5r4R3p97xHvis13
         +ll9dwhkYPoUn3xBseo3N1UMnCOteWsDX9F08QAFcZxSC76IEC3hytfsd6top7HIrX
         sSxs0UhKh56n66M7Hsr4I1hwIAx0JyTx9VVnpuX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 9/9] bpf: sockmap: Require attach_bpf_fd when detaching a program
Date:   Wed,  5 Aug 2020 17:52:46 +0200
Message-Id: <20200805153507.468278905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200805153507.053638231@linuxfoundation.org>
References: <20200805153507.053638231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

commit bb0de3131f4c60a9bf976681e0fe4d1e55c7a821 upstream.

The sockmap code currently ignores the value of attach_bpf_fd when
detaching a program. This is contrary to the usual behaviour of
checking that attach_bpf_fd represents the currently attached
program.

Ensure that attach_bpf_fd is indeed the currently attached
program. It turns out that all sockmap selftests already do this,
which indicates that this is unlikely to cause breakage.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200629095630.7933-5-lmb@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bpf.h   |   13 +++++++++++--
 include/linux/skmsg.h |   13 +++++++++++++
 kernel/bpf/syscall.c  |    4 ++--
 net/core/sock_map.c   |   50 +++++++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 71 insertions(+), 9 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -956,11 +956,14 @@ static inline void bpf_map_offload_map_f
 #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
 #if defined(CONFIG_BPF_STREAM_PARSER)
-int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog, u32 which);
+int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
+			 struct bpf_prog *old, u32 which);
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
 #else
 static inline int sock_map_prog_update(struct bpf_map *map,
-				       struct bpf_prog *prog, u32 which)
+				       struct bpf_prog *prog,
+				       struct bpf_prog *old, u32 which)
 {
 	return -EOPNOTSUPP;
 }
@@ -970,6 +973,12 @@ static inline int sock_map_get_from_fd(c
 {
 	return -EINVAL;
 }
+
+static inline int sock_map_prog_detach(const union bpf_attr *attr,
+				       enum bpf_prog_type ptype)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #if defined(CONFIG_XDP_SOCKETS)
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -450,6 +450,19 @@ static inline void psock_set_prog(struct
 		bpf_prog_put(prog);
 }
 
+static inline int psock_replace_prog(struct bpf_prog **pprog,
+				     struct bpf_prog *prog,
+				     struct bpf_prog *old)
+{
+	if (cmpxchg(pprog, old, prog) != old)
+		return -ENOENT;
+
+	if (old)
+		bpf_prog_put(old);
+
+	return 0;
+}
+
 static inline void psock_progs_drop(struct sk_psock_progs *progs)
 {
 	psock_set_prog(&progs->msg_parser, NULL);
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2029,10 +2029,10 @@ static int bpf_prog_detach(const union b
 		ptype = BPF_PROG_TYPE_CGROUP_DEVICE;
 		break;
 	case BPF_SK_MSG_VERDICT:
-		return sock_map_get_from_fd(attr, NULL);
+		return sock_map_prog_detach(attr, BPF_PROG_TYPE_SK_MSG);
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
-		return sock_map_get_from_fd(attr, NULL);
+		return sock_map_prog_detach(attr, BPF_PROG_TYPE_SK_SKB);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_detach(attr);
 	case BPF_FLOW_DISSECTOR:
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -71,7 +71,42 @@ int sock_map_get_from_fd(const union bpf
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
 		return PTR_ERR(map);
-	ret = sock_map_prog_update(map, prog, attr->attach_type);
+	ret = sock_map_prog_update(map, prog, NULL, attr->attach_type);
+	fdput(f);
+	return ret;
+}
+
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype)
+{
+	u32 ufd = attr->target_fd;
+	struct bpf_prog *prog;
+	struct bpf_map *map;
+	struct fd f;
+	int ret;
+
+	if (attr->attach_flags)
+		return -EINVAL;
+
+	f = fdget(ufd);
+	map = __bpf_map_get(f);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	prog = bpf_prog_get(attr->attach_bpf_fd);
+	if (IS_ERR(prog)) {
+		ret = PTR_ERR(prog);
+		goto put_map;
+	}
+
+	if (prog->type != ptype) {
+		ret = -EINVAL;
+		goto put_prog;
+	}
+
+	ret = sock_map_prog_update(map, NULL, prog, attr->attach_type);
+put_prog:
+	bpf_prog_put(prog);
+put_map:
 	fdput(f);
 	return ret;
 }
@@ -1015,27 +1050,32 @@ static struct sk_psock_progs *sock_map_p
 }
 
 int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
-			 u32 which)
+			 struct bpf_prog *old, u32 which)
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
+	struct bpf_prog **pprog;
 
 	if (!progs)
 		return -EOPNOTSUPP;
 
 	switch (which) {
 	case BPF_SK_MSG_VERDICT:
-		psock_set_prog(&progs->msg_parser, prog);
+		pprog = &progs->msg_parser;
 		break;
 	case BPF_SK_SKB_STREAM_PARSER:
-		psock_set_prog(&progs->skb_parser, prog);
+		pprog = &progs->skb_parser;
 		break;
 	case BPF_SK_SKB_STREAM_VERDICT:
-		psock_set_prog(&progs->skb_verdict, prog);
+		pprog = &progs->skb_verdict;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
+	if (old)
+		return psock_replace_prog(pprog, prog, old);
+
+	psock_set_prog(pprog, prog);
 	return 0;
 }
 


