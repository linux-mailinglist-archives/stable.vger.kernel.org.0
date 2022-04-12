Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF03A4FD5D2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377398AbiDLHuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359046AbiDLHm1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCAB54FAD;
        Tue, 12 Apr 2022 00:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08DED617E4;
        Tue, 12 Apr 2022 07:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16521C385AB;
        Tue, 12 Apr 2022 07:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748003;
        bh=Z0ywCF85g7Mq7CTMi0zgdCOMKY9zQ6PXZ9PeYzZcMC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLOOt/Qven2i7CLHf6fc9yily5fLG1AvmdSw+wKFSrvfnslLvVQewQdhRZQ6c9nZf
         geo762SbWzGY5zy42acTp7tlJDvM3VutEyKynykt5cIEDDjOcKChczvdSOUMlq6V03
         ZFR8j7MB0ahU0DzGY5IQlJ2JyLaOrpaga/vBZW4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 244/343] net: phy: mscc-miim: reject clause 45 register accesses
Date:   Tue, 12 Apr 2022 08:31:02 +0200
Message-Id: <20220412062958.372957379@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit 8d90991e5bf7fdb9f264f5f579d18969913054b7 ]

The driver doesn't support clause 45 register access yet, but doesn't
check if the access is a c45 one either. This leads to spurious register
reads and writes. Add the check.

Fixes: 542671fe4d86 ("net: phy: mscc-miim: Add MDIO driver")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-mscc-miim.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 64fb76c1e395..08381038810d 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -93,6 +93,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	u32 val;
 	int ret;
 
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	ret = mscc_miim_wait_pending(bus);
 	if (ret)
 		goto out;
@@ -136,6 +139,9 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	struct mscc_miim_dev *miim = bus->priv;
 	int ret;
 
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	ret = mscc_miim_wait_pending(bus);
 	if (ret < 0)
 		goto out;
-- 
2.35.1



