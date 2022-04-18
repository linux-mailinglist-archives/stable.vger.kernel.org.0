Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202905051C8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiDRMkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiDRMjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90654DD3;
        Mon, 18 Apr 2022 05:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F767B80EDE;
        Mon, 18 Apr 2022 12:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3352C385A8;
        Mon, 18 Apr 2022 12:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284986;
        bh=990psWNqzMEthyxJ902dzVHKuK4BQOc2qlF34o1P3pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxKzzU7M7gDKXQnGmzH4/WXu1LA/9SNMooyq6RwXXLnu4mqGxXXC1svhYWuv0h0Vk
         dKxd34k/0Y2jBlzvIc9DtvN5U7HPPvKFN7GrXIZjnqR+4+KFuK2IZE9zOdi0u3Hc3R
         QMrzlRadtl6qhyuVgl4wRLwayc/jof8D84Cjr1Q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/189] net: dsa: felix: suppress -EPROBE_DEFER errors
Date:   Mon, 18 Apr 2022 14:11:30 +0200
Message-Id: <20220418121202.495473719@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit e6934e4048c91502efcb21da92b7ae37cd8fa741 ]

The DSA master might not have been probed yet in which case the probe of
the felix switch fails with -EPROBE_DEFER:
[    4.435305] mscc_felix 0000:00:00.5: Failed to register DSA switch: -517

It is not an error. Use dev_err_probe() to demote this particular error
to a debug message.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220408101521.281886-1-michael@walle.cc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index e53ad283e259..a9c7ada890d8 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1455,7 +1455,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	err = dsa_register_switch(ds);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		dev_err_probe(&pdev->dev, err, "Failed to register DSA switch\n");
 		goto err_register_ds;
 	}
 
-- 
2.35.1



