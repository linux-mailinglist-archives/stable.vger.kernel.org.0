Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA95FE16F
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiJMSjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiJMSje (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:39:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA61E52ED;
        Thu, 13 Oct 2022 11:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2A68B82088;
        Thu, 13 Oct 2022 18:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20486C433B5;
        Thu, 13 Oct 2022 18:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684068;
        bh=LZaqBYHcuIQk2aCRBz6Wyb3wafhltmWSwGIA3LWDVLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pg2lnftp3t0pKetKpRqvheCsL29mWACkln/gfDvF2gdL59dNOoirVBqUlpfRl7UtC
         sWJlT1QE8Caf1EdKOIs1GUwRTp/AVw2IMEXJ8DPpyTVN79y7KsKbbkgKQCvaUhqSzq
         d1hIcqB5AaGRbUsllkdYpaDXUAYI2CFF1vzaafm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ferry Toth <fntoth@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.0 15/34] Revert "USB: fixup for merge issue with "usb: dwc3: Dont switch OTG -> peripheral if extcon is present""
Date:   Thu, 13 Oct 2022 19:52:53 +0200
Message-Id: <20221013175146.916141650@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
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
@@ -1684,8 +1684,13 @@ static struct extcon_dev *dwc3_get_extco
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


