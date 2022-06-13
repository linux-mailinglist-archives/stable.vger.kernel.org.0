Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D3354868B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354446AbiFMM5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354868AbiFMMzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F114F95B5;
        Mon, 13 Jun 2022 04:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EA4960B6B;
        Mon, 13 Jun 2022 11:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1856C34114;
        Mon, 13 Jun 2022 11:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118921;
        bh=bxtKf2OnoL+jFcjVx1pwcCDhAA6o9jCOcEZG0BBkEQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxAJLwAiQ15mCwRSZrqBVVXx9pGzDVKfnW1yAX2/hdbg0TkaswVwl1V1GpbzRpiEN
         HxiOthWv95/3JD8WfDgtWAJGrM6BZEtIiRQ5Hj0jb6v+6j6YCQwAu536FyzIEZGbmR
         5iQCIxiezvw+Wvm0yYFagbT5JzrGv5ntSyF94GpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/247] net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
Date:   Mon, 13 Jun 2022 12:09:37 +0200
Message-Id: <20220613094925.233094232@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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
index 0830d7bb7a00..f9efd0c8bab8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3492,6 +3492,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 */
 	child = of_get_child_by_name(np, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
+	of_node_put(child);
 	if (err)
 		return err;
 
-- 
2.35.1



