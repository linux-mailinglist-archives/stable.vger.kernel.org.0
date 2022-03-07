Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F31B4CF61C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbiCGJd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237759AbiCGJdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:33:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37426AA72;
        Mon,  7 Mar 2022 01:30:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C037F61185;
        Mon,  7 Mar 2022 09:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B564EC36AE2;
        Mon,  7 Mar 2022 09:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645388;
        bh=n5T1+I/pmeyijBxU7FOIfuJEcV3dxvkqCaFuwww8pfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMu31jaBRiNECbZ+YdxX2I1Fx3f581AlqoXH20bXD2g0At0yY5Q+2OJKAd1T4BFb+
         IGW8DYajVLiRmxWlwJoNI4dbEDqjub9k1IHHbECExZoHG3v0YDnZNm/Rjxa070ZgsB
         6xeNb0wQ5tDIQj+9v6aX4XVvBTb8VPWH+hBncQWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/105] net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990
Date:   Mon,  7 Mar 2022 10:18:18 +0100
Message-Id: <20220307091644.613697554@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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
index 77ac5a721e7b6..414341c9cf5ae 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -658,6 +658,11 @@ static const struct usb_device_id mbim_devs[] = {
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



