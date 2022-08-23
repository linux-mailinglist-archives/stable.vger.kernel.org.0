Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50CC159DBBE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358693AbiHWLw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358675AbiHWLug (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:50:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A193534;
        Tue, 23 Aug 2022 02:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC2C2B81C85;
        Tue, 23 Aug 2022 09:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A022C433C1;
        Tue, 23 Aug 2022 09:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247099;
        bh=FCtL1a3iorZK6PRbgbZ2Lj1dgI9Q4zlRLjuHCMNyOZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGmse/4j7jDXhVsMXvv1xjJSwQnegOmZDO0G12ZYJSXEzj/Xlv3mYMP3GcVvty8vV
         SEWe6dsjAxlB3pc/rMbob60Y1VNFonlgwLAfxivtYWwiikKCEnaxCBHQSHoBoOyDOi
         VIud7HW+4/14KhskBlXsOOxKoOGqPOLMZmEFhQHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Florian Westphal <fw@strlen.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 317/389] plip: avoid rcu debug splat
Date:   Tue, 23 Aug 2022 10:26:35 +0200
Message-Id: <20220823080128.787719738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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


