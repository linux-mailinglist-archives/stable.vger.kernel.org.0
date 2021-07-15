Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3F63CAAB1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243163AbhGOTPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:51284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243882AbhGOTMw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5EF6115B;
        Thu, 15 Jul 2021 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376166;
        bh=KOu7qrupT3Xq1MPcezUqH3okfRUfVTjKqiEIPZ1rfEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwubJGljCorCOD2DKWVYtoIK6Jjbsg1t62O5qWe5HAGka8DqjcYvbEghT4AfoT0ls
         kjZ/aKeHrBBgSCag8ePaQg0y855vrw/NMM8NbmNOXinyHdJWTV6dvlQfrXUq0FkUcs
         o65FH2nrLb1zGUTF4BgLkK9/DR8ebmRxAfsDtRzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Martynas Pumputis <m@lambda.lt>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 154/266] net: retrieve netns cookie via getsocketopt
Date:   Thu, 15 Jul 2021 20:38:29 +0200
Message-Id: <20210715182640.308147098@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

[ Upstream commit e8b9eab99232c4e62ada9d7976c80fd5e8118289 ]

It's getting more common to run nested container environments for
testing cloud software. One of such examples is Kind [1] which runs a
Kubernetes cluster in Docker containers on a single host. Each container
acts as a Kubernetes node, and thus can run any Pod (aka container)
inside the former. This approach simplifies testing a lot, as it
eliminates complicated VM setups.

Unfortunately, such a setup breaks some functionality when cgroupv2 BPF
programs are used for load-balancing. The load-balancer BPF program
needs to detect whether a request originates from the host netns or a
container netns in order to allow some access, e.g. to a service via a
loopback IP address. Typically, the programs detect this by comparing
netns cookies with the one of the init ns via a call to
bpf_get_netns_cookie(NULL). However, in nested environments the latter
cannot be used given the Kubernetes node's netns is outside the init ns.
To fix this, we need to pass the Kubernetes node netns cookie to the
program in a different way: by extending getsockopt() with a
SO_NETNS_COOKIE option, the orchestrator which runs in the Kubernetes
node netns can retrieve the cookie and pass it to the program instead.

Thus, this is following up on Eric's commit 3d368ab87cf6 ("net:
initialize net->net_cookie at netns setup") to allow retrieval via
SO_NETNS_COOKIE.  This is also in line in how we retrieve socket cookie
via SO_COOKIE.

  [1] https://kind.sigs.k8s.io/

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Martynas Pumputis <m@lambda.lt>
Cc: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 include/uapi/asm-generic/socket.h     | 2 ++
 net/core/sock.c                       | 7 +++++++
 6 files changed, 17 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 57420356ce4c..6b3daba60987 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -127,6 +127,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 2d949969313b..cdf404a831b2 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -138,6 +138,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index f60904329bbc..5b5351cdcb33 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -119,6 +119,8 @@
 #define SO_PREFER_BUSY_POLL	0x4043
 #define SO_BUSY_POLL_BUDGET	0x4044
 
+#define SO_NETNS_COOKIE		0x4045
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 848a22fbac20..92675dc380fa 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -120,6 +120,8 @@
 #define SO_PREFER_BUSY_POLL	 0x0048
 #define SO_BUSY_POLL_BUDGET	 0x0049
 
+#define SO_NETNS_COOKIE          0x0050
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 4dcd13d097a9..d588c244ec2f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -122,6 +122,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 946888afef88..2003c5ebb4c2 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1622,6 +1622,13 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+	case SO_NETNS_COOKIE:
+		lv = sizeof(u64);
+		if (len != lv)
+			return -EINVAL;
+		v.val64 = sock_net(sk)->net_cookie;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.30.2



