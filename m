Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C062160AA4A
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiJXNcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236279AbiJXNaV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9C6AC480;
        Mon, 24 Oct 2022 05:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1844F61297;
        Mon, 24 Oct 2022 12:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7FBC433C1;
        Mon, 24 Oct 2022 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614255;
        bh=Gxa3rXUFxkd8SLn9Ts36YPdcxnaQL3Du9o3r46StfhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkMgd1XuOIlzzeMyZW3/NwIwI9sOAGuyxPP+adhfOJnSbY2ugkMScHyC/auVOi7kt
         JwL6vaqlqEIryJWBWjeLHZvUhUu85tyheWmwDo3rH+IZS+ovjslhkIdxv9w1bbjz5A
         BrSvqR17k49M97E8ul9t9XzJTPl6rHsZBV2j61O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/390] usb: common: Parse for USB SSP genXxY
Date:   Mon, 24 Oct 2022 13:29:49 +0200
Message-Id: <20221024113030.942254530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 52c2d15703c3a900d5f78cd599b823db40d5100b ]

The USB "maximum-speed" property can now take the SSP signaling rate
generation and lane count with these new strings:

"super-speed-plus-gen2x2"
"super-speed-plus-gen2x1"
"super-speed-plus-gen1x2"

Introduce usb_get_maximum_ssp_rate() to parse for the corresponding
usb_ssp_rate enum. The original usb_get_maximum_speed() will return
USB_SPEED_SUPER_PLUS if it matches one of these new strings.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/f8ed896313d8cd8e2d2b540fc82db92b3ddf8a47.1611106162.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6155eaf6b05 ("usb: common: debug: Check non-standard control requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/common.c | 26 +++++++++++++++++++++++++-
 include/linux/usb/ch9.h     | 11 +++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index 1433260d99b4..fc21cf2d36f6 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -69,6 +69,13 @@ static const char *const speed_names[] = {
 	[USB_SPEED_SUPER_PLUS] = "super-speed-plus",
 };
 
+static const char *const ssp_rate[] = {
+	[USB_SSP_GEN_UNKNOWN] = "UNKNOWN",
+	[USB_SSP_GEN_2x1] = "super-speed-plus-gen2x1",
+	[USB_SSP_GEN_1x2] = "super-speed-plus-gen1x2",
+	[USB_SSP_GEN_2x2] = "super-speed-plus-gen2x2",
+};
+
 const char *usb_speed_string(enum usb_device_speed speed)
 {
 	if (speed < 0 || speed >= ARRAY_SIZE(speed_names))
@@ -86,12 +93,29 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
+	ret = match_string(ssp_rate, ARRAY_SIZE(ssp_rate), maximum_speed);
+	if (ret > 0)
+		return USB_SPEED_SUPER_PLUS;
 
+	ret = match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
 	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
 EXPORT_SYMBOL_GPL(usb_get_maximum_speed);
 
+enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev)
+{
+	const char *maximum_speed;
+	int ret;
+
+	ret = device_property_read_string(dev, "maximum-speed", &maximum_speed);
+	if (ret < 0)
+		return USB_SSP_GEN_UNKNOWN;
+
+	ret = match_string(ssp_rate, ARRAY_SIZE(ssp_rate), maximum_speed);
+	return (ret < 0) ? USB_SSP_GEN_UNKNOWN : ret;
+}
+EXPORT_SYMBOL_GPL(usb_get_maximum_ssp_rate);
+
 const char *usb_state_string(enum usb_device_state state)
 {
 	static const char *const names[] = {
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 86c50907634e..abdd310c77f0 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -71,6 +71,17 @@ extern const char *usb_speed_string(enum usb_device_speed speed);
  */
 extern enum usb_device_speed usb_get_maximum_speed(struct device *dev);
 
+/**
+ * usb_get_maximum_ssp_rate - Get the signaling rate generation and lane count
+ *	of a SuperSpeed Plus capable device.
+ * @dev: Pointer to the given USB controller device
+ *
+ * If the string from "maximum-speed" property is super-speed-plus-genXxY where
+ * 'X' is the generation number and 'Y' is the number of lanes, then this
+ * function returns the corresponding enum usb_ssp_rate.
+ */
+extern enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev);
+
 /**
  * usb_state_string - Returns human readable name for the state.
  * @state: The state to return a human-readable name for. If it's not
-- 
2.35.1



