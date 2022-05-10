Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36765219A3
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiEJNuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbiEJNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C612EAD1E;
        Tue, 10 May 2022 06:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41B0A61763;
        Tue, 10 May 2022 13:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3E5C385C6;
        Tue, 10 May 2022 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189482;
        bh=AAu3wZQM5TXMCSefAdcqdNYX8X6nheEiGnbu9e2bf/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSpOHlyOrnwHeg9fwkCnuvVjrOQFBnn9tCPC7KH4W/WavP/rd193REOF2GBpyixMY
         jadqMKacwk5L0DOSD+3NUBWzD848qBAhQSVsNT3NULD33f4Mj6lSDJ36PfPBsEiPfI
         w3qkbjMzAIUaaabv64lNA6dk0v6ri6voggK3ZmIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 065/135] net: cpsw: add missing of_node_put() in cpsw_probe_dt()
Date:   Tue, 10 May 2022 15:07:27 +0200
Message-Id: <20220510130742.276322740@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
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

commit 95098d5ac2551769807031444e55a0da5d4f0952 upstream.

'tmp_node' need be put before returning from cpsw_probe_dt(),
so add missing of_node_put() in error path.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/cpsw_new.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1246,8 +1246,10 @@ static int cpsw_probe_dt(struct cpsw_com
 	data->slave_data = devm_kcalloc(dev, CPSW_SLAVE_PORTS_NUM,
 					sizeof(struct cpsw_slave_data),
 					GFP_KERNEL);
-	if (!data->slave_data)
+	if (!data->slave_data) {
+		of_node_put(tmp_node);
 		return -ENOMEM;
+	}
 
 	/* Populate all the child nodes here...
 	 */
@@ -1341,6 +1343,7 @@ static int cpsw_probe_dt(struct cpsw_com
 
 err_node_put:
 	of_node_put(port_np);
+	of_node_put(tmp_node);
 	return ret;
 }
 


