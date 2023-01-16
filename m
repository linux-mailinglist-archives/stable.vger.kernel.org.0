Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C78BA66C76B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjAPQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbjAPQaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:30:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C1839B90
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5097B80DC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDAAC433D2;
        Mon, 16 Jan 2023 16:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885908;
        bh=QwFuu3CnIEk/oQ6H/NihH3XYfYnYvYYir59m8oa/PZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJhIRGKKq3KH334mIgf7SaeQSm6ubji7pimsLO8oZ3k7i4guEwqLdkitfo42vBTO2
         KY1Q7qlip1BiodsPAhIrotvYcNlKN2zsFwjTtvaucboLI3LuiFt84/PkAYee6gXyRx
         ITSftpx/DJscaJKZzBeQnTeW/ZEQ6IFJ76Ue5f24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jerry Ray <jerry.ray@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/658] net: lan9303: Fix read error execution path
Date:   Mon, 16 Jan 2023 16:45:18 +0100
Message-Id: <20230116154920.045987782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Jerry Ray <jerry.ray@microchip.com>

[ Upstream commit 8964916d206071b058c6351f88b1966bd58cbde0 ]

This patch fixes an issue where a read failure of a port statistic counter
will return unknown results.  While it is highly unlikely the read will
ever fail, it is much cleaner to return a zero for the stat count.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221209153502.7429-1-jerry.ray@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e981b0184077..625db92792da 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1001,9 +1001,11 @@ static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
 		ret = lan9303_read_switch_port(
 			chip, port, lan9303_mib[u].offset, &reg);
 
-		if (ret)
+		if (ret) {
 			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
 				 port, lan9303_mib[u].offset);
+			reg = 0;
+		}
 		data[u] = reg;
 	}
 }
-- 
2.35.1



