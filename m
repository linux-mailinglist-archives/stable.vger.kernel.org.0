Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A57D59D7F0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbiHWJx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240126AbiHWJvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D746E2E8;
        Tue, 23 Aug 2022 01:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81326B81C39;
        Tue, 23 Aug 2022 08:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45F7C433D6;
        Tue, 23 Aug 2022 08:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244363;
        bh=bBnAC7qyUS/FWZNSAMQLXtwhOege26wsptCan8PXqi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZddiK43ueX4dx/aZUTvKOtgtOllbKTZ1Q8Kdt5yt2AyMq5zfSw6xB1psz/5UJZeW
         HSHyA7zd1rvN1zlgm3QYXcTIsqN/R6cs8GD/0gvqNt+XWJ2n8DskAslJ1Eshdtqkhh
         /dUX8RhijKbPQjLJ+P2hXHzaTxA0WRUVZAqnckPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 079/244] plip: avoid rcu debug splat
Date:   Tue, 23 Aug 2022 10:23:58 +0200
Message-Id: <20220823080101.686057284@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -1107,7 +1107,7 @@ plip_open(struct net_device *dev)
 		/* Any address will do - we take the first. We already
 		   have the first two bytes filled with 0xfc, from
 		   plip_init_dev(). */
-		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
+		const struct in_ifaddr *ifa = rtnl_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			memcpy(dev->dev_addr+2, &ifa->ifa_local, 4);
 		}


