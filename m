Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFB45868A7
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 13:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiHALvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 07:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiHALuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 07:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E6240BC3;
        Mon,  1 Aug 2022 04:49:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48C896125A;
        Mon,  1 Aug 2022 11:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52717C433D6;
        Mon,  1 Aug 2022 11:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354558;
        bh=nWkaHB4aObE4+ORXQz/gbELbp69I+2ype2nxZe9a19U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6n6+c2EuJafW0K/ICF3Q/PKOll5LPbpeIVYXShB+JFVM14JU9Pb8XVR9bXOTi4n3
         6LRtkBZQcolDYQRWN//2lvfBfopM87LXmzUxGrvYwIBsN9gK1JGnkTlOsZZ85hz7Q5
         TGDFMyhNuHDCnOE6HCjgUR16n0dLyg8M6kZK2eQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 08/34] tcp: Fix a data-race around sysctl_tcp_nometrics_save.
Date:   Mon,  1 Aug 2022 13:46:48 +0200
Message-Id: <20220801114128.364618769@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114128.025615151@linuxfoundation.org>
References: <20220801114128.025615151@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 8499a2454d9e8a55ce616ede9f9580f36fd5b0f3 upstream.

While reading sysctl_tcp_nometrics_save, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_metrics.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -329,7 +329,7 @@ void tcp_update_metrics(struct sock *sk)
 	int m;
 
 	sk_dst_confirm(sk);
-	if (net->ipv4.sysctl_tcp_nometrics_save || !dst)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_nometrics_save) || !dst)
 		return;
 
 	rcu_read_lock();


