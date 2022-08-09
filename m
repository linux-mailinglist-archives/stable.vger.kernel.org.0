Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9EF58DDAC
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245703AbiHISDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344457AbiHISDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:03:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3373D26ADB;
        Tue,  9 Aug 2022 11:01:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 151AD61012;
        Tue,  9 Aug 2022 18:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82052C433D7;
        Tue,  9 Aug 2022 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068110;
        bh=nWkaHB4aObE4+ORXQz/gbELbp69I+2ype2nxZe9a19U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOhBMOUbVNQ52uVzKGFoOVHEBuoGke5N8942aYr5Ifsey68O0HTid97VCiRfs5+/a
         wgKfgy1cCuwG/NOq1ltM6EdHW2i/fXyO63gksfeTawZGkNdR4auWKsxYUNKDVgIkI7
         6qibuxIxFUuwo2nYkduWsJi5OO4ef2JnRlsVpHo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/32] tcp: Fix a data-race around sysctl_tcp_nometrics_save.
Date:   Tue,  9 Aug 2022 19:59:59 +0200
Message-Id: <20220809175513.362227305@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
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


