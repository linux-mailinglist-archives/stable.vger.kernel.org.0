Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82556C54DF
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjCVT1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCVT1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:27:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2713A61897
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:27:15 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54476ef9caeso196966737b3.6
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 12:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679513234;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UeljaMbrYowDE1Cxic6lC5QNfHUvovTIoCgMIMHnPzE=;
        b=BIeQ8L3OT/6Kdf/DG7/S9W1w3khEqij0Yl8BmlHQAFaFd8tJOEXDrfPBVl5H2PYCtn
         D9jVhnca8kzD3AL0MVgRDJ+4zrPcBH0/9De9cij1b1wzHsO/gdOCzH8RuHk6AG9N9z/Q
         OIu+88VT0utfOYiJeeBEV/0MBu3sM4LQFjZujn4NLuGWzRtmwzRB9t5bibMHcyzzFusu
         OZD/JsheIgPu7/32Y8OHP7X5ZjplmCFuS2nWlerZ6ACsu2ysMB4pR1bgxMHWRqjrc6I2
         VSlScNEa4KybdbtdSwD6Ez7GH52uyeejXi2N5q6oOXCtzvUDn58AOoHOCLhwk8L5yrib
         EZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679513234;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UeljaMbrYowDE1Cxic6lC5QNfHUvovTIoCgMIMHnPzE=;
        b=LcvrufbH0MAIc0z27UBXX5KC72dBQpiDm/4ysjCrIttmf5YLlAIJz0sksohs8GNivP
         +W1HzuES2VgI+f1/IewChs897RqKupxuVHXmpuruXHn3j03j2Dtg8JhE3g8fAzS2asYH
         HjBATzcVTyn4hQ4/hoLnSr33ARLrPz7ylhhashEybQPxgAp4iw+S4QzxhR//IBU/58ra
         /A1RRleiSJZbhSC3f6TJjbsGux5WZVh08tDImGRzd0j6kRFyTZIF6IIbqhXeGiB6m/83
         iXzJSQkw0NMf4WUb4t20oZGX+DPfdginQw5JjM3UX3zzNkWwXilxpMcRPYYlyADp/5iE
         HwgQ==
X-Gm-Message-State: AAQBX9ekU+oCpgovCmLrjPf7XHyhlWd/hjkwtsO59kR/u5TckDiUwJxm
        N4W69/vm2HIhgXMZRmiRdFukQrJE
X-Google-Smtp-Source: AKy350bWFg6b4GPNRvCqwrqtndJNzG1ivB42ueKqA4MJZKNC2AoQwvvQyR4Mirxj59iyxY96tpd8beJX
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:5edb:8d65:29d7:ad1])
 (user=maze job=sendgmr) by 2002:a05:6902:1586:b0:b6c:a94:9bf3 with SMTP id
 k6-20020a056902158600b00b6c0a949bf3mr592548ybu.9.1679513234455; Wed, 22 Mar
 2023 12:27:14 -0700 (PDT)
Date:   Wed, 22 Mar 2023 12:27:09 -0700
In-Reply-To: <ZBtVXJVi/zKb8eAk@kroah.com>
Message-Id: <20230322192709.4020826-1-maze@google.com>
Mime-Version: 1.0
References: <ZBtVXJVi/zKb8eAk@kroah.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Subject: [PATCH] net: retrieve netns cookie via getsocketopt
From:   "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To:     "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Martynas Pumputis <m@lambda.lt>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

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
(cherry picked from commit e8b9eab99232c4e62ada9d7976c80fd5e8118289)
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 include/uapi/asm-generic/socket.h     | 2 ++
 net/core/sock.c                       | 7 +++++++
 6 files changed, 17 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index de6c4df61082..d033d3f92d6d 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -124,6 +124,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d0a9ed2ca2d6..ff3ab771e769 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -135,6 +135,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 10173c32195e..1a8ec3838c9b 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -116,6 +116,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 0x4042
 
+#define SO_NETNS_COOKIE		0x4045
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 8029b681fc7c..08f9bbbf5bf2 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -117,6 +117,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF  0x0047
 
+#define SO_NETNS_COOKIE          0x0050
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..645606824258 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 0506590b016b..64e2f9fb6552 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1613,6 +1613,13 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+	case SO_NETNS_COOKIE:
+		lv = sizeof(u64);
+		if (len != lv)
+			return -EINVAL;
+		v.val64 = atomic64_read(&sock_net(sk)->net_cookie);
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.40.0.rc1.284.g88254d51c5-goog

