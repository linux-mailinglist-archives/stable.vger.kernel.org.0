Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB43ED865
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 06:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfKDFQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 00:16:52 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36584 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbfKDFQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 00:16:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id v19so11367062pfm.3;
        Sun, 03 Nov 2019 21:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6qtAmKZQumPCWdTNh7Nm6J1kpJYm0r9A9tTu1JLDZIM=;
        b=VGCf0ak/vF0hBSGHZTdFP5hHxig4zlP/PlIV4D5nYH4KUoLuK4/AA3Aw5E7vZfSKF4
         Khl+gsQTDdperJmEsR2JV+fXHQlgCbGBa42bLVcMcywEbGfRTZlm+6+p9nw2+o4MRRSc
         EDlXbG64tFnZTCpUsr9tV8qku8F5VkOhORzLwou1lOBZxC5prI2onRRj9YI03CYArvhR
         50qrzsbYWvKcc40EpRS9ei192Ep+SIJps4By+aWBESz39FEWQoFTSlQOMweAtTgrt1yo
         l8KLfZw2eQmtfUpTou1TQiNO0H4DD6l6cDmbFz3cwEYiwi11bBNnQyx8ohZ4dBIOuC7M
         nNMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6qtAmKZQumPCWdTNh7Nm6J1kpJYm0r9A9tTu1JLDZIM=;
        b=sdSWh/bTKaifCgiJcF4q5JYaD3Dl31TVZffJP8uauQUSzVo1sAoqNILLljbeky5BzL
         C7ItzsC4HXmzPbJnIoZbhTjRyCJ+/iX1HVtq2/r7dw2ECpXyh0hxT0cEsVS7R0IdP+En
         rCM2V6DhBXihKnOlunIL6249DrsjkC4w3ytDbmUeRAtnM9CGwdT90e101li3q0euin01
         9yaOQgSd9CVsqQcURk3Pp3K32ePl5I350+aQ2qt4PRrV+p5irXaJWyhDsocpNsedEnhI
         Sixz2GY4uR8O366i2TS9ohcWo8hlaMjrtYkwkPjCuX3DkQusWNwgFCW2k1DSPeLlBOB+
         4J4w==
X-Gm-Message-State: APjAAAVt0oK6kDi7yCzM3EvT5yfE6/hEyxMwuiTTyyKMBtS1hOcsllG0
        yXMGWo04e8w9Iqilack2C2gL4i8i
X-Google-Smtp-Source: APXvYqwgALPbN3K/hq/kKYahPOVux+6S+4oz92PxPrQsTI6g6jBv2cGxvIpPVMdZg0cjV9aSDPIlwA==
X-Received: by 2002:a62:174d:: with SMTP id 74mr28314717pfx.145.1572844610121;
        Sun, 03 Nov 2019 21:16:50 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z18sm15761648pgv.90.2019.11.03.21.16.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Nov 2019 21:16:49 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     stable@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, sashal@kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH linux-4.14.y 2/2] sctp: not bind the socket in sctp_connect
Date:   Mon,  4 Nov 2019 13:16:26 +0800
Message-Id: <b0dd820e7688623d8d727420c3605c4d796d9437.1572844054.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <7eaa2553d3499ac18c1a667ed127920619e29ad3.1572844054.git.lucien.xin@gmail.com>
References: <cover.1572844054.git.lucien.xin@gmail.com>
 <7eaa2553d3499ac18c1a667ed127920619e29ad3.1572844054.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1572844054.git.lucien.xin@gmail.com>
References: <cover.1572844054.git.lucien.xin@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b6c08878e23adb7cc84bdca94d8a944b03f099e ]

Now when sctp_connect() is called with a wrong sa_family, it binds
to a port but doesn't set bp->port, then sctp_get_af_specific will
return NULL and sctp_connect() returns -EINVAL.

Then if sctp_bind() is called to bind to another port, the last
port it has bound will leak due to bp->port is NULL by then.

sctp_connect() doesn't need to bind ports, as later __sctp_connect
will do it if bp->port is NULL. So remove it from sctp_connect().
While at it, remove the unnecessary sockaddr.sa_family len check
as it's already done in sctp_inet_connect.

Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/sctp/socket.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c9c23ca..4045d20 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4168,34 +4168,17 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 static int sctp_connect(struct sock *sk, struct sockaddr *addr,
 			int addr_len, int flags)
 {
-	struct inet_sock *inet = inet_sk(sk);
 	struct sctp_af *af;
-	int err = 0;
+	int err = -EINVAL;
 
 	lock_sock(sk);
-
 	pr_debug("%s: sk:%p, sockaddr:%p, addr_len:%d\n", __func__, sk,
 		 addr, addr_len);
 
-	/* We may need to bind the socket. */
-	if (!inet->inet_num) {
-		if (sk->sk_prot->get_port(sk, 0)) {
-			release_sock(sk);
-			return -EAGAIN;
-		}
-		inet->inet_sport = htons(inet->inet_num);
-	}
-
 	/* Validate addr_len before calling common connect/connectx routine. */
 	af = sctp_get_af_specific(addr->sa_family);
-	if (!af || addr_len < af->sockaddr_len) {
-		err = -EINVAL;
-	} else {
-		/* Pass correct addr len to common routine (so it knows there
-		 * is only one address being passed.
-		 */
+	if (af && addr_len >= af->sockaddr_len)
 		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
-	}
 
 	release_sock(sk);
 	return err;
-- 
2.1.0

