Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C86C582BE7
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbiG0Qjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239488AbiG0QjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:39:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9334B5A2F4;
        Wed, 27 Jul 2022 09:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA4EF619FD;
        Wed, 27 Jul 2022 16:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B0C433B5;
        Wed, 27 Jul 2022 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939331;
        bh=nvdpweDSvH25oGsOsk++jLEIfRIAZLkJciKbzP7y+4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fytYhCy5v5FM/hJ7vmM5bjU+A6MCeL2wKiCKi1Lkdx6dx8dr7pnwxALtlvZLMt4w0
         4NPDhJaGl14F0o1VF47uTkwcMgaIYSzlAk2vh36tY/dXkOeCM4mLHvCULFXtSTJCHu
         0/UrOJ+OwbCwNqOyspl1+U7cNJH1/WXb1gXr3jPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/87] igmp: Fix a data-race around sysctl_igmp_max_memberships.
Date:   Wed, 27 Jul 2022 18:10:24 +0200
Message-Id: <20220727161010.305028034@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
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

[ Upstream commit 6305d821e3b9b5379d348528e5b5faf316383bc2 ]

While reading sysctl_igmp_max_memberships, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7cd444d75c3d..660b41040c77 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2199,7 +2199,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
 		count++;
 	}
 	err = -ENOBUFS;
-	if (count >= net->ipv4.sysctl_igmp_max_memberships)
+	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
 		goto done;
 	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
 	if (!iml)
-- 
2.35.1



