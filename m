Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC8505066
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbiDRMYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238509AbiDRMYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:24:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAD41FCE9;
        Mon, 18 Apr 2022 05:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1784B80EDB;
        Mon, 18 Apr 2022 12:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380D0C385A7;
        Mon, 18 Apr 2022 12:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284342;
        bh=PAFCrRodbMCnD8YoxVOpfLdTf4ZEapSnQx6p+QAFK7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q4Yfp7K41nkwCLzVAK54MZuE900TGQFrIdraJ0f3AMAoKLPNrj1obC/WVU+PMmxQs
         nrll1YnSnY92yw0qxeJiiOu1h/5rsoUyU0O2mUOIpqLuGvZMKRwbO334Z2RcFdfL3/
         D1p9/zlqQ0wwjQts8slLb3tHJW6rCE9QiM3NS4Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 080/219] net: dsa: felix: suppress -EPROBE_DEFER errors
Date:   Mon, 18 Apr 2022 14:10:49 +0200
Message-Id: <20220418121208.444631808@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
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
index 2875b5250856..443d34ce2853 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2328,7 +2328,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	err = dsa_register_switch(ds);
 	if (err) {
-		dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+		dev_err_probe(&pdev->dev, err, "Failed to register DSA switch\n");
 		goto err_register_ds;
 	}
 
-- 
2.35.1



