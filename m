Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701DF12CA0F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbfL2RYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:42836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbfL2RYS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:24:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 795E020722;
        Sun, 29 Dec 2019 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640258;
        bh=RdOumJe78D5hSFV/Gm1nJcy+IR1yZq0/pHgHotHVxJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEbE7+CFpgK2+TeQSeg5XYxSeOkvPd2ml4DEEIcG0rkjsqzlyTugl5oVzWguPDEKu
         tgq09aNmHBgjLMWvUAmOtTJ+/ks8/ivRz4BU4D4OsPrHVTw/fe6ogGU/CGohnuklJa
         LDsP67rNCbLzkCWPac+bf2MwFh3nqPm09sJapjuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Sean Paul <sean@poorly.run>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/161] drm/bridge: dw-hdmi: Refuse DDC/CI transfers on the internal I2C controller
Date:   Sun, 29 Dec 2019 18:18:13 +0100
Message-Id: <20191229162413.132592817@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit bee447e224b2645911c5d06e35dc90d8433fcef6 ]

The DDC/CI protocol involves sending a multi-byte request to the
display via I2C, which is typically followed by a multi-byte
response. The internal I2C controller only allows single byte
reads/writes or reads of 8 sequential bytes, hence DDC/CI is not
supported when the internal I2C controller is used. The I2C
transfers complete without errors, however the data in the response
is garbage. Abort transfers to/from slave address 0x37 (DDC) with
-EOPNOTSUPP, to make it evident that the communication is failing.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Sean Paul <sean@poorly.run>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20191002124354.v2.1.I709dfec496f5f0b44a7b61dcd4937924da8d8382@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
index 4db31b89507c..0febaafb8d89 100644
--- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
+++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
@@ -39,6 +39,7 @@
 
 #include <media/cec-notifier.h>
 
+#define DDC_CI_ADDR		0x37
 #define DDC_SEGMENT_ADDR	0x30
 
 #define HDMI_EDID_LEN		512
@@ -320,6 +321,15 @@ static int dw_hdmi_i2c_xfer(struct i2c_adapter *adap,
 	u8 addr = msgs[0].addr;
 	int i, ret = 0;
 
+	if (addr == DDC_CI_ADDR)
+		/*
+		 * The internal I2C controller does not support the multi-byte
+		 * read and write operations needed for DDC/CI.
+		 * TOFIX: Blacklist the DDC/CI address until we filter out
+		 * unsupported I2C operations.
+		 */
+		return -EOPNOTSUPP;
+
 	dev_dbg(hdmi->dev, "xfer: num: %d, addr: %#x\n", num, addr);
 
 	for (i = 0; i < num; i++) {
-- 
2.20.1



