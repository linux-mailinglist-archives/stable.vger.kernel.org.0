Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3690123694
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfLQUKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbfLQUKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B321E24682;
        Tue, 17 Dec 2019 20:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613432;
        bh=dlQpLBRe8TK1LcBNEIdw9PoCk0gC0VXWyhPJAdiQzBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C5NSCAKpaS8jIjf5D51jgmNGLti7YfNiAbIPW2kEOhCzh0LwrgN9K8+cocA35X4L5
         MzDKcqbx2XgJiOqOEw0h3tBXY9AFziVZulcEh4ghEWvvrYOE8nN+7faerm+J5f3Ums
         93iLS1apZddVxlQWGUcp6qGqGgFEdKMyZ3Qlda5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 19/37] tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()
Date:   Tue, 17 Dec 2019 21:09:40 +0100
Message-Id: <20191217200727.666289371@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
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
@@ -501,9 +501,9 @@ static inline void tcp_synq_overflow(con
 		}
 	}
 
-	last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 	if (!time_between32(now, last_overflow, last_overflow + HZ))
-		tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
+		WRITE_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp, now);
 }
 
 /* syncookies: no recent synqueue overflow on this listening socket? */
@@ -524,7 +524,7 @@ static inline bool tcp_synq_no_recent_ov
 		}
 	}
 
-	last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	last_overflow = READ_ONCE(tcp_sk(sk)->rx_opt.ts_recent_stamp);
 
 	/* If last_overflow <= jiffies <= last_overflow + TCP_SYNCOOKIE_VALID,
 	 * then we're under synflood. However, we have to use


