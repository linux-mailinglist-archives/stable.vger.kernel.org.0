Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F1681192
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjA3OOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbjA3OOo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:14:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0BA2C663
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:14:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 278D3B810C5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B48C433EF;
        Mon, 30 Jan 2023 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088080;
        bh=ebyvD34D+PRgNoMDHayHCTt8bvc0PVoaIRc9WHDv2y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybQeSYBavMmFNcpHCUG86yIizQP0+54cIw3en3ob4Ba6Gvsm+TUSoTP1RYmdX+G1U
         MVqgzC4v4nCwUwEzLTh7JdcZ2l+LalOu0DSp1oFGLo5r6nzsbbT7DsdJM2hLKSbtZk
         hiiFETKvbAXYVspYx9hkiwppYqXWnGulsFDPi3Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Wang <hui.wang@canonical.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/204] net: usb: cdc_ether: add support for Thales Cinterion PLS62-W modem
Date:   Mon, 30 Jan 2023 14:51:06 +0100
Message-Id: <20230130134320.782330398@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit eea8ce81fbb544e3caad1a1c876ba1af467b3d3c ]

This modem has 7 interfaces, 5 of them are serial interfaces and are
driven by cdc_acm, while 2 of them are wwan interfaces and are driven
by cdc_ether:
If 0: Abstract (modem)
If 1: Abstract (modem)
If 2: Abstract (modem)
If 3: Abstract (modem)
If 4: Abstract (modem)
If 5: Ethernet Networking
If 6: Ethernet Networking

Without this change, the 2 network interfaces will be named to usb0
and usb1, our QA think the names are confusing and filed a bug on it.

After applying this change, the name will be wwan0 and wwan1, and
they could work well with modem manager.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20230105034249.10433-1-hui.wang@canonical.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ether.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index c6b0de1b752f..3497b5a286ea 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -1000,6 +1000,12 @@ static const struct usb_device_id	products[] = {
 				      USB_CDC_SUBCLASS_ETHERNET,
 				      USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&wwan_info,
+}, {
+	/* Cinterion PLS62-W modem by GEMALTO/THALES */
+	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x005b, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET,
+				      USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&wwan_info,
 }, {
 	/* Cinterion PLS83/PLS63 modem by GEMALTO/THALES */
 	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x0069, USB_CLASS_COMM,
-- 
2.39.0



