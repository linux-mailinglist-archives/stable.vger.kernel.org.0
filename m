Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4974159E0F2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359283AbiHWMIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359295AbiHWMHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:07:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D126647F;
        Tue, 23 Aug 2022 02:38:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A236138B;
        Tue, 23 Aug 2022 09:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF2AC433C1;
        Tue, 23 Aug 2022 09:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247469;
        bh=FCtL1a3iorZK6PRbgbZ2Lj1dgI9Q4zlRLjuHCMNyOZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkRvsVRYAGIfKiQYsYxbng6wXVvRPFNjjXcgx/iI6c7BxpDe8UF1LBAhjFxn4Dbo8
         LU+N4bAXRnMDVqBhTJ04ETa5feevODQBpiZalYrwEZf/YTv5VumEpndsxRSyuEbuWg
         f5HNi+VOXHy1foP+Gd1QjwTPoxCM0q7oXgLJwRGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 047/158] plip: avoid rcu debug splat
Date:   Tue, 23 Aug 2022 10:26:19 +0200
Message-Id: <20220823080047.993408142@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit bc3c8fe3c79bcdae4d90e3726054fac5cca8ac32 upstream.

WARNING: suspicious RCU usage
5.2.0-rc2-00605-g2638eb8b50cfc #1 Not tainted
drivers/net/plip/plip.c:1110 suspicious rcu_dereference_check() usage!

plip_open is called with RTNL held, switch to the correct helper.

Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20220807115304.13257-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/plip/plip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -1103,7 +1103,7 @@ plip_open(struct net_device *dev)
 		/* Any address will do - we take the first. We already
 		   have the first two bytes filled with 0xfc, from
 		   plip_init_dev(). */
-		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
+		const struct in_ifaddr *ifa = rtnl_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			memcpy(dev->dev_addr+2, &ifa->ifa_local, 4);
 		}


