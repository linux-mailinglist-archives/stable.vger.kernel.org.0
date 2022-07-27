Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56428582CD0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240496AbiG0Qun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240826AbiG0Qth (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:49:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9931053D1E;
        Wed, 27 Jul 2022 09:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 258456199B;
        Wed, 27 Jul 2022 16:33:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D505C433D6;
        Wed, 27 Jul 2022 16:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939581;
        bh=c/R5FhqUMv13CvdyCMgle+b1uhL/zAmOxTQfmBOd0Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bO0MpnUmSWkgMtYxqRih523BNOY1OyjPGp3wcL271uZ6KwCyqVksjr7XqTg+LCqYq
         2zMEMzn0WGEcZlzoU0oBfmoUum3N8LDiEXs7JVlKFcJOfvzbkBBjOlXkJAQo87y19R
         hgAH/tVNp1nyAx7B/G/efyjooBEyw7FtBehq1yXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/105] ip: Fix a data-race around sysctl_ip_autobind_reuse.
Date:   Wed, 27 Jul 2022 18:10:18 +0200
Message-Id: <20220727161013.379136661@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

[ Upstream commit 0db232765887d9807df8bcb7b6f29b2871539eab ]

While reading sysctl_ip_autobind_reuse, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 4b01a9674231 ("tcp: bind(0) remove the SO_REUSEADDR restriction when ephemeral ports are exhausted.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 7785a4775e58..4d9713324003 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -251,7 +251,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		goto other_half_scan;
 	}
 
-	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
+	if (READ_ONCE(net->ipv4.sysctl_ip_autobind_reuse) && !relax) {
 		/* We still have a chance to connect to different destinations */
 		relax = true;
 		goto ports_exhausted;
-- 
2.35.1



