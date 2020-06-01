Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10141EAE48
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbgFASwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730130AbgFASDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:03:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C02206E2;
        Mon,  1 Jun 2020 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034631;
        bh=vTiuuPdZ3Ws9Nr5uWveaDMUnc1Qy3ARDUxj/5B2CMz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r81CGX4taAuU64qDwl37PDLFh3iIB/cB3n2JbDLG9kXeXCweUDB7OUsT7RWU2s1H1
         6pLGlIFy28U4LnNdD290qnKi2JyEvPeej5oAMnPHf2BmTYGH14hYgV0tea6sLW1aT2
         +jLZ+ch9gKq+2t+pcvG1MPT2mV8rIponWKRcWSX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
        Cameron Gutman <aicommander@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/95] Input: xpad - add custom init packet for Xbox One S controllers
Date:   Mon,  1 Jun 2020 19:53:40 +0200
Message-Id: <20200601174027.188741386@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Łukasz Patron <priv.luk@gmail.com>

[ Upstream commit 764f7f911bf72450c51eb74cbb262ad9933741d8 ]

Sending [ 0x05, 0x20, 0x00, 0x0f, 0x06 ] packet for Xbox One S controllers
fixes an issue where controller is stuck in Bluetooth mode and not sending
any inputs.

Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
Reviewed-by: Cameron Gutman <aicommander@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200422075206.18229-1-priv.luk@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index aa4e431cbcd3..9adc72d65c63 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -472,6 +472,16 @@ static const u8 xboxone_fw2015_init[] = {
 	0x05, 0x20, 0x00, 0x01, 0x00
 };
 
+/*
+ * This packet is required for Xbox One S (0x045e:0x02ea)
+ * and Xbox One Elite Series 2 (0x045e:0x0b00) pads to
+ * initialize the controller that was previously used in
+ * Bluetooth mode.
+ */
+static const u8 xboxone_s_init[] = {
+	0x05, 0x20, 0x00, 0x0f, 0x06
+};
+
 /*
  * This packet is required for the Titanfall 2 Xbox One pads
  * (0x0e6f:0x0165) to finish initialization and for Hori pads
@@ -530,6 +540,8 @@ static const struct xboxone_init_packet xboxone_init_packets[] = {
 	XBOXONE_INIT_PKT(0x0e6f, 0x0165, xboxone_hori_init),
 	XBOXONE_INIT_PKT(0x0f0d, 0x0067, xboxone_hori_init),
 	XBOXONE_INIT_PKT(0x0000, 0x0000, xboxone_fw2015_init),
+	XBOXONE_INIT_PKT(0x045e, 0x02ea, xboxone_s_init),
+	XBOXONE_INIT_PKT(0x045e, 0x0b00, xboxone_s_init),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init1),
 	XBOXONE_INIT_PKT(0x0e6f, 0x0000, xboxone_pdp_init2),
 	XBOXONE_INIT_PKT(0x24c6, 0x541a, xboxone_rumblebegin_init),
-- 
2.25.1



