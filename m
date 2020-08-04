Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3536123B707
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 10:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgHDItY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 04:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgHDItX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 04:49:23 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724FEC06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 01:49:23 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so36601619wrl.4
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 01:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AS1L/irQ1SAiuy2bJA12BGGvcMN41EqAyMONdeOJ9tc=;
        b=SNNHBJzw7nzpAcW+yLrJzjJSN14QhzRZ7Tbxoxc4gIys7PqYT41g4aksXqRZzPMqG1
         ArW/prZNev6cryb5bVmP/FVtZONsZr4oOgPdtbrh6+cH1J/Jx4TW3EFnB0WDxITrW7eY
         RCddcTfxynziFhiRVEJPmrRQiV/W3cKOyXcYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AS1L/irQ1SAiuy2bJA12BGGvcMN41EqAyMONdeOJ9tc=;
        b=p8xjQfm+9zCJ6/kusL+Jx0E3GFCujeRxRGh1u9JvkDP9XkIYDqiGOh3M+0BZb5R2nS
         EzYqmHLLTvgcPcLLAsOjEXKixePY5pwJOLf+3uPmkbAhEmTR2ayODVWc2ohUWOx7bWBJ
         kHT2xXTZP3EFo/L6oG/qhHmSZ7e0EpFjWURaAPaRGlDFuprhvfF0nHHgRPeTIoGC8oZb
         IFEKfe+b1fonzkppjrC9TVhxdfXlblVROl6k73CzudKkCZNP78I8cV1m9IC5pIgB9qAo
         xfvY7jp6HllVsDKb/kr1TkEcEgRvFA+nwD+aMzhHaKN9KW3Px4uxQ+rfuCT/h2moZJP1
         KBhg==
X-Gm-Message-State: AOAM533vNRrenZMZLRe9CvVEa205WDYOWvSC9pO2/3b3C2NzmedB8OXV
        7nfIZv7sorBfDKR16p5Dfm9UhOlT+cA=
X-Google-Smtp-Source: ABdhPJwknV03hX6+Le1i0l1o6rQu35IlAxjFFu2vOxUuvhRe2xIIpSQE0rV1onVpnXlud7zp88Cxnw==
X-Received: by 2002:adf:a192:: with SMTP id u18mr20495707wru.158.1596530961625;
        Tue, 04 Aug 2020 01:49:21 -0700 (PDT)
Received: from antares.lan (e.8.0.d.1.c.0.9.4.b.c.4.0.6.d.7.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:7d60:4cb4:90c1:d08e])
        by smtp.gmail.com with ESMTPSA id l21sm3246418wmj.25.2020.08.04.01.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 01:49:20 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH stable-5.4.y] bpf: sockmap: Require attach_bpf_fd when detaching a program
Date:   Tue,  4 Aug 2020 09:47:47 +0100
Message-Id: <20200804084747.42530-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
The 5.4 tree needs a dedicated backport, since some headers have
changed sufficiently to cause the patch to fail. bpf_prog_detach
needs further massaging to pass the correct program type to
sock_map_prog_detach. Please queue this patch together with
commit f43cb0d672aa ("selftests: bpf: Fix detach from sockmap tests").
---
 include/linux/bpf.h   | 13 +++++++++--
 include/linux/skmsg.h | 13 +++++++++++
 kernel/bpf/syscall.c  |  4 ++--
 net/core/sock_map.c   | 50 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3bf3835d0e86..7aa0d8b5aaf0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -956,11 +956,14 @@ static inline void bpf_map_offload_map_free(struct bpf_map *map)
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
@@ -970,6 +973,12 @@ static inline int sock_map_get_from_fd(const union bpf_attr *attr,
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
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 4bdb5e4bbd6a..20f3550b0b11 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -450,6 +450,19 @@ static inline void psock_set_prog(struct bpf_prog **pprog,
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
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8bc904f9badb..bf03d04a9e2f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2029,10 +2029,10 @@ static int bpf_prog_detach(const union bpf_attr *attr)
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
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6bbc118bf00e..df52061f99f7 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -71,7 +71,42 @@ int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog)
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
@@ -1015,27 +1050,32 @@ static struct sk_psock_progs *sock_map_progs(struct bpf_map *map)
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
 
-- 
2.25.1

