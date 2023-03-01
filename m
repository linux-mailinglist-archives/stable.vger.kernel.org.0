Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273776A72CB
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCASKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjCASJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F7C6A64
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C91DB810D2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA02C4339B;
        Wed,  1 Mar 2023 18:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694164;
        bh=Ke+r10CTL5F/VXt8sDTtW2FppD3NBjJx+JgTswWJUb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUpjOoxebIvX7yNJaygpeEGZZWwFMR89JxivbxWlLnv9h8GePvegZHDFBvNNlKYDD
         kIs5SIVo+0DubS004cRacJbtYET+1PzDqeqWRyfR1i+xQUFozA/VZZ9OMvfyI6sPss
         Z4rxXrGucHStwuStGO1ztUuhig3EyHQx9CHczxLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 08/16] wifi: rtw88: usb: Set qsel correctly
Date:   Wed,  1 Mar 2023 19:07:44 +0100
Message-Id: <20230301180653.608343308@linuxfoundation.org>
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

commit 7869b834fb07c79933229840c98b02bbb7bd0d75 upstream.

We have to extract qsel from the skb before doing skb_push() on it,
otherwise qsel will always be 0.

Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230210111632.1985205-2-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -471,9 +471,9 @@ static int rtw_usb_tx_write(struct rtw_d
 	u8 *pkt_desc;
 	int ep;
 
+	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
-	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
 	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
 	rtw_tx_fill_tx_desc(pkt_info, skb);
 	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, skb->data);


