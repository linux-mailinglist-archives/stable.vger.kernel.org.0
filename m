Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C332666CC4B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbjAPRYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234591AbjAPRYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:24:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787A059E5F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:01:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 173C861085
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2746BC433EF;
        Mon, 16 Jan 2023 17:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888480;
        bh=+8+Ux6nDxDfufnP+0mYx0tNmTaU1NGMLxRJgPue+i+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IXc8NLyuOZvCxC6OiCyU8WFjj3YBpq8p7/wBXd4DunW3MMcx1fiZR3xnjXD8rET4l
         UJLivTOGqfq/qCo1jHQzySqab4kxlr+Td9hr9zWVygUkBn3lZAoj3RglJtOHjEH2IJ
         rQ2tOg5LDqVEgPloDPcUCg7N7cW+urKslaCfO0E0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 022/338] net: loopback: use NET_NAME_PREDICTABLE for name_assign_type
Date:   Mon, 16 Jan 2023 16:48:15 +0100
Message-Id: <20230116154821.724496012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 31d929de5a112ee1b977a89c57de74710894bbbf ]

When the name_assign_type attribute was introduced (commit
685343fc3ba6, "net: add name_assign_type netdev attribute"), the
loopback device was explicitly mentioned as one which would make use
of NET_NAME_PREDICTABLE:

    The name_assign_type attribute gives hints where the interface name of a
    given net-device comes from. These values are currently defined:
...
      NET_NAME_PREDICTABLE:
        The ifname has been assigned by the kernel in a predictable way
        that is guaranteed to avoid reuse and always be the same for a
        given device. Examples include statically created devices like
        the loopback device [...]

Switch to that so that reading /sys/class/net/lo/name_assign_type
produces something sensible instead of returning -EINVAL.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 30612497643c..daef41ce2349 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -206,7 +206,7 @@ static __net_init int loopback_net_init(struct net *net)
 	int err;
 
 	err = -ENOMEM;
-	dev = alloc_netdev(0, "lo", NET_NAME_UNKNOWN, loopback_setup);
+	dev = alloc_netdev(0, "lo", NET_NAME_PREDICTABLE, loopback_setup);
 	if (!dev)
 		goto out;
 
-- 
2.35.1



