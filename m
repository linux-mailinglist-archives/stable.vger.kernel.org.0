Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0406432B8
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbiLET2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiLET2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1B62981A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D88C5B81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277F5C433C1;
        Mon,  5 Dec 2022 19:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268301;
        bh=p9D+IZ3KuMyeZ0hnvSGoRuz8lzbAeFcSkLvjGsGgCpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyhDK4bDumIcGi+gpFmrjJ6oK5y+K55Qx+1NWhoNFM14/pzz8UzmwvWglGFKGpHwg
         exdxUBSRcUuBYe1hBcgquhhUKNCsr6OzCyqdKVStVDmqRLBijCNhKcIhg6jhOwLD6L
         UJ0yntU/KsfIAhVycUWV/9RwYO18VsgHTzEOWqPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 051/124] net: ethernet: ti: am65-cpsw: fix error handling in am65_cpsw_nuss_probe()
Date:   Mon,  5 Dec 2022 20:09:17 +0100
Message-Id: <20221205190809.884798880@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 46fb6512538d201d9a5b2bd7138b6751c37fdf0b ]

The am65_cpsw_nuss_cleanup_ndev() function calls unregister_netdev()
even if register_netdev() fails, which triggers WARN_ON(1) in
unregister_netdevice_many(). To fix it, make sure that
unregister_netdev() is called only on registered netdev.

Compile tested only.

Fixes: 84b4aa493249 ("net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 348201e10d49..95baacd6c761 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2061,7 +2061,7 @@ static void am65_cpsw_nuss_cleanup_ndev(struct am65_cpsw_common *common)
 
 	for (i = 0; i < common->port_num; i++) {
 		port = &common->ports[i];
-		if (port->ndev)
+		if (port->ndev && port->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(port->ndev);
 	}
 }
-- 
2.35.1



