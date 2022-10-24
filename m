Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A6460B614
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiJXSro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiJXSrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:47:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6051DC4DD;
        Mon, 24 Oct 2022 10:28:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68BCBCE1323;
        Mon, 24 Oct 2022 12:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E56C433C1;
        Mon, 24 Oct 2022 12:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614339;
        bh=rkOgUST3oSkHxg+7+g1K8kfa2X5eSH4vqsowIX0lsq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaHHPtxMkow0plNrDOa9kbQdNYnqhHU5gNWLbacFZUk6ukPNtMpcHyfKqlBo7tjUM
         Hbbp/rkD2Yw5nLSTf98ixAprQBeOsL5d5Btg+MR7h0khMEl4C3aEJT2QoR7QImBbpR
         phTKQz0RfruawhUQ1A9h6m15Oi2idPeWiSFTt9s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/390] usb: ch9: Add USB 3.2 SSP attributes
Date:   Mon, 24 Oct 2022 13:29:48 +0200
Message-Id: <20221024113030.893275259@linuxfoundation.org>
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

[ Upstream commit f2fc9ff28d1c9bef7760516feadd38164044caae ]

In preparation for USB 3.2 dual-lane support, add sublink speed
attribute macros and enum usb_ssp_rate. A USB device that operates in
SuperSpeed Plus may operate at different speed and lane count. These
additional macros and enum values help specifying that.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/ae9293ebd63a29f2a2035054753534d9eb123d74.1610592135.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6155eaf6b05 ("usb: common: debug: Check non-standard control requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/usb/ch9.h      |  9 +++++++++
 include/uapi/linux/usb/ch9.h | 13 +++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 604c6c514a50..86c50907634e 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -36,6 +36,15 @@
 #include <linux/device.h>
 #include <uapi/linux/usb/ch9.h>
 
+/* USB 3.2 SuperSpeed Plus phy signaling rate generation and lane count */
+
+enum usb_ssp_rate {
+	USB_SSP_GEN_UNKNOWN = 0,
+	USB_SSP_GEN_2x1,
+	USB_SSP_GEN_1x2,
+	USB_SSP_GEN_2x2,
+};
+
 /**
  * usb_ep_type_string() - Returns human readable-name of the endpoint type.
  * @ep_type: The endpoint type to return human-readable name for.  If it's not
diff --git a/include/uapi/linux/usb/ch9.h b/include/uapi/linux/usb/ch9.h
index 0f865ae4ba89..17ce56198c9a 100644
--- a/include/uapi/linux/usb/ch9.h
+++ b/include/uapi/linux/usb/ch9.h
@@ -968,9 +968,22 @@ struct usb_ssp_cap_descriptor {
 	__le32 bmSublinkSpeedAttr[1]; /* list of sublink speed attrib entries */
 #define USB_SSP_SUBLINK_SPEED_SSID	(0xf)		/* sublink speed ID */
 #define USB_SSP_SUBLINK_SPEED_LSE	(0x3 << 4)	/* Lanespeed exponent */
+#define USB_SSP_SUBLINK_SPEED_LSE_BPS		0
+#define USB_SSP_SUBLINK_SPEED_LSE_KBPS		1
+#define USB_SSP_SUBLINK_SPEED_LSE_MBPS		2
+#define USB_SSP_SUBLINK_SPEED_LSE_GBPS		3
+
 #define USB_SSP_SUBLINK_SPEED_ST	(0x3 << 6)	/* Sublink type */
+#define USB_SSP_SUBLINK_SPEED_ST_SYM_RX		0
+#define USB_SSP_SUBLINK_SPEED_ST_ASYM_RX	1
+#define USB_SSP_SUBLINK_SPEED_ST_SYM_TX		2
+#define USB_SSP_SUBLINK_SPEED_ST_ASYM_TX	3
+
 #define USB_SSP_SUBLINK_SPEED_RSVD	(0x3f << 8)	/* Reserved */
 #define USB_SSP_SUBLINK_SPEED_LP	(0x3 << 14)	/* Link protocol */
+#define USB_SSP_SUBLINK_SPEED_LP_SS		0
+#define USB_SSP_SUBLINK_SPEED_LP_SSP		1
+
 #define USB_SSP_SUBLINK_SPEED_LSM	(0xff << 16)	/* Lanespeed mantissa */
 } __attribute__((packed));
 
-- 
2.35.1



