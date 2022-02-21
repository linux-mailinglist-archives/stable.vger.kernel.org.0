Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FAD4BE62F
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiBUJ1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350004AbiBUJ1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EC51D335;
        Mon, 21 Feb 2022 01:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92A2760018;
        Mon, 21 Feb 2022 09:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76953C340E9;
        Mon, 21 Feb 2022 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434674;
        bh=42BZzAIrhChSJ2BfYlKST5WzCDRyABo6KiK+ubfK/54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tq3EeP+GNL52Oy6AqG0gKPFgEH6E+1KOupDepwPDoDYr6ByS8nauf6quKRwdJ+kT
         ssJVqLk5H8aMQTn39MtrQTQJ6RoSN6SUu8cj8Sxmi2rq4xWm3uQfWT5pUU5lwiZc74
         r2+HlP58Cy4HE+SP2PiK49HAEtdSxgO4SK6vZnAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 091/196] net: dsa: lantiq_gswip: fix use after free in gswip_remove()
Date:   Mon, 21 Feb 2022 09:48:43 +0100
Message-Id: <20220221084933.987875225@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 8c6ae46150a453f8ae9a6cd49b45f354f478587d upstream.

of_node_put(priv->ds->slave_mii_bus->dev.of_node) should be
done before mdiobus_free(priv->ds->slave_mii_bus).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 0d120dfb5d67 ("net: dsa: lantiq_gswip: don't use devres for mdiobus")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/1644921768-26477-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -2201,8 +2201,8 @@ static int gswip_remove(struct platform_
 
 	if (priv->ds->slave_mii_bus) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
-		mdiobus_free(priv->ds->slave_mii_bus);
 		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
+		mdiobus_free(priv->ds->slave_mii_bus);
 	}
 
 	for (i = 0; i < priv->num_gphy_fw; i++)


