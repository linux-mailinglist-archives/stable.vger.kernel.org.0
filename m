Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894C8F7E2D
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfKKSsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfKKSsP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 438FC21655;
        Mon, 11 Nov 2019 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498094;
        bh=bmUt5fzlbHA27VEy5GRmCFjd3Hsjz9seJVCUPTXPoUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixVS5Joo9FGxB6YjqCUakrVU3q1A9e3T3kO7zl9XrE4hcaqs/kYXHItsJtOLlGwIY
         4k8DGJtJkNvX99U9ms+Ljf00ROa8rnEVe//myRMYtFmboUrdRUDACIDTGltFRGTRtO
         lGVxnSjO/2hFq2aZH0xxH651mKtYZjkga5NOM7z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 020/193] net: prevent load/store tearing on sk->sk_stamp
Date:   Mon, 11 Nov 2019 19:26:42 +0100
Message-Id: <20191111181501.651927021@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f75359f3ac855940c5718af10ba089b8977bf339 ]

Add a couple of READ_ONCE() and WRITE_ONCE() to prevent
load-tearing and store-tearing in sock_read_timestamp()
and sock_write_timestamp()

This might prevent another KCSAN report.

Fixes: 3a0ed3e96197 ("sock: Make sock->sk_stamp thread-safe")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2331,7 +2331,7 @@ static inline ktime_t sock_read_timestam
 
 	return kt;
 #else
-	return sk->sk_stamp;
+	return READ_ONCE(sk->sk_stamp);
 #endif
 }
 
@@ -2342,7 +2342,7 @@ static inline void sock_write_timestamp(
 	sk->sk_stamp = kt;
 	write_sequnlock(&sk->sk_stamp_seq);
 #else
-	sk->sk_stamp = kt;
+	WRITE_ONCE(sk->sk_stamp, kt);
 #endif
 }
 


