Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89284521837
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243421AbiEJNdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243887AbiEJNcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3D753A76;
        Tue, 10 May 2022 06:23:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2450B60C1C;
        Tue, 10 May 2022 13:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325EDC385C2;
        Tue, 10 May 2022 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188987;
        bh=2JXNi0h472IJAvsy7Wy/uC8BoxOskO922ur9hp3xCw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QfZiei5JK5T44iZdIub3Me3G5RTAmbN9YRTYajfFs9I0g1nQ9ElOc50f3LBMhOYIz
         eYkLfi0df6owdJC65Yg4Qzrs2QG+qa6bQFsUSD9FbcBBdOzeQNtd7Rw+hF3X2eAjRN
         NN3KJWxHuo7X7RNQ5DvXiHjl0ye8jrt7rJXsQfdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 27/52] net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()
Date:   Tue, 10 May 2022 15:07:56 +0200
Message-Id: <20220510130730.647034264@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 1a15267b7be77e0792cf0c7b36ca65c8eb2df0d8 upstream.

The node pointer returned by of_get_child_by_name() with refcount incremented,
so add of_node_put() after using it.

Fixes: 634db83b8265 ("net: stmmac: dwmac-sun8i: Handle integrated/external MDIOs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220428095716.540452-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -879,6 +879,7 @@ static int sun8i_dwmac_register_mdio_mux
 
 	ret = mdio_mux_init(priv->device, mdio_mux, mdio_mux_syscon_switch_fn,
 			    &gmac->mux_handle, priv, priv->mii);
+	of_node_put(mdio_mux);
 	return ret;
 }
 


