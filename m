Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB14CF4F9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiCGJYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiCGJWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:22:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7385866C95;
        Mon,  7 Mar 2022 01:20:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C0DBB810B2;
        Mon,  7 Mar 2022 09:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B446C340E9;
        Mon,  7 Mar 2022 09:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644843;
        bh=qQGPmeaAYFXyIjtv0HVDAMGkMn9oVjkstYLU3NOcbuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRktDqWTx/ki93fL+PpDRNIMdeM3M/oIV9hq1XTsH4RpqIs9R4U1hqkM9S/KIy8//
         FJdPoUgtStFo9AfJ4LIExOWayXp5gb2vlg/G7FsHowbS+CoStrqP8whnOle51NX8xB
         WxrO4m2OXF59FseocAKylroXk142cjJlSV+x4VUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 08/32] net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990
Date:   Mon,  7 Mar 2022 10:18:34 +0100
Message-Id: <20220307091634.680134851@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091634.434478485@linuxfoundation.org>
References: <20220307091634.434478485@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 21e8a96377e6b6debae42164605bf9dcbe5720c5 ]

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FN990
0x1071 composition in order to avoid bind error.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index d86132d41416d..95256765b3887 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -652,6 +652,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FN990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1071, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.34.1



