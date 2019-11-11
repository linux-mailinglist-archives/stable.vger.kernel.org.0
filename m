Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5FE8F7E30
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfKKSsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbfKKSsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AE120674;
        Mon, 11 Nov 2019 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498114;
        bh=vNa/ksUXJnBe6vrWo5uDxUVxHyDz6ZLyD+1YZGbDsIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlnafMFrWn2qzkByeDuOUKQlyZhAVdjdowwLeyYKWnJ+I/S5rmqm4+9b32/1VkewK
         Wo7kZ4M0+hqHgtNr5PwI4iZnuattOuIkAfbb7pq9rdL9EmyU4WMJJs2fKEykbH1SlS
         SsF0NrVHcWJ73vWKBlird3hm2CePvq6bME1dbfuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 007/193] net/tls: fix sk_msg trim on fallback to copy mode
Date:   Mon, 11 Nov 2019 19:26:29 +0100
Message-Id: <20191111181500.382685090@linuxfoundation.org>
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

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 683916f6a84023407761d843048f1aea486b2612 ]

sk_msg_trim() tries to only update curr pointer if it falls into
the trimmed region. The logic, however, does not take into the
account pointer wrapping that sk_msg_iter_var_prev() does nor
(as John points out) the fact that msg->sg is a ring buffer.

This means that when the message was trimmed completely, the new
curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
neither smaller than any other value, nor would it actually be
correct.

Special case the trimming to 0 length a little bit and rework
the comparison between curr and end to take into account wrapping.

This bug caused the TLS code to not copy all of the message, if
zero copy filled in fewer sg entries than memcopy would need.

Big thanks to Alexander Potapenko for the non-KMSAN reproducer.

v2:
 - take into account that msg->sg is a ring buffer (John).

Link: https://lore.kernel.org/netdev/20191030160542.30295-1-jakub.kicinski@netronome.com/ (v1)

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
Co-developed-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skmsg.h |    9 ++++++---
 net/core/skmsg.c      |   20 +++++++++++++++-----
 2 files changed, 21 insertions(+), 8 deletions(-)

--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(st
 	}
 }
 
+static inline u32 sk_msg_iter_dist(u32 start, u32 end)
+{
+	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
+}
+
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var == 0)				\
@@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const
 	if (sk_msg_full(msg))
 		return MAX_MSG_FRAGS;
 
-	return msg->sg.end >= msg->sg.start ?
-		msg->sg.end - msg->sg.start :
-		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
 
 static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -271,18 +271,28 @@ void sk_msg_trim(struct sock *sk, struct
 
 	msg->sg.data[i].length -= trim;
 	sk_mem_uncharge(sk, trim);
+	/* Adjust copybreak if it falls into the trimmed part of last buf */
+	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
+		msg->sg.copybreak = msg->sg.data[i].length;
 out:
-	/* If we trim data before curr pointer update copybreak and current
-	 * so that any future copy operations start at new copy location.
+	sk_msg_iter_var_next(i);
+	msg->sg.end = i;
+
+	/* If we trim data a full sg elem before curr pointer update
+	 * copybreak and current so that any future copy operations
+	 * start at new copy location.
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >= i) {
+	if (!msg->sg.size) {
+		msg->sg.curr = msg->sg.start;
+		msg->sg.copybreak = 0;
+	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >=
+		   sk_msg_iter_dist(msg->sg.start, msg->sg.end)) {
+		sk_msg_iter_var_prev(i);
 		msg->sg.curr = i;
 		msg->sg.copybreak = msg->sg.data[i].length;
 	}
-	sk_msg_iter_var_next(i);
-	msg->sg.end = i;
 }
 EXPORT_SYMBOL_GPL(sk_msg_trim);
 


