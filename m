Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74270501127
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbiDNNhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245487AbiDNN3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:29:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380EDAC925;
        Thu, 14 Apr 2022 06:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8330B82982;
        Thu, 14 Apr 2022 13:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4229EC385A9;
        Thu, 14 Apr 2022 13:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942578;
        bh=/94NnZF5zCsGRDaGi4EOOs91gwBmesWffr7GrRdd6r0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4oL1QC8bLOaljlXL0b8JPq8BSA8PicyATR2p3RlFkEjpICs4Q4bLklHE1Pv38s9M
         5hyAQVwOJ4LBS9bP5sq0FtzGJM1f+iGna+7MtBjaZTmdCqxwz2fwttJTPJavcmB1w0
         YH01zPLmdSBqDcPNgI720oSUDt2TI5g5WL0+cUdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Lin Ma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/338] net/x25: Fix null-ptr-deref caused by x25_disconnect
Date:   Thu, 14 Apr 2022 15:11:28 +0200
Message-Id: <20220414110844.163589087@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index f87002792836..77d8adb27ec7 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1797,10 +1797,15 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 
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



