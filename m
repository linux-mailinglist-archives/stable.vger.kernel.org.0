Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5C96A72CD
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCASKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjCASJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:09:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363B239BAB
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:09:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D243DB810EE
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDF1C433EF;
        Wed,  1 Mar 2023 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694167;
        bh=lHniOpzs4HdqPnBXOB8sQQfe0Waf7GG9+upik+/4H7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KWY16IOpXBfTvvGcC5VENN9tqtbs9zdq8G5eeQbrxxsdrjR2EC5gDiILfRSYW5/ZJ
         ewp4nXtZzFrFU9qie3qCGaehCm7iZYJUPmbgIm6g/93/3U6GhYH0HjWlrzP3LvFUKY
         +fVpgrO0VoP5YSq8VPfFCBRjJNUyb2bneW/iygzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.2 09/16] wifi: rtw88: usb: send Zero length packets if necessary
Date:   Wed,  1 Mar 2023 19:07:45 +0100
Message-Id: <20230301180653.639532304@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 07ce9fa6ab0e5e4cb5516a1f7c754ab2758fe5cd upstream.

Zero length packets are necessary when sending URBs with size
multiple of bulkout_size, otherwise the hardware just stalls.

Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230210111632.1985205-3-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -271,6 +271,7 @@ static int rtw_usb_write_port(struct rtw
 		return -ENOMEM;
 
 	usb_fill_bulk_urb(urb, usbd, pipe, skb->data, skb->len, cb, context);
+	urb->transfer_flags |= URB_ZERO_PACKET;
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
 
 	usb_free_urb(urb);


