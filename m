Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0F4B4C2F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348065AbiBNKhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348907AbiBNKgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:36:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FAC6578C;
        Mon, 14 Feb 2022 02:02:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0CF5B80DA6;
        Mon, 14 Feb 2022 10:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DB5C340E9;
        Mon, 14 Feb 2022 10:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832941;
        bh=lrgQINDT48P+sKYwHswUTTKmWWrF21F0fKyR27zr+30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qg5nthrBUd8CvzGRDNhb+DVlMhNK45mdTDs4seiE+PiOOFDG/xvSU+DcIUexx2VmD
         Q5XbEzVZ/1RYBReDerUV2V6yqpCKfBx6Kl9taMO9AG8iunCA9lQJORSbqxhMFtFLbR
         UrSggCHkRM2oN5OxPaBjd0/FCa3pXHCaGnqDfBZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Adam Ford <aford173@gmail.com>
Subject: [PATCH 5.16 172/203] usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition
Date:   Mon, 14 Feb 2022 10:26:56 +0100
Message-Id: <20220214092516.090095409@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

commit 459702eea6132888b5c5b64c0e9c626da4ec2493 upstream.

The support the external role switch a variety of situations were
addressed, but the transition from USB_ROLE_HOST to USB_ROLE_NONE
leaves the host up which can cause some error messages when
switching from host to none, to gadget, to none, and then back
to host again.

 xhci-hcd ee000000.usb: Abort failed to stop command ring: -110
 xhci-hcd ee000000.usb: xHCI host controller not responding, assume dead
 xhci-hcd ee000000.usb: HC died; cleaning up
 usb 4-1: device not accepting address 6, error -108
 usb usb4-port1: couldn't allocate usb_device

After this happens it will not act as a host again.
Fix this by releasing the host mode when transitioning to USB_ROLE_NONE.

Fixes: 0604160d8c0b ("usb: gadget: udc: renesas_usb3: Enhance role switch support")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20220128223603.2362621-1-aford173@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/renesas_usb3.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -2378,6 +2378,8 @@ static void handle_ext_role_switch_state
 	switch (role) {
 	case USB_ROLE_NONE:
 		usb3->connection_state = USB_ROLE_NONE;
+		if (cur_role == USB_ROLE_HOST)
+			device_release_driver(host);
 		if (usb3->driver)
 			usb3_disconnect(usb3);
 		usb3_vbus_out(usb3, false);


