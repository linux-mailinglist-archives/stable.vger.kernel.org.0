Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB95CBCA
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGBIEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727666AbfGBIEW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:04:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC00D2184B;
        Tue,  2 Jul 2019 08:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054660;
        bh=nRWT1tHJ/XCeGdGOny/JULyu5SEAfWbYc80MMCIqRas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cxif5PVEfMleGwh1td4g9dzWs1qNDhtsxy6WqRSnGkM15ZmK+EgDjshEhO0UJy+Xv
         qNmM4mZZqtvnW/ha84tj2ly7vlaz7+iAQt2Jc7mZ4nR4cyL2JEx+nI5Qz4sBzTXNja
         0YegvW2QtXs+8D4qtzxYJAGA/lRynXAZGPezvZmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Martynas Pumputis <m@lambda.lt>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.1 47/55] bpf: fix unconnected udp hooks
Date:   Tue,  2 Jul 2019 10:01:55 +0200
Message-Id: <20190702080126.534694834@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.103022729@linuxfoundation.org>
References: <20190702080124.103022729@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 983695fa676568fc0fe5ddd995c7267aabc24632 upstream.

Intention of cgroup bind/connect/sendmsg BPF hooks is to act transparently
to applications as also stated in original motivation in 7828f20e3779 ("Merge
branch 'bpf-cgroup-bind-connect'"). When recently integrating the latter
two hooks into Cilium to enable host based load-balancing with Kubernetes,
I ran into the issue that pods couldn't start up as DNS got broken. Kubernetes
typically sets up DNS as a service and is thus subject to load-balancing.

Upon further debugging, it turns out that the cgroupv2 sendmsg BPF hooks API
is currently insufficient and thus not usable as-is for standard applications
shipped with most distros. To break down the issue we ran into with a simple
example:

  # cat /etc/resolv.conf
  nameserver 147.75.207.207
  nameserver 147.75.207.208

For the purpose of a simple test, we set up above IPs as service IPs and
transparently redirect traffic to a different DNS backend server for that
node:

  # cilium service list
  ID   Frontend            Backend
  1    147.75.207.207:53   1 => 8.8.8.8:53
  2    147.75.207.208:53   1 => 8.8.8.8:53

The attached BPF program is basically selecting one of the backends if the
service IP/port matches on the cgroup hook. DNS breaks here, because the
hooks are not transparent enough to applications which have built-in msg_name
address checks:

  # nslookup 1.1.1.1
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  [...]
  ;; connection timed out; no servers could be reached

  # dig 1.1.1.1
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
  ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
  [...]

  ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
  ;; global options: +cmd
  ;; connection timed out; no servers could be reached

For comparison, if none of the service IPs is used, and we tell nslookup
to use 8.8.8.8 directly it works just fine, of course:

  # nslookup 1.1.1.1 8.8.8.8
  1.1.1.1.in-addr.arpa	name = one.one.one.one.

In order to fix this and thus act more transparent to the application,
this needs reverse translation on recvmsg() side. A minimal fix for this
API is to add similar recvmsg() hooks behind the BPF cgroups static key
such that the program can track state and replace the current sockaddr_in{,6}
with the original service IP. From BPF side, this basically tracks the
service tuple plus socket cookie in an LRU map where the reverse NAT can
then be retrieved via map value as one example. Side-note: the BPF cgroups
static key should be converted to a per-hook static key in future.

Same example after this fix:

  # cilium service list
  ID   Frontend            Backend
  1    147.75.207.207:53   1 => 8.8.8.8:53
  2    147.75.207.208:53   1 => 8.8.8.8:53

Lookups work fine now:

  # nslookup 1.1.1.1
  1.1.1.1.in-addr.arpa    name = one.one.one.one.

  Authoritative answers can be found from:

  # dig 1.1.1.1

  ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
  ;; global options: +cmd
  ;; Got answer:
  ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 51550
  ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

  ;; OPT PSEUDOSECTION:
  ; EDNS: version: 0, flags:; udp: 512
  ;; QUESTION SECTION:
  ;1.1.1.1.                       IN      A

  ;; AUTHORITY SECTION:
  .                       23426   IN      SOA     a.root-servers.net. nstld.verisign-grs.com. 2019052001 1800 900 604800 86400

  ;; Query time: 17 msec
  ;; SERVER: 147.75.207.207#53(147.75.207.207)
  ;; WHEN: Tue May 21 12:59:38 UTC 2019
  ;; MSG SIZE  rcvd: 111

And from an actual packet level it shows that we're using the back end
server when talking via 147.75.207.20{7,8} front end:

  # tcpdump -i any udp
  [...]
  12:59:52.698732 IP foo.42011 > google-public-dns-a.google.com.domain: 18803+ PTR? 1.1.1.1.in-addr.arpa. (38)
  12:59:52.698735 IP foo.42011 > google-public-dns-a.google.com.domain: 18803+ PTR? 1.1.1.1.in-addr.arpa. (38)
  12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 18803 1/0/0 PTR one.one.one.one. (67)
  12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 18803 1/0/0 PTR one.one.one.one. (67)
  [...]

In order to be flexible and to have same semantics as in sendmsg BPF
programs, we only allow return codes in [1,1] range. In the sendmsg case
the program is called if msg->msg_name is present which can be the case
in both, connected and unconnected UDP.

The former only relies on the sockaddr_in{,6} passed via connect(2) if
passed msg->msg_name was NULL. Therefore, on recvmsg side, we act in similar
way to call into the BPF program whenever a non-NULL msg->msg_name was
passed independent of sk->sk_state being TCP_ESTABLISHED or not. Note
that for TCP case, the msg->msg_name is ignored in the regular recvmsg
path and therefore not relevant.

For the case of ip{,v6}_recv_error() paths, picked up via MSG_ERRQUEUE,
the hook is not called. This is intentional as it aligns with the same
semantics as in case of TCP cgroup BPF hooks right now. This might be
better addressed in future through a different bpf_attach_type such
that this case can be distinguished from the regular recvmsg paths,
for example.

Fixes: 1cedee13d25a ("bpf: Hooks for sys_sendmsg")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrey Ignatov <rdna@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf-cgroup.h |    8 ++++++++
 include/uapi/linux/bpf.h   |    2 ++
 kernel/bpf/syscall.c       |    8 ++++++++
 kernel/bpf/verifier.c      |   12 ++++++++----
 net/core/filter.c          |    2 ++
 net/ipv4/udp.c             |    4 ++++
 net/ipv6/udp.c             |    4 ++++
 7 files changed, 36 insertions(+), 4 deletions(-)

--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -230,6 +230,12 @@ int bpf_percpu_cgroup_storage_update(str
 #define BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk, uaddr, t_ctx)		       \
 	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP6_SENDMSG, t_ctx)
 
+#define BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk, uaddr)			\
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP4_RECVMSG, NULL)
+
+#define BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk, uaddr)			\
+	BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, BPF_CGROUP_UDP6_RECVMSG, NULL)
+
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops)				       \
 ({									       \
 	int __ret = 0;							       \
@@ -319,6 +325,8 @@ static inline int bpf_percpu_cgroup_stor
 #define BPF_CGROUP_RUN_PROG_INET6_CONNECT_LOCK(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_UDP4_SENDMSG_LOCK(sk, uaddr, t_ctx) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk, uaddr, t_ctx) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk, uaddr) ({ 0; })
+#define BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk, uaddr) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_SOCK_OPS(sock_ops) ({ 0; })
 #define BPF_CGROUP_RUN_PROG_DEVICE_CGROUP(type,major,minor,access) ({ 0; })
 
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -187,6 +187,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_SENDMSG,
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
+	BPF_CGROUP_UDP4_RECVMSG = 19,
+	BPF_CGROUP_UDP6_RECVMSG,
 	__MAX_BPF_ATTACH_TYPE
 };
 
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1520,6 +1520,8 @@ bpf_prog_load_check_attach_type(enum bpf
 		case BPF_CGROUP_INET6_CONNECT:
 		case BPF_CGROUP_UDP4_SENDMSG:
 		case BPF_CGROUP_UDP6_SENDMSG:
+		case BPF_CGROUP_UDP4_RECVMSG:
+		case BPF_CGROUP_UDP6_RECVMSG:
 			return 0;
 		default:
 			return -EINVAL;
@@ -1809,6 +1811,8 @@ static int bpf_prog_attach(const union b
 	case BPF_CGROUP_INET6_CONNECT:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
 		break;
 	case BPF_CGROUP_SOCK_OPS:
@@ -1891,6 +1895,8 @@ static int bpf_prog_detach(const union b
 	case BPF_CGROUP_INET6_CONNECT:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
 		break;
 	case BPF_CGROUP_SOCK_OPS:
@@ -1939,6 +1945,8 @@ static int bpf_prog_query(const union bp
 	case BPF_CGROUP_INET6_CONNECT:
 	case BPF_CGROUP_UDP4_SENDMSG:
 	case BPF_CGROUP_UDP6_SENDMSG:
+	case BPF_CGROUP_UDP4_RECVMSG:
+	case BPF_CGROUP_UDP6_RECVMSG:
 	case BPF_CGROUP_SOCK_OPS:
 	case BPF_CGROUP_DEVICE:
 		break;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5145,9 +5145,12 @@ static int check_return_code(struct bpf_
 	struct tnum range = tnum_range(0, 1);
 
 	switch (env->prog->type) {
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+		if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
+		    env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG)
+			range = tnum_range(1, 1);
 	case BPF_PROG_TYPE_CGROUP_SKB:
 	case BPF_PROG_TYPE_CGROUP_SOCK:
-	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
 	case BPF_PROG_TYPE_SOCK_OPS:
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 		break;
@@ -5163,16 +5166,17 @@ static int check_return_code(struct bpf_
 	}
 
 	if (!tnum_in(range, reg->var_off)) {
+		char tn_buf[48];
+
 		verbose(env, "At program exit the register R0 ");
 		if (!tnum_is_unknown(reg->var_off)) {
-			char tn_buf[48];
-
 			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
 			verbose(env, "has value %s", tn_buf);
 		} else {
 			verbose(env, "has unknown scalar value");
 		}
-		verbose(env, " should have been 0 or 1\n");
+		tnum_strn(tn_buf, sizeof(tn_buf), range);
+		verbose(env, " should have been in %s\n", tn_buf);
 		return -EINVAL;
 	}
 	return 0;
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6420,6 +6420,7 @@ static bool sock_addr_is_valid_access(in
 		case BPF_CGROUP_INET4_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_UDP4_SENDMSG:
+		case BPF_CGROUP_UDP4_RECVMSG:
 			break;
 		default:
 			return false;
@@ -6430,6 +6431,7 @@ static bool sock_addr_is_valid_access(in
 		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET6_CONNECT:
 		case BPF_CGROUP_UDP6_SENDMSG:
+		case BPF_CGROUP_UDP6_RECVMSG:
 			break;
 		default:
 			return false;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1783,6 +1783,10 @@ try_again:
 		sin->sin_addr.s_addr = ip_hdr(skb)->saddr;
 		memset(sin->sin_zero, 0, sizeof(sin->sin_zero));
 		*addr_len = sizeof(*sin);
+
+		if (cgroup_bpf_enabled)
+			BPF_CGROUP_RUN_PROG_UDP4_RECVMSG_LOCK(sk,
+							(struct sockaddr *)sin);
 	}
 
 	if (udp_sk(sk)->gro_enabled)
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -370,6 +370,10 @@ try_again:
 						    inet6_iif(skb));
 		}
 		*addr_len = sizeof(*sin6);
+
+		if (cgroup_bpf_enabled)
+			BPF_CGROUP_RUN_PROG_UDP6_RECVMSG_LOCK(sk,
+						(struct sockaddr *)sin6);
 	}
 
 	if (udp_sk(sk)->gro_enabled)


