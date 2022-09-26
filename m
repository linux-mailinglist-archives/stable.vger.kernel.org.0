Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE085EA71A
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiIZN1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiIZN0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:26:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2A857236;
        Mon, 26 Sep 2022 04:51:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4A96B8095C;
        Mon, 26 Sep 2022 10:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10717C433D6;
        Mon, 26 Sep 2022 10:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188794;
        bh=nXLbPcp/lmo1PNRr7WbCA1M/+VZrKaywAvL2mtf1Ros=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkhvyZjcRHRGJTruBr3qVzXSyR2O8gksdDWZxA7iSnlEY1u1lxCt7inTEedtI42VQ
         7r5u4SSdw18PLHUUcye/fze5XxsTvgHrRTq5jpkMGhZBL/0f65EI6B3IT3+nGbr7LL
         QrORVKXNxLogFeBB0cB1OZ4SPjYEtoS2B4PQwQUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Liang He <windhl@126.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/148] of: mdio: Add of_node_put() when breaking out of for_each_xx
Date:   Mon, 26 Sep 2022 12:12:06 +0200
Message-Id: <20220926100759.525282902@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 1c48709e6d9d353acaaac1d8e33474756b121d78 ]

In of_mdiobus_register(), we should call of_node_put() for 'child'
escaped out of for_each_available_child_of_node().

Fixes: 66bdede495c7 ("of_mdio: Fix broken PHY IRQ in case of probe deferral")
Co-developed-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220913125659.3331969-1-windhl@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/of_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 9e3c815a070f..796e9c7857d0 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -231,6 +231,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	return 0;
 
 unregister:
+	of_node_put(child);
 	mdiobus_unregister(mdio);
 	return rc;
 }
-- 
2.35.1



