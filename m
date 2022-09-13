Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A535B72FF
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbiIMPCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbiIMPAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:00:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF9D69F56;
        Tue, 13 Sep 2022 07:29:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98736614B5;
        Tue, 13 Sep 2022 14:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A742DC433D6;
        Tue, 13 Sep 2022 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078407;
        bh=xsaZeYkrc/Uzf4+/7S3gCET26HKaDj3+mqIwnpMZcVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PipuNaXazSdiWqW8ialypaoXCIUUCXzd6FCQuvHJZcLl8dB9g5GaZOSZHTKalxbgb
         mZ5Y/bSh5SpW+zFMMewQSx/reJNVpLvmBUhu5b70qWlrJH9fPL90Jc31ZH10xlCmQt
         Orz9VsDFui33sxcx+jC4W9aYgGUqNDwotTVsFpuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LiLiang <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 127/192] bonding: use unspecified address if no available link local address
Date:   Tue, 13 Sep 2022 16:03:53 +0200
Message-Id: <20220913140416.331082954@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit b7f14132bf58256e841774ae07d3ffb7a841c2bc ]

When ns_ip6_target was set, the ipv6_dev_get_saddr() will be called to get
available source address and send IPv6 neighbor solicit message.

If the target is global address, ipv6_dev_get_saddr() will get any
available src address. But if the target is link local address,
ipv6_dev_get_saddr() will only get available address from our interface,
i.e. the corresponding bond interface.

But before bond interface up, all the address is tentative, while
ipv6_dev_get_saddr() will ignore tentative address. This makes we can't
find available link local src address, then bond_ns_send() will not be
called and no NS message was sent. Finally bond interface will keep in
down state.

Fix this by sending NS with unspecified address if there is no available
source address.

Reported-by: LiLiang <liali@redhat.com>
Fixes: 5e1eeef69c0f ("bonding: NS target should accept link local address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6ba4c83fe5fc0..0cf8c3a125d2e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3134,6 +3134,9 @@ static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
 found:
 		if (!ipv6_dev_get_saddr(dev_net(dst->dev), dst->dev, &targets[i], 0, &saddr))
 			bond_ns_send(slave, &targets[i], &saddr, tags);
+		else
+			bond_ns_send(slave, &targets[i], &in6addr_any, tags);
+
 		dst_release(dst);
 		kfree(tags);
 	}
-- 
2.35.1



