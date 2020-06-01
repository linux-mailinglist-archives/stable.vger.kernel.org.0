Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6061EA907
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgFAR6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgFAR6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D7E3206E2;
        Mon,  1 Jun 2020 17:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034281;
        bh=cefI0ZFCKQibzgsWiyF43o4I/K11S3pa1wEiuKrRIpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTxe0rFifNT0DhN8IgXCXfNQk5unBcLMbDZe30XFPxp7KXOpM1+ca82NqFptCEyJ9
         MK79sWpnFu9qFcnFS0W1OWSlvjzFgjXPX6z2JeW/nAcrksHBokfOlKa/FqiNa9IcMg
         QDWWCGTfmfcms80gNwaeyzl8CLxtk4B/68D2Y3qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>,
        Cameron Gutman <aicommander@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 23/61] Input: xpad - add custom init packet for Xbox One S controllers
Date:   Mon,  1 Jun 2020 19:53:30 +0200
Message-Id: <20200601174016.160258926@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
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
index 26476a64e663..54a6691d7d87 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -475,6 +475,16 @@ static const u8 xboxone_fw2015_init[] = {
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
@@ -533,6 +543,8 @@ static const struct xboxone_init_packet xboxone_init_packets[] = {
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



