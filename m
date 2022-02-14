Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94A24B4C03
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241007AbiBNKhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348578AbiBNKfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:35:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7503A1403D;
        Mon, 14 Feb 2022 02:02:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C55AA60DB6;
        Mon, 14 Feb 2022 10:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5FAC340E9;
        Mon, 14 Feb 2022 10:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832929;
        bh=QUbM7KdwbE8IIg6s+KSNgkwa6QdsfZam6rBpBp172II=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBGvHjI5JppNAbR2scJpM2MgTyFlytrD0SZFvLxEpOR3AQBmMnauSbgXgGGM/BhyI
         Ee4NdFpiQ3AeQ+abuHv7IW7jzjfn14yggO7GJRyDOio3LAVgIwOYEsEb1vQtgSFxRB
         DeVU/S95b4Q64nmDBrFG9SHyhZ6O8AdvbpwEJFxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 5.16 169/203] usb: ulpi: Move of_node_put to ulpi_dev_release
Date:   Mon, 14 Feb 2022 10:26:53 +0100
Message-Id: <20220214092515.992255592@linuxfoundation.org>
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
@@ -130,6 +130,7 @@ static const struct attribute_group *ulp
 
 static void ulpi_dev_release(struct device *dev)
 {
+	of_node_put(dev->of_node);
 	kfree(to_ulpi_dev(dev));
 }
 
@@ -299,7 +300,6 @@ EXPORT_SYMBOL_GPL(ulpi_register_interfac
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	of_node_put(ulpi->dev.of_node);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);


