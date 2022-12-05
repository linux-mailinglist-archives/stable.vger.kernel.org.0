Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D083D6433C5
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbiLETjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiLETjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192C026ADB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA3CA61315
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDA9C433C1;
        Mon,  5 Dec 2022 19:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268971;
        bh=TxKxdG+u4zKrUDwJlIdbwCGyepxaN/CqYp45o1hQOnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIW/z33KikR9ZwIfEdLosIFbU6ZyG+dlPlSfrW3+2yFCFBlhPDD/3Yyn713fm12pF
         qpb41ssqaMc2mQG7RYMPD6/MA8BXYG7AVs7xCW6lsqOu1sMe03tQL2+KKOz5shP766
         6mdtw/pbrKngo4ApP/aikauiIEflqUthxOisFWHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Hai <wanghai38@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/120] net/9p: Fix a potential socket leak in p9_socket_open
Date:   Mon,  5 Dec 2022 20:09:51 +0100
Message-Id: <20221205190808.134267485@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit dcc14cfd7debe11b825cb077e75d91d2575b4cb8 ]

Both p9_fd_create_tcp() and p9_fd_create_unix() will call
p9_socket_open(). If the creation of p9_trans_fd fails,
p9_fd_create_tcp() and p9_fd_create_unix() will return an
error directly instead of releasing the cscoket, which will
result in a socket leak.

This patch adds sock_release() to fix the leak issue.

Fixes: 6b18662e239a ("9p connect fixes")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
ACKed-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 31f2026514f3..e1c2c9242ce2 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -864,8 +864,10 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	struct file *file;
 
 	p = kzalloc(sizeof(struct p9_trans_fd), GFP_KERNEL);
-	if (!p)
+	if (!p) {
+		sock_release(csocket);
 		return -ENOMEM;
+	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
 	file = sock_alloc_file(csocket, 0, NULL);
-- 
2.35.1



