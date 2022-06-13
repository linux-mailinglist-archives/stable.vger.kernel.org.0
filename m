Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D690549331
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378373AbiFMNlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379098AbiFMNju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7043F7A44A;
        Mon, 13 Jun 2022 04:28:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA75D61037;
        Mon, 13 Jun 2022 11:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D62C34114;
        Mon, 13 Jun 2022 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119719;
        bh=cEu4KRtrBnSljr/Lmyy5Y7uH9MAX4Hs0aLMsgO8HJrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMGuM2/q/UDPww7WddJvJO6/iXWjI0KfEpdTdVYTY/YD7XX/LBOU/dTJB8lUUh01c
         ng9EXeAxyJpp1GVVEEvk4QWN1nKBB2Zka3QGMyQuICQaJ9UT+Y12Q1gHoXpKTfrFIc
         3nuksJshGeGUrlA5fU6xsXiHBQmguQazOYlphn9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 096/339] net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
Date:   Mon, 13 Jun 2022 12:08:41 +0200
Message-Id: <20220613094929.424025670@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 02ded5a173619b11728b8bf75a3fd995a2c1ff28 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.

mv88e6xxx_mdio_register() pass the device node to of_mdiobus_register().
We don't need the device node after it.

Add missing of_node_put() to avoid refcount leak.

Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64f4fdd02902..732570fb97b1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3960,6 +3960,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 */
 	child = of_get_child_by_name(np, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
+	of_node_put(child);
 	if (err)
 		return err;
 
-- 
2.35.1



