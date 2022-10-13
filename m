Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5AB45FE011
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiJMSD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiJMSDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:03:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6BD152C6F;
        Thu, 13 Oct 2022 11:02:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1650E6194E;
        Thu, 13 Oct 2022 17:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEA3C433C1;
        Thu, 13 Oct 2022 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683950;
        bh=DdUGzI2prsvOQgSs5XCjWOCD4D1KUOHY03lBWxbnGn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfMu0Gp7yesb1UTRu+0H9HaJlvpZQ/8CP4aKbLRkDoLZgFj1yc7ngpzAu5K1aC6mm
         Cm/6MXprnjbBH1paO7+70IzQXmIhgmM632gD+vCq3l2FCboebl0JOm7no3E2fdw56n
         H//f/+Xc9QbjgmkisswDWwNAzucV/df3vqC1fAo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.19 14/33] Revert "USB: fixup for merge issue with "usb: dwc3: Dont switch OTG -> peripheral if extcon is present""
Date:   Thu, 13 Oct 2022 19:52:46 +0200
Message-Id: <20221013175145.750236704@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
References: <20221013175145.236739253@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 2adc960ce79d3231b02f820daeee434542fe2911 upstream.

This reverts commit 8bd6b8c4b1009d7d2662138d6bdc6fe58a9274c5.

Prerequisite revert for the reverting of the original commit 0f0101719138.

Fixes: 8bd6b8c4b100 ("USB: fixup for merge issue with "usb: dwc3: Don't switch OTG -> peripheral if extcon is present"")
Fixes: 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")
Reported-by: Ferry Toth <fntoth@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Ferry Toth <fntoth@gmail.com> # for Merrifield
Link: https://lore.kernel.org/r/20220927155332.10762-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1650,8 +1650,13 @@ static struct extcon_dev *dwc3_get_extco
 	 * This device property is for kernel internal use only and
 	 * is expected to be set by the glue code.
 	 */
-	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0)
-		return extcon_get_extcon_dev(name);
+	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
+		edev = extcon_get_extcon_dev(name);
+		if (!edev)
+			return ERR_PTR(-EPROBE_DEFER);
+
+		return edev;
+	}
 
 	/*
 	 * Try to get an extcon device from the USB PHY controller's "port"


