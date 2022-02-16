Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2756F4B816E
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 08:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiBPHWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 02:22:54 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiBPHWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 02:22:52 -0500
X-Greylist: delayed 572 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 23:22:36 PST
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25EAD5
        for <stable@vger.kernel.org>; Tue, 15 Feb 2022 23:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644993151;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=XW7Vp0hhhdyNox3vT96fEpwyFA9OtgyB00lFK37Dzyw=;
    b=Sd/s4sCa+p1qIJYYMwuXDmvV8DLVSjQZSMq41baUUkkM7d0DQjs0UIguQhvS5XSyzg
    ozP2aBU5rs/+5Wj/LK7VWXr0by066Vr6cLe/l2/x2stf+G8Q3J1rwVbhBdaorjno/Skk
    zFZIGpWFvWr10lj/wJumdf4hyLqAlqW36rQnb0YFbj7hsstut/sTxh/qyISKOfy9SsFO
    saYcf8sEmasRA64rh35LFNn0LQe+6rxQHmBd0QQjSOFCRoNMo67Xp22dtcAreeFzoeMI
    YBpbmdG+rzwxQwuEkWG15D0rt33H+LiIur01CZIDwOcEpQZCqzHuNIzXj+hf7I3hky22
    H5xg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy1G6WUfoi
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 16 Feb 2022 07:32:30 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [BACKPORT stable Linux-5.10.y 1/2] can: isotp: prevent race between isotp_bind() and isotp_setsockopt()
Date:   Wed, 16 Feb 2022 07:31:36 +0100
Message-Id: <20220216063137.2023-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Upstream commit 2b17c400aeb44daf041627722581ade527bb3c1d

The fixes tag of the uptream patch points to commit 921ca574cd38 ("can:
isotp: add SF_BROADCAST support for functional addressing") which showed
up in Linux 5.11 but the described issue already existed in Linux 5.10.

Norbert Slusarek writes:

A race condition was found in isotp_setsockopt() which allows to
change socket options after the socket was bound.
For the specific case of SF_BROADCAST support, this might lead to possible
use-after-free because can_rx_unregister() is not called.

Checking for the flag under the socket lock in isotp_bind() and taking
the lock in isotp_setsockopt() fixes the issue.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/r/trinity-e6ae9efa-9afb-4326-84c0-f3609b9b8168-1620773528307@3c-app-gmx-bs06
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 37db4d232313..3f11d2b314b6 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1191,20 +1191,17 @@ static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	addr->can_addr.tp.tx_id = so->txid;
 
 	return ISOTP_MIN_NAMELEN;
 }
 
-static int isotp_setsockopt(struct socket *sock, int level, int optname,
+static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	int ret = 0;
 
-	if (level != SOL_CAN_ISOTP)
-		return -EINVAL;
-
 	if (so->bound)
 		return -EISCONN;
 
 	switch (optname) {
 	case CAN_ISOTP_OPTS:
@@ -1275,10 +1272,26 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 	}
 
 	return ret;
 }
 
+static int isotp_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	if (level != SOL_CAN_ISOTP)
+		return -EINVAL;
+
+	lock_sock(sk);
+	ret = isotp_setsockopt_locked(sock, level, optname, optval, optlen);
+	release_sock(sk);
+	return ret;
+}
+
 static int isotp_getsockopt(struct socket *sock, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
-- 
2.30.2

