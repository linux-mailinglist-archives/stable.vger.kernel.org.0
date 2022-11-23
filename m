Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596A763535C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbiKWIyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiKWIyM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D2AEA110
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:54:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2136361B39
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D08CC433C1;
        Wed, 23 Nov 2022 08:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193650;
        bh=oCCPlbpKrMHaJImOKsqMoWFRu9iY1ThLt9ZT215XqVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVeSb0aXYwxrJ9WWGog7Wy79GQFCDRuVPLZ1o7w7qmdgWe8AGoJlpv4UNEOahXwgT
         wLTAGRUHjDSxPfwD13ta4qrTXr+Ug3MWEBiOh79x474WTWCc5CtHoNP0rXtEh+8yit
         9Vb8snSllH+m6gN3HIOoPM7OnOIGrhqa9aegco6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Anderson <sean.anderson@seco.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/76] net: fman: Unregister ethernet device on removal
Date:   Wed, 23 Nov 2022 09:50:03 +0100
Message-Id: <20221123084546.887822922@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit b7cbc6740bd6ad5d43345a2504f7e4beff0d709f ]

When the mac device gets removed, it leaves behind the ethernet device.
This will result in a segfault next time the ethernet device accesses
mac_dev. Remove the ethernet device when we get removed to prevent
this. This is not completely reversible, since some resources aren't
cleaned up properly, but that can be addressed later.

Fixes: 3933961682a3 ("fsl/fman: Add FMan MAC driver")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20221103182831.2248833-1-sean.anderson@seco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 93b7ed361b82..dca6fd114bb5 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -953,12 +953,21 @@ static int mac_probe(struct platform_device *_of_dev)
 	return err;
 }
 
+static int mac_remove(struct platform_device *pdev)
+{
+	struct mac_device *mac_dev = platform_get_drvdata(pdev);
+
+	platform_device_unregister(mac_dev->priv->eth_dev);
+	return 0;
+}
+
 static struct platform_driver mac_driver = {
 	.driver = {
 		.name		= KBUILD_MODNAME,
 		.of_match_table	= mac_match,
 	},
 	.probe		= mac_probe,
+	.remove		= mac_remove,
 };
 
 builtin_platform_driver(mac_driver);
-- 
2.35.1



