Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FDA505615
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbiDRNcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244656AbiDRNaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7839658C;
        Mon, 18 Apr 2022 05:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AAA5B80EBA;
        Mon, 18 Apr 2022 12:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE8EC385A1;
        Mon, 18 Apr 2022 12:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286493;
        bh=raBcB2yEX7qZk3a4wK2LfDY148vi/GI9qOPBsM4Powo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnsinLxNa81s2id6JsM6xdaA0j4VUHQRFsaFM077jkcFBiGdeinLQYFEYqUKLdJ8Y
         TAKCVU75eHnX8e/CZeXWNdn55wJWJeu9PBkXxcaPsDNX68fcd2ehB9CQZoa978x4p5
         RXD4T7F+BHadz3GmqIyMvsgVU6ymx3KuLNtskhoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 152/284] net/x25: Fix null-ptr-deref caused by x25_disconnect
Date:   Mon, 18 Apr 2022 14:12:13 +0200
Message-Id: <20220418121215.991566555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 7781607938c8371d4c2b243527430241c62e39c2 ]

When the link layer is terminating, x25->neighbour will be set to NULL
in x25_disconnect(). As a result, it could cause null-ptr-deref bugs in
x25_sendmsg(),x25_recvmsg() and x25_connect(). One of the bugs is
shown below.

    (Thread 1)                 |  (Thread 2)
x25_link_terminated()          | x25_recvmsg()
 x25_kill_by_neigh()           |  ...
  x25_disconnect()             |  lock_sock(sk)
   ...                         |  ...
   x25->neighbour = NULL //(1) |
   ...                         |  x25->neighbour->extended //(2)

The code sets NULL to x25->neighbour in position (1) and dereferences
x25->neighbour in position (2), which could cause null-ptr-deref bug.

This patch adds lock_sock() in x25_kill_by_neigh() in order to synchronize
with x25_sendmsg(), x25_recvmsg() and x25_connect(). What`s more, the
sock held by lock_sock() is not NULL, because it is extracted from x25_list
and uses x25_list_lock to synchronize.

Fixes: 4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25 disconnect")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/x25/af_x25.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index fd0a6c6c77b6..e103ec39759f 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1796,10 +1796,15 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 
 	write_lock_bh(&x25_list_lock);
 
-	sk_for_each(s, &x25_list)
-		if (x25_sk(s)->neighbour == nb)
+	sk_for_each(s, &x25_list) {
+		if (x25_sk(s)->neighbour == nb) {
+			write_unlock_bh(&x25_list_lock);
+			lock_sock(s);
 			x25_disconnect(s, ENETUNREACH, 0, 0);
-
+			release_sock(s);
+			write_lock_bh(&x25_list_lock);
+		}
+	}
 	write_unlock_bh(&x25_list_lock);
 
 	/* Remove any related forwards */
-- 
2.34.1



