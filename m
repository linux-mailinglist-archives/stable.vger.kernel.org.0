Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC034586A11
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbiHAMMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbiHAMKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:10:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACCB691E4;
        Mon,  1 Aug 2022 04:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C661B81163;
        Mon,  1 Aug 2022 11:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEBDC433C1;
        Mon,  1 Aug 2022 11:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354994;
        bh=nWkaHB4aObE4+ORXQz/gbELbp69I+2ype2nxZe9a19U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBql2zbhH+JB1XtgZ91eTmV/Eq76ZDixjYEy7OOa1hxLr6IUmtNjKNuJwe8tuI3qk
         EDrjUmie7sSjBXjpSliLXMPl9BZfYh8eBxRV3W6GlKKM5+F5KM6RTr/1mOegZwKbW7
         eLymWbtxSS27YZMZRT0Yg+veAXE8QQQMBOFV0yMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 24/88] tcp: Fix a data-race around sysctl_tcp_nometrics_save.
Date:   Mon,  1 Aug 2022 13:46:38 +0200
Message-Id: <20220801114139.148269148@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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


