Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E118628033
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbiKNNDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiKNNDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CDB27B1B
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74702B80EC0
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0165C433D6;
        Mon, 14 Nov 2022 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431028;
        bh=StCgyzm7gkwndRWA2DKlhtihBINN5ajmbQnWjeyTSuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+69in/8+5X6OFi9K3fxbaChpAUL2ZrrhqRwrlkG482WLMdTEHXECz58ttMN74bcz
         ClkdfB2bQ/GroGVVhkp9rOHrLq0lahB4WfzDN+YICydr+GNaTYFnxfFKLxeYxPEGP4
         6e8RdW1dKehV7SPzTqZOQIuAVli1Ew1pcnZE/4Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Anderson <sean.anderson@seco.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 043/190] net: fman: Unregister ethernet device on removal
Date:   Mon, 14 Nov 2022 13:44:27 +0100
Message-Id: <20221114124500.668679482@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index 39ae965cd4f6..b0c756b65cc2 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -882,12 +882,21 @@ static int mac_probe(struct platform_device *_of_dev)
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



