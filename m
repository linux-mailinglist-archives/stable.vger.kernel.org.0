Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732874125A3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349380AbhITSqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383437AbhITSoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8877A63357;
        Mon, 20 Sep 2021 17:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159177;
        bh=2+f0q9COo9y3qm6fO0LOOCVmBLhraM8f7noOmNchM60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PX21X4DDO3w7ImVvm8FoBDlJtV4N77C1Ne3zzRLIzy40aS96Yl09VW9qyCvAtLSsv
         YKXFfvWP24auoeGHKIvjgprCz+1z32oUW4JylU1JCk02ofceS1t0n4o0Whhcpa8Q9h
         eoUv6vFR00Z3HUaYUiygN+Oo7koBzPU0HZuA56Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 112/168] net: usb: cdc_mbim: avoid altsetting toggling for Telit LN920
Date:   Mon, 20 Sep 2021 18:44:10 +0200
Message-Id: <20210920163925.320031775@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit aabbdc67f3485b5db27ab4eba01e5fbf1ffea62c ]

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit LN920
0x1061 composition in order to avoid bind error.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 4c4ab7b38d78..82bb5ed94c48 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -654,6 +654,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit LN920 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1061, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.30.2



