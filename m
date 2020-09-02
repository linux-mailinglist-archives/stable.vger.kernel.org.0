Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4922625AC85
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgIBOGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgIBOGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 10:06:15 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A04C06125C
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 07:05:58 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w1so5050099edr.3
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 07:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XA0itvGjYnK8aMZ/ntGchSFuAR0+T8dcFyodHDzqDg8=;
        b=nQ6hEv6x3CgP/c/7ZY3BuX/W+S4e+0LoVre2WO7I5tvTN7UFjZJGVxy3ItMaqEPJKx
         FYrTFew0RDOtyngN5YD3aa52EQgSJFCMKrgT+9E1BHiNynx6afnvX0nuXVzVghGNKxJE
         mOFxIbdGP51unQsKVf5V9IlufPlSuItGwA5w/pfQLYyiXVSgxi5hvfXGM7hS/uMcujR5
         LpdGr33xaKexkbOiVBE2sW6oYb08C96OFc/JS+gxPOWcH7OHep1ZKmupuN6VgZmWBxcR
         ONjtSTe/UvXaJROfkF+07LeYXG4axejMlSM1tZzR4ihocbnzfRmsi2R4plPwVB8dj8gy
         3fwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XA0itvGjYnK8aMZ/ntGchSFuAR0+T8dcFyodHDzqDg8=;
        b=nd/9P1YWd2KXwmqjQOpPl6NmM7liymRXii6RkMEcogZoEeHPUgX4HpKBI+f00XfvIz
         4UK8EQ8cYy7e6jIjZ1J/ZnPR4Oz10wp5cA9TBjJpfYnF1GGibKIgGkqCEXFNniU6wQYr
         TNJ0kCwKamI5bTu8JfTvwFZRqwtFpKfaNxxlRgbxlw+hEBGzDhffCuFpPgpXd49PqT8i
         Z5E1dx5Xj3bfZF/62jmY0sjU74kD19GlIw3/TdEp46+ovb0dyThCB1iq4RQ0KDDpMqKd
         QzXLebpJKLAILVJuyDRuX5dfMy6HFLpYqdaB6qm7f7yqDHzEW3lZxkxRLZ39vsK5KFwP
         BEMQ==
X-Gm-Message-State: AOAM530+9PUqL8Uc7oLwMfETwJqubmY4r0U1+W9LNzejqHaoCOeA0Gha
        zjAx/y8lHwC6EZsddoZ/2J/PsQ==
X-Google-Smtp-Source: ABdhPJy7R4U182YRDBG2sERiWglLUkFWprqYJKj0N+dXKaNcxbbuLY70iGi6rJY5Wdyej/Arwm0MjQ==
X-Received: by 2002:aa7:d805:: with SMTP id v5mr226233edq.29.1599055557546;
        Wed, 02 Sep 2020 07:05:57 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14oqa3w7cibjsc.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:8cba:3abe:17e1:aaec])
        by smtp.gmail.com with ESMTPSA id r15sm4119296edv.94.2020.09.02.07.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:05:56 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        matthieu.baerts@tessares.net, davem@davemloft.net,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
Subject: [PATCH 4.9 1/2] net: refactor bind_bucket fastreuse into helper
Date:   Wed,  2 Sep 2020 16:05:44 +0200
Message-Id: <20200902140545.867718-2-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200902140545.867718-1-tim.froidcoeur@tessares.net>
References: <20200902140545.867718-1-tim.froidcoeur@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62ffc589abb176821662efc4525ee4ac0b9c3894 ]

Refactor the fastreuse update code in inet_csk_get_port into a small
helper function that can be called from other places.

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tim Froidcoeur <tim.froidcoeur@tessares.net>
---
 include/net/inet_connection_sock.h |  4 ++++
 net/ipv4/inet_connection_sock.c    | 37 ++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 146054ceea8e..5bb56ebf3c9f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -319,5 +319,9 @@ int inet_csk_compat_getsockopt(struct sock *sk, int level, int optname,
 int inet_csk_compat_setsockopt(struct sock *sk, int level, int optname,
 			       char __user *optval, unsigned int optlen);
 
+/* update the fast reuse flag when adding a socket */
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk);
+
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 #endif /* _INET_CONNECTION_SOCK_H */
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1bcbb7399fe6..5a0352ccadd3 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -89,6 +89,28 @@ int inet_csk_bind_conflict(const struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(inet_csk_bind_conflict);
 
+void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
+			       struct sock *sk)
+{
+	kuid_t uid = sock_i_uid(sk);
+	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
+
+	if (!hlist_empty(&tb->owners)) {
+		if (!reuse)
+			tb->fastreuse = 0;
+		if (!sk->sk_reuseport || !uid_eq(tb->fastuid, uid))
+			tb->fastreuseport = 0;
+	} else {
+		tb->fastreuse = reuse;
+		if (sk->sk_reuseport) {
+			tb->fastreuseport = 1;
+			tb->fastuid = uid;
+		} else {
+			tb->fastreuseport = 0;
+		}
+	}
+}
+
 /* Obtain a reference to a local port for the given sock,
  * if snum is zero it means select any available local port.
  * We try to allocate an odd port (and leave even ports for connect())
@@ -218,19 +240,10 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 			}
 			goto fail_unlock;
 		}
-		if (!reuse)
-			tb->fastreuse = 0;
-		if (!sk->sk_reuseport || !uid_eq(tb->fastuid, uid))
-			tb->fastreuseport = 0;
-	} else {
-		tb->fastreuse = reuse;
-		if (sk->sk_reuseport) {
-			tb->fastreuseport = 1;
-			tb->fastuid = uid;
-		} else {
-			tb->fastreuseport = 0;
-		}
 	}
+
+	inet_csk_update_fastreuse(tb, sk);
+
 success:
 	if (!inet_csk(sk)->icsk_bind_hash)
 		inet_bind_hash(sk, tb, port);
-- 
2.25.1

