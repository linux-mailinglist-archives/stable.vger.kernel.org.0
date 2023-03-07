Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473136AEEA9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjCGSOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjCGSNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9A99F209
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 039B861539
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FA3C43443;
        Tue,  7 Mar 2023 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212574;
        bh=QIY4WRLGyp1gduhGmVfQFdHf05jMUPSHY/6F033D5xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/YuP6efyebaXrsrWlXeuUfFpS0D9+BwebKqirtKQYmkLfgKY7IS46JHIS4e+JR7K
         PSxDfKbkuyG/1YNYkiLH6SgGz9RWGyRPnqVWyNhk6njHWwBL+sQzvZf2TFJDZUme5l
         e3DPDxbvsfLtimkUQTznPlkMzVJ9d0N4t/IwPJPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 210/885] tap: tap_open(): correctly initialize socket uid
Date:   Tue,  7 Mar 2023 17:52:24 +0100
Message-Id: <20230307170011.184886842@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 66b2c338adce580dfce2199591e65e2bab889cff ]

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tap_open() passes a `struct socket` embedded in a `struct
tap_queue` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with
padding bytes between `int vnet_hdr_sz` and `struct tap_dev __rcu
*tap` in `struct tap_queue`, which makes the uid of all tap sockets 0,
i.e., the root one.
Fix the assignment by using sock_init_data_uid().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 9e75ed3f08ce5..760d8d1b6cba4 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -533,7 +533,7 @@ static int tap_open(struct inode *inode, struct file *file)
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
 	q->sock.ops = &tap_socket_ops;
-	sock_init_data(&q->sock, &q->sk);
+	sock_init_data_uid(&q->sock, &q->sk, inode->i_uid);
 	q->sk.sk_write_space = tap_sock_write_space;
 	q->sk.sk_destruct = tap_sock_destruct;
 	q->flags = IFF_VNET_HDR | IFF_NO_PI | IFF_TAP;
-- 
2.39.2



