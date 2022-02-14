Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC7B4B47E9
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244325AbiBNJhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:37:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244728AbiBNJgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA3A25E90;
        Mon, 14 Feb 2022 01:34:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF38BB80DD4;
        Mon, 14 Feb 2022 09:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0215BC340E9;
        Mon, 14 Feb 2022 09:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831225;
        bh=Vt6o6BUJUwenqkWrho+49oDACU5otjZPlwM4QWb24DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pln6plE1Z0+eZ/NczPXJz4k7a/pRebacrAbsK9Mu/FU+CJq6TvAQAtxtwb5dpcDaK
         C1eMV2OV9C0npZoTb9LR2MtzPG6qrx5yerfznxM6YLTQd3plr8YSEZn5ZBI4aYTo6c
         ghP25YrLcaY0kezU6nXZSjPXTMBRouZsqgtRJ3D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 4.19 37/49] usb: ulpi: Move of_node_put to ulpi_dev_release
Date:   Mon, 14 Feb 2022 10:26:03 +0100
Message-Id: <20220214092449.522306451@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@seco.com>

commit 092f45b13e51666fe8ecbf2d6cd247aa7e6c1f74 upstream.

Drivers are not unbound from the device when ulpi_unregister_interface
is called. Move of_node-freeing code to ulpi_dev_release which is called
only after all users are gone.

Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Link: https://lore.kernel.org/r/20220127190004.1446909-2-sean.anderson@seco.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -132,6 +132,7 @@ static const struct attribute_group *ulp
 
 static void ulpi_dev_release(struct device *dev)
 {
+	of_node_put(dev->of_node);
 	kfree(to_ulpi_dev(dev));
 }
 
@@ -300,7 +301,6 @@ EXPORT_SYMBOL_GPL(ulpi_register_interfac
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	of_node_put(ulpi->dev.of_node);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);


