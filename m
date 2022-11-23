Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269936358A4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiKWKCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiKWKBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:01:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF5DDF81
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:53:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E51A6B81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F091C433D7;
        Wed, 23 Nov 2022 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197197;
        bh=6WXuu1TguYy4wHxQm4CIqH6Wif6rr0iBUDt7RiXs5Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYWpV7Nqd/PMi5+cR17eoFB1g3Gw6Ahb4ck9jOKSaoIvI+oIaO3JVu3uYjMWvHgGM
         Qgw7jdRqnZsRHZASwVO2HosPWSMl6ow3rKfMr/7aVTlq+7q32FgKssOafJJDKIJU0j
         9ZRLAyobqhYOm4wcQsqZJmuwkngkm/ANoBmD6Fdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Janne Grunau <j@jannau.net>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: [PATCH 6.0 225/314] usb: dwc3: Do not get extcon device when usb-role-switch is used
Date:   Wed, 23 Nov 2022 09:51:10 +0100
Message-Id: <20221123084635.721307731@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Janne Grunau <j@jannau.net>

commit d68cc25b7c7fb3034c5a5b5f350a0b858c6d5a45 upstream.

The change breaks device tree based platforms with PHY device and use
usb-role-switch instead of an extcon switch. extcon_find_edev_by_node()
will return EPROBE_DEFER if it can not find a device so probing without
an extcon device will be deferred indefinitely. Fix this by
explicitly checking for usb-role-switch.
At least the out-of-tree USB3 support on Apple silicon based platforms
using dwc3 with tipd USB Type-C and PD controller is affected by this
issue.

Fixes: d182c2e1bc92 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
Cc: stable@kernel.org
Signed-off-by: Janne Grunau <j@jannau.net>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20221106214804.2814-1-j@jannau.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1711,6 +1711,16 @@ static struct extcon_dev *dwc3_get_extco
 		return extcon_get_extcon_dev(name);
 
 	/*
+	 * Check explicitly if "usb-role-switch" is used since
+	 * extcon_find_edev_by_node() can not be used to check the absence of
+	 * an extcon device. In the absence of an device it will always return
+	 * EPROBE_DEFER.
+	 */
+	if (IS_ENABLED(CONFIG_USB_ROLE_SWITCH) &&
+	    device_property_read_bool(dev, "usb-role-switch"))
+		return NULL;
+
+	/*
 	 * Try to get an extcon device from the USB PHY controller's "port"
 	 * node. Check if it has the "port" node first, to avoid printing the
 	 * error message from underlying code, as it's a valid case: extcon


