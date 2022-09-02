Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FC85AAF25
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236715AbiIBMeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiIBMdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:33:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CE0E193D;
        Fri,  2 Sep 2022 05:27:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC9CD6211D;
        Fri,  2 Sep 2022 12:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30FEC433C1;
        Fri,  2 Sep 2022 12:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121520;
        bh=E63Stpnr3yidX6/oPg6+aQlRal9zM08EPfNrXFXspmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2TsJ2AhxK/Is7YP6qoH+zY8hUA4z1hgSDoOn94/SniSY5NqybyAvWDfmKsVJ6Pm/
         BjZ9H0QVmgW96hqmNMASEr8IlVenA0r8iFORanxaLniZvPnaQwiymskS44u1Rs+XDp
         HXIzQKj1RNELgDDS5Cxf8UUdbaLTExBUbQbgJxk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/56] net: Fix a data-race around sysctl_somaxconn.
Date:   Fri,  2 Sep 2022 14:18:47 +0200
Message-Id: <20220902121401.166047129@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 3c9ba81d72047f2e81bb535d42856517b613aba7 ]

While reading sysctl_somaxconn, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index e5cc9f2b981ed..a5167f03c31db 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1619,7 +1619,7 @@ int __sys_listen(int fd, int backlog)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock) {
-		somaxconn = sock_net(sock->sk)->core.sysctl_somaxconn;
+		somaxconn = READ_ONCE(sock_net(sock->sk)->core.sysctl_somaxconn);
 		if ((unsigned int)backlog > somaxconn)
 			backlog = somaxconn;
 
-- 
2.35.1



