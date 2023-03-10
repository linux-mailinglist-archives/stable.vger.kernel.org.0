Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EB46B451C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbjCJObF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbjCJOao (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:30:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA7CDBB7C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BFE7B822BD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B55C433D2;
        Fri, 10 Mar 2023 14:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458580;
        bh=4XlWsQrLj5BbjZS9Im92zDVv+4ZXSqUOvALZFPLTst0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zAtNB21o4uK46CqfjRBgUn7UpKtkCjas4rn5ZqdMAMmaTJEtYv9HAmbpyuKAht8Lw
         qjuQOzxOJ0+YI2G+4AxHdJQOXiVXtUBkFUxBrsNLn61O69dJRNQPBtzMDg+1IrFdAm
         WvO4uWhbJBLmEiif/lqZWbsi3HMgd13ZNzjZbCds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/357] tun: tun_chr_open(): correctly initialize socket uid
Date:   Fri, 10 Mar 2023 14:36:03 +0100
Message-Id: <20230310133737.252272853@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit a096ccca6e503a5c575717ff8a36ace27510ab0a ]

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tun_chr_open() passes a `struct socket` embedded in a `struct
tun_file` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with the
high 4 bytes of `struct tun_struct __rcu *tun` of `struct tun_file`,
NULL at the time of call, which makes the uid of all tun sockets 0,
i.e., the root one.
Fix the assignment by using sock_init_data_uid().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 957e6051c535b..5d94ac0250ecf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3525,7 +3525,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
-- 
2.39.2



