Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE0A63DFC1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiK3SuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiK3SuL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D209D829
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91AA761B9D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41E7C433D6;
        Wed, 30 Nov 2022 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834210;
        bh=7EPRkVUBQYDyzRQxr5veA5LCGVvk0iYxBc6G0F3Mljo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQkcU/uaKK96jsQBGeGKxyOfSbT8WzBtLtmxOZ2gO3duISnt0hWOEdZGOi4osL7CY
         C0SCWsfdKpFUTz88Uh++bSbQCLgB4GIn+NcNT4xvfv2OKYBzT6C3nbXpr5J1GQTnPf
         3jUUC6MjLDiDcxDJWXLHXlMJS+ule7S9QeFCo4S0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Santiago=20Ruano=20Rinc=C3=B3n?= 
        <santiago.ruano-rincon@imt-atlantique.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 142/289] net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP
Date:   Wed, 30 Nov 2022 19:22:07 +0100
Message-Id: <20221130180547.357274617@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Santiago Ruano Rincón <santiago.ruano-rincon@imt-atlantique.fr>

[ Upstream commit 748064b54c99418f615aabff5755996cd9816969 ]

ZLP for DisplayLink ethernet devices was enabled in 6.0:
266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices").
The related driver_info should be the "same as cdc_ncm_info, but with
FLAG_SEND_ZLP". However, set_rx_mode that enables handling multicast
traffic was missing in the new cdc_ncm_zlp_info.

usbnet_cdc_update_filter rx mode was introduced in linux 5.9 with:
e10dcb1b6ba7 ("net: cdc_ncm: hook into set_rx_mode to admit multicast
traffic")

Without this hook, multicast, and then IPv6 SLAAC, is broken.

Fixes: 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices")
Signed-off-by: Santiago Ruano Rincón <santiago.ruano-rincon@imt-atlantique.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8d5cbda33f66..0897fdb6254b 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1915,6 +1915,7 @@ static const struct driver_info cdc_ncm_zlp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
-- 
2.35.1



