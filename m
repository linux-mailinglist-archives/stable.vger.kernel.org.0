Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC29364A1D8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiLLNqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbiLLNqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCEFF6F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:45:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9152F61035
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C99AC433EF;
        Mon, 12 Dec 2022 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852733;
        bh=1QZS2l3tLbXVlN1eUuIwwbARSK5yUgsTIjJs4MIQD+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EsLify+xNVwo40t5P0yBnEBydUhZGWiE0ZJlzVzDJcpiy/h2MEpzC/Vnz0SiBy6VV
         IoTSrUzOthXIjkhclt1tUVpNdj349z5nXXr+96FtBv7fX//luDFlmwfvJpwnltvLiF
         PqMULAaaGQiSA4mmr2yoa7yPt7nBaA67S5BmQzQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 141/157] bonding: get correct NA dest address
Date:   Mon, 12 Dec 2022 14:18:09 +0100
Message-Id: <20221212130940.780892235@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 1f154f3b56a1a172833eedf77b72745acc8d9259 ]

In commit 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving
IPv6 messages"), there is a copy/paste issue for NA daddr. I found that
in my testing and fixed it in my local branch. But I forgot to re-format
the patch and sent the wrong mail.

Fix it by reading the correct dest address.

Fixes: 4d633d1b468b ("bonding: fix ICMPv6 header handling when receiving IPv6 messages")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Link: https://lore.kernel.org/r/20221206032055.7517-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 76dd5ff1d99d..c2939621b683 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3247,7 +3247,7 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
 		goto out;
 
 	saddr = &combined->ip6.saddr;
-	daddr = &combined->ip6.saddr;
+	daddr = &combined->ip6.daddr;
 
 	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI6c tip %pI6c\n",
 		  __func__, slave->dev->name, bond_slave_state(slave),
-- 
2.35.1



