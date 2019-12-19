Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A652126AB4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfLSSuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:50:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:43908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729601AbfLSSuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE28A24689;
        Thu, 19 Dec 2019 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781408;
        bh=KUMq2bnslT2h33XymdmU23jdbu9sjJMHQecNtRrgTU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zf4lXDaHJZlBpYmcuQVBbx0yjkzzliWe9hgkwwL2FA8DYMbzave8iIdRJRtSsqj9a
         3kt/0hOSw+V1irXGr7xAJpop7fpq3eAwRn9AM1gg5P1oHUxKjHuA4qONhOmUJDxuV6
         zUV6I0bMGB2auYSBwvZxbr8anpKIumAqbfgunHfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 10/36] tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()
Date:   Thu, 19 Dec 2019 19:34:27 +0100
Message-Id: <20191219182856.768968365@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 721c8dafad26ccfa90ff659ee19755e3377b829d ]

Syncookies borrow the ->rx_opt.ts_recent_stamp field to store the
timestamp of the last synflood. Protect them with READ_ONCE() and
WRITE_ONCE() since reads and writes aren't serialised.

Use of .rx_opt.ts_recent_stamp for storing the synflood timestamp was
introduced by a0f82f64e269 ("syncookies: remove last_synq_overflow from
struct tcp_sock"). But unprotected accesses were already there when
timestamp was stored in .last_synq_overflow.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -500,17 +500,17 @@ struct sock *cookie_v4_check(struct sock
  */
 static inline void tcp_synq_overflow(const struct sock *sk)
 {
-	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	unsigned long last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 	unsigned long now = jiffies;
 
 	if (!time_between32(now, last_overflow, last_overflow + HZ))
-		tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
+		WRITE_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp, now);
 }
 
 /* syncookies: no recent synqueue overflow on this listening socket? */
 static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
 {
-	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	unsigned long last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 
 	/* If last_overflow <= jiffies <= last_overflow + TCP_SYNCOOKIE_VALID,
 	 * then we're under synflood. However, we have to use


