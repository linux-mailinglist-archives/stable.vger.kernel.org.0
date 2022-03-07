Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D333E4CF841
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238515AbiCGJw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbiCGJuf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B6673057;
        Mon,  7 Mar 2022 01:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAAFE6136F;
        Mon,  7 Mar 2022 09:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04ED0C340E9;
        Mon,  7 Mar 2022 09:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646231;
        bh=UBdrsVWMvpEWnpvpGDJX06Kk5StTYHhkGEu8qr1hKtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fk3fIEW0h7h5DyWu4MgMNNVqqzC/vv9qQMkzEZDQ0Wth6plY5b9dbkG+SHoSAABa3
         HU7NM2+cdfjBllYxRB4O7GEurfqziwfrtngpcvByeWgX9QQQ3oqxZxFleTvwSm/ZUN
         r0vYxd9Q8D8p7OR2f96njMjp+BF06X7ROgU360kM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/262] net: of: fix stub of_net helpers for CONFIG_NET=n
Date:   Mon,  7 Mar 2022 10:17:59 +0100
Message-Id: <20220307091706.265997031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 8b017fbe0bbb98dd71fb4850f6b9cc0e136a26b8 ]

Moving the of_net code from drivers/of/ to net/core means we
no longer stub out the helpers when networking is disabled,
which leads to a randconfig build failure with at least one
ARM platform that calls this from non-networking code:

arm-linux-gnueabi-ld: arch/arm/mach-mvebu/kirkwood.o: in function `kirkwood_dt_eth_fixup':
kirkwood.c:(.init.text+0x54): undefined reference to `of_get_mac_address'

Restore the way this worked before by changing that #ifdef
check back to testing for both CONFIG_OF and CONFIG_NET.

Fixes: e330fb14590c ("of: net: move of_net under net/")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211014090055.2058949-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of_net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index cf31188329b5a..55460ecfa50ad 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -8,7 +8,7 @@
 
 #include <linux/phy.h>
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_NET)
 #include <linux/of.h>
 
 struct net_device;
-- 
2.34.1



