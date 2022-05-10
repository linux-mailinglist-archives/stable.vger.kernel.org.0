Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C445217DE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243084AbiEJN3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243286AbiEJN3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7611B473BB;
        Tue, 10 May 2022 06:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC42461663;
        Tue, 10 May 2022 13:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3851C385C6;
        Tue, 10 May 2022 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188870;
        bh=tbJHvViQzV/JozlxA+VMglRr0mAAIM8Pbgmf2vmtYEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+JSGbbqqQVYRwzNMaCNiPCqwBdiiFd56+MncwVxVwmz3cbSUPYwQ0qOLyoCcAMQB
         ahN1Ef+Kd7vH6LSzMeGyqjaBb/TULKJzKFTxnjKdRIWpLr7rnB9Y97nvgo0mWQLhwG
         ivPjOsakJactlgjpi0aOw5JUBfdzKpSZN8hCfVl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 75/88] net: stmmac: dwmac-sun8i: add missing of_node_put() in sun8i_dwmac_register_mdio_mux()
Date:   Tue, 10 May 2022 15:08:00 +0200
Message-Id: <20220510130735.909264374@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130733.735278074@linuxfoundation.org>
References: <20220510130733.735278074@linuxfoundation.org>
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
@@ -873,6 +873,7 @@ static int sun8i_dwmac_register_mdio_mux
 
 	ret = mdio_mux_init(priv->device, mdio_mux, mdio_mux_syscon_switch_fn,
 			    &gmac->mux_handle, priv, priv->mii);
+	of_node_put(mdio_mux);
 	return ret;
 }
 


