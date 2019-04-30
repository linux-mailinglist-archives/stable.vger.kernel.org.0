Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD40F6F3
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbfD3Lu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731182AbfD3LuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1400821670;
        Tue, 30 Apr 2019 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625022;
        bh=+ebOXy1Dc42e2ylzFgurqpriBg0nrITmuqCC5h/OTV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDA1KWAVK8V86Z2Yi1mUr/3+TuNIsPPvA4XhMAt/ukDW0sODPyfEtUrT7bUJxvGBK
         Vvjo8h5+RkkBEG6Gn3q1C8x1+Yrp4fLfIcWFBTDW9vj/F4ggasJo01ViSDiMB9LoVL
         MPajDpGA3WtzcL6rJ7WHvDeC1kb/3ILNnTkPLG5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+0049bebbf3042dbd2e8f@syzkaller.appspotmail.com>,
        syzbot <syzbot+915c9f99f3dbc4bd6cd1@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 62/89] net/rds: Check address length before reading address family
Date:   Tue, 30 Apr 2019 13:38:53 +0200
Message-Id: <20190430113612.606541047@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit dd3ac9a684358b8c1d5c432ca8322aaf5e4f28ee upstream.

syzbot is reporting uninitialized value at rds_connect() [1] and
rds_bind() [2]. This is because syzbot is passing ulen == 0 whereas
these functions expect that it is safe to access sockaddr->family field
in order to determine minimal address length for validation.

[1] https://syzkaller.appspot.com/bug?id=f4e61c010416c1e6f0fa3ffe247561b60a50ad71
[2] https://syzkaller.appspot.com/bug?id=a4bf9e41b7e055c3823fdcd83e8c58ca7270e38f

Reported-by: syzbot <syzbot+0049bebbf3042dbd2e8f@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+915c9f99f3dbc4bd6cd1@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rds/af_rds.c |    3 +++
 net/rds/bind.c   |    2 ++
 2 files changed, 5 insertions(+)

--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -506,6 +506,9 @@ static int rds_connect(struct socket *so
 	struct rds_sock *rs = rds_sk_to_rs(sk);
 	int ret = 0;
 
+	if (addr_len < offsetofend(struct sockaddr, sa_family))
+		return -EINVAL;
+
 	lock_sock(sk);
 
 	switch (uaddr->sa_family) {
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -173,6 +173,8 @@ int rds_bind(struct socket *sock, struct
 	/* We allow an RDS socket to be bound to either IPv4 or IPv6
 	 * address.
 	 */
+	if (addr_len < offsetofend(struct sockaddr, sa_family))
+		return -EINVAL;
 	if (uaddr->sa_family == AF_INET) {
 		struct sockaddr_in *sin = (struct sockaddr_in *)uaddr;
 


