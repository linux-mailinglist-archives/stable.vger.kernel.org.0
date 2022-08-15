Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E985949F1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245717AbiHOX3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352940AbiHOX1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:27:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F02914D703;
        Mon, 15 Aug 2022 13:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D06760025;
        Mon, 15 Aug 2022 20:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758FAC433D6;
        Mon, 15 Aug 2022 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594042;
        bh=uH6TwudIP++SMcyH3qUggh6Qa7X7048klOz79flPWDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik58paUhu22ePMLXoq///FKPU28mrFgIMtZskt8TpV3acJ5MxSItmEHFYyAa+bOt4
         cfwxxhqrVf8OE9U0tpjZhSpJWz6/jWxfdo8i8KyTFZrAkphjFGPgJ81Sy1ckOAVN+H
         Tet1i8A4nhjXVHmOho067EkWwckwHrUhHaFm1Gq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0366/1157] net: ag71xx: fix discards const qualifier warning
Date:   Mon, 15 Aug 2022 19:55:22 +0200
Message-Id: <20220815180454.360065935@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 225b0ed27e6ac523e5e98e7395392446859c7f20 ]

Current kernel will compile this driver with warnings. This patch will
fix it.

drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_fast_reset':
drivers/net/ethernet/atheros/ag71xx.c:996:31: warning: passing argument 2 of 'ag71xx_hw_set
_macaddr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  996 |  ag71xx_hw_set_macaddr(ag, dev->dev_addr);
      |                            ~~~^~~~~~~~~~
drivers/net/ethernet/atheros/ag71xx.c:951:69: note: expected 'unsigned char *' but argument
 is of type 'const unsigned char *'
  951 | static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
      |                                                      ~~~~~~~~~~~~~~~^~~
drivers/net/ethernet/atheros/ag71xx.c: In function 'ag71xx_open':
drivers/net/ethernet/atheros/ag71xx.c:1441:32: warning: passing argument 2 of 'ag71xx_hw_se
t_macaddr' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
 1441 |  ag71xx_hw_set_macaddr(ag, ndev->dev_addr);
      |                            ~~~~^~~~~~~~~~
drivers/net/ethernet/atheros/ag71xx.c:951:69: note: expected 'unsigned char *' but argument
 is of type 'const unsigned char *'
  951 | static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
      |                                                      ~~~~~~~~~~~~~~~^~~

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index cac509708e9d..1c6ea6766aa1 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -946,7 +946,7 @@ static unsigned int ag71xx_max_frame_len(unsigned int mtu)
 	return ETH_HLEN + VLAN_HLEN + mtu + ETH_FCS_LEN;
 }
 
-static void ag71xx_hw_set_macaddr(struct ag71xx *ag, unsigned char *mac)
+static void ag71xx_hw_set_macaddr(struct ag71xx *ag, const unsigned char *mac)
 {
 	u32 t;
 
-- 
2.35.1



