Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0875A6A72BD
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjCASIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCASIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:08:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86011AD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:08:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 442536144F
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58147C433EF;
        Wed,  1 Mar 2023 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694130;
        bh=m0shW6WaLT+TR50K0FG676x4YtadiBmJe7DU6Htwm7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qB50QjDADf1W8TYFuYHPLZWJGvLUGn1st9ky6YNzlu/+hzaptdayTGdP0orhOF1zU
         0JTnByS9/lFjZC5ZHD4CN0IZ9Z+lGW3yV48/73w55meyUj2P1JG5mvsmYKVaZzWRdc
         CiF3GsG67dv5Csoa6ejkKOXuv4HADRxbJ/CzgEys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 10/16] wifi: rtw88: usb: drop now unnecessary URB size check
Date:   Wed,  1 Mar 2023 19:07:46 +0100
Message-Id: <20230301180653.670493262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 462c8db6a01160836c68e262d25566f2447148d9 upstream.

Now that we send URBs with the URB_ZERO_PACKET flag set we no longer
need to make sure that the URB sizes are not multiple of the
bulkout_size. Drop the check.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230210111632.1985205-4-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -414,24 +414,11 @@ static int rtw_usb_write_data_rsvd_page(
 					u32 size)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
-	struct rtw_usb *rtwusb;
 	struct rtw_tx_pkt_info pkt_info = {0};
-	u32 len, desclen;
-
-	rtwusb = rtw_get_usb_priv(rtwdev);
 
 	pkt_info.tx_pkt_size = size;
 	pkt_info.qsel = TX_DESC_QSEL_BEACON;
-
-	desclen = chip->tx_pkt_desc_sz;
-	len = desclen + size;
-	if (len % rtwusb->bulkout_size == 0) {
-		len += RTW_USB_PACKET_OFFSET_SZ;
-		pkt_info.offset = desclen + RTW_USB_PACKET_OFFSET_SZ;
-		pkt_info.pkt_offset = 1;
-	} else {
-		pkt_info.offset = desclen;
-	}
+	pkt_info.offset = chip->tx_pkt_desc_sz;
 
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }


