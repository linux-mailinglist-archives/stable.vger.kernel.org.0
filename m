Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B204DC698
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiCQMwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiCQMwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:52:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FD01C1ED6;
        Thu, 17 Mar 2022 05:49:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 989AF61501;
        Thu, 17 Mar 2022 12:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B7CC36AE2;
        Thu, 17 Mar 2022 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521391;
        bh=PQOuITHVPon9XW98JjJqKHvwOVzkW8LQEUKLykbyNTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjycYEqpUzyA7IFVWUAbjOu5aX5MzfzoByaZ/NTLifo3eJQWqDwp8Wq4UK1yXBDON
         6dEh9OhMAIMNvRLCPLrhPjSQAukjEE2uEmWqmua/83VAMind9rsfa/mvIptLGI2VM/
         kn1mMDxw3w5STPtm1240xo+r6SDDGtg2aydhYqMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/23] tcp: make tcp_read_sock() more robust
Date:   Thu, 17 Mar 2022 13:45:59 +0100
Message-Id: <20220317124526.486959846@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124525.955110315@linuxfoundation.org>
References: <20220317124525.955110315@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e3d5ea2c011ecb16fb94c56a659364e6b30fac94 ]

If recv_actor() returns an incorrect value, tcp_read_sock()
might loop forever.

Instead, issue a one time warning and make sure to make progress.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20220302161723.3910001-2-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 63c81af41b43..a3ec2a08027b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1652,11 +1652,13 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				if (!copied)
 					copied = used;
 				break;
-			} else if (used <= len) {
-				seq += used;
-				copied += used;
-				offset += used;
 			}
+			if (WARN_ON_ONCE(used > len))
+				used = len;
+			seq += used;
+			copied += used;
+			offset += used;
+
 			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
-- 
2.34.1



