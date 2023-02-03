Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C9468957B
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjBCKVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjBCKVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8D09E9E0
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF28A61ECA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A389C433EF;
        Fri,  3 Feb 2023 10:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419666;
        bh=sWNmFSAJP0r7Cr2Lz17OUH6SAVoWFwd0TaQ7BzeDIGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFe8Hwc6j28YK3k+8hzK/+TifMZyqjhETfaUO5uMT9fbNYo3VixGN8/r6fyFC1Lh0
         ENnPW8hGNNvepAZhj9XuJE83iNeSn1W5ZJRZVP4AKYBNkNOY0DfJYIwCf5mAp45LZW
         UXC3Xy+W2SZ8zu57FmN4dNYtY+eLvTR4XQHoP3lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Yu <zhangyu31@baidu.com>,
        Li RongQing <lirongqing@baidu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/80] netlink: remove hash::nelems check in netlink_insert
Date:   Fri,  3 Feb 2023 11:12:41 +0100
Message-Id: <20230203101017.236992079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0041195d55bc38df6b574cc8c36dcf2266fbee39 ]

The type of hash::nelems has been changed from size_t to atom_t
which in fact is int, so not need to check if BITS_PER_LONG, that
is bit number of size_t, is bigger than 32

and rht_grow_above_max() will be called to check if hashtable is
too big, ensure it can not bigger than 1<<31

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c1bb9484e3b0 ("netlink: annotate data races around nlk->portid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6ffa83319d08..966c709c3831 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -578,11 +578,6 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	err = -ENOMEM;
-	if (BITS_PER_LONG > 32 &&
-	    unlikely(atomic_read(&table->hash.nelems) >= UINT_MAX))
-		goto err;
-
 	nlk_sk(sk)->portid = portid;
 	sock_hold(sk);
 
-- 
2.39.0



