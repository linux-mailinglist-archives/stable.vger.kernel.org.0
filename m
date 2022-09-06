Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16D5AEADB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbiIFNz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbiIFNxD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:53:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC227FF89;
        Tue,  6 Sep 2022 06:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05C3661539;
        Tue,  6 Sep 2022 13:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FECDC433D6;
        Tue,  6 Sep 2022 13:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471622;
        bh=kZZQgZNOWNb0uS5+JqWPB9O9PjOQu2pQWGFQnmKsyxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCzmgythir8O+/BwNdEk5WPdLzOEb7T+LKJgV+QmibNLjRjs14matOqz3TNtCAp4n
         omTAqynTKbPa5+oOGJCx129OdGZfkhu4qrCVvRRe+fTOrbFhkXWrCamqTSYgj6XUJk
         vZvkhyq4GqS2wkiF/HLUl1lnbLehNHjrOnR3nbDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saravana Kannan <saravanak@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: [PATCH 5.15 089/107] driver core: Dont probe devices after bus_type.match() probe deferral
Date:   Tue,  6 Sep 2022 15:31:10 +0200
Message-Id: <20220906132825.586859822@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 25e9fbf0fd38868a429feabc38abebfc6dbf6542 upstream.

Both __device_attach_driver() and __driver_attach() check the return
code of the bus_type.match() function to see if the device needs to be
added to the deferred probe list. After adding the device to the list,
the logic attempts to bind the device to the driver anyway, as if the
device had matched with the driver, which is not correct.

If __device_attach_driver() detects that the device in question is not
ready to match with a driver on the bus, then it doesn't make sense for
the device to attempt to bind with the current driver or continue
attempting to match with any of the other drivers on the bus. So, update
the logic in __device_attach_driver() to reflect this.

If __driver_attach() detects that a driver tried to match with a device
that is not ready to match yet, then the driver should not attempt to bind
with the device. However, the driver can still attempt to match and bind
with other devices on the bus, as drivers can be bound to multiple
devices. So, update the logic in __driver_attach() to reflect this.

Fixes: 656b8035b0ee ("ARM: 8524/1: driver cohandle -EPROBE_DEFER from bus_type.match()")
Cc: stable@vger.kernel.org
Cc: Saravana Kannan <saravanak@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Link: https://lore.kernel.org/r/20220817184026.3468620-1-isaacmanjarres@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -877,6 +877,11 @@ static int __device_attach_driver(struct
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		dev->can_match = true;
 		driver_deferred_probe_add(dev);
+		/*
+		 * Device can't match with a driver right now, so don't attempt
+		 * to match or bind with other drivers on the bus.
+		 */
+		return ret;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
 		return ret;
@@ -1115,6 +1120,11 @@ static int __driver_attach(struct device
 		dev_dbg(dev, "Device match requests probe deferral\n");
 		dev->can_match = true;
 		driver_deferred_probe_add(dev);
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
 		return ret;


