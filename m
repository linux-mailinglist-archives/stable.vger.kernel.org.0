Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68FB6157AC
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiKBCg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiKBCgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:36:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC234FAFD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86D3C617C0
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B78FC433C1;
        Wed,  2 Nov 2022 02:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356584;
        bh=8cAaK32h6neTPDAftD1s79XJH/9oHpmAl+edYdb/adc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbYnwgwvDphfDP9FX4Mg4XVPChjlEP3n6xymVk3o4AoZ6Qkjug+5rqzpEezJy73J9
         MUh0FojK1169M1sWVWXjFx4d5lq8hWuVOm6lO3Bo8ap9lTg1Jaf7clyDx2jnvljDmR
         33ZHbk3Pg20uBS/V/c+O1pFu4v7x5mJ1/8BbEtX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zev Weiss <zev@bewilderbeest.net>,
        Jae Hyun Yoo <quic_jaehyoo@quicinc.com>,
        Joel Stanley <joel@jms.id.au>
Subject: [PATCH 6.0 024/240] usb: gadget: aspeed: Fix probe regression
Date:   Wed,  2 Nov 2022 03:29:59 +0100
Message-Id: <20221102022111.951893377@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Stanley <joel@jms.id.au>

commit 48ed32482c4100069d0c0eebdc6b198c6ae5f71f upstream.

Since commit fc274c1e9973 ("USB: gadget: Add a new bus for gadgets"),
the gadget devices are proper driver core devices, which caused each
device to request pinmux settings:

 aspeed_vhub 1e6a0000.usb-vhub: Initialized virtual hub in USB2 mode
 aspeed-g5-pinctrl 1e6e2080.pinctrl: pin A7 already requested by 1e6a0000.usb-vhub; cannot claim for gadget.0
 aspeed-g5-pinctrl 1e6e2080.pinctrl: pin-232 (gadget.0) status -22
 aspeed-g5-pinctrl 1e6e2080.pinctrl: could not request pin 232 (A7) from group USB2AD  on device aspeed-g5-pinctrl
 g_mass_storage gadget.0: Error applying setting, reverse things back

The vhub driver has already claimed the pins, so prevent the gadgets
from requesting them too by setting the magic of_node_reused flag. This
causes the driver core to skip the mux request.

Reported-by: Zev Weiss <zev@bewilderbeest.net>
Reported-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Fixes: fc274c1e9973 ("USB: gadget: Add a new bus for gadgets")
Cc: stable@vger.kernel.org
Signed-off-by: Joel Stanley <joel@jms.id.au>
Tested-by: Zev Weiss <zev@bewilderbeest.net>
Tested-by: Jae Hyun Yoo <quic_jaehyoo@quicinc.com>
Link: https://lore.kernel.org/r/20221017053006.358520-1-joel@jms.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/aspeed-vhub/dev.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/dev.c
@@ -591,6 +591,7 @@ int ast_vhub_init_dev(struct ast_vhub *v
 		d->gadget.max_speed = USB_SPEED_HIGH;
 	d->gadget.speed = USB_SPEED_UNKNOWN;
 	d->gadget.dev.of_node = vhub->pdev->dev.of_node;
+	d->gadget.dev.of_node_reused = true;
 
 	rc = usb_add_gadget_udc(d->port_dev, &d->gadget);
 	if (rc != 0)


