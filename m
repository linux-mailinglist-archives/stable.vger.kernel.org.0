Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D082480099
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240290AbhL0Pr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240615AbhL0Pp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B837CC08E8AE;
        Mon, 27 Dec 2021 07:42:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 563EB61123;
        Mon, 27 Dec 2021 15:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0EEC36AE7;
        Mon, 27 Dec 2021 15:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619750;
        bh=mTOBn3GTcsadfbZatSuZTGvpy/t7xXshmI2tB4l7F/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTpNuvSxv12lFwjaCwmQ/UnT4LnYFekURm1IW0jOqiyAR5bIBCcTHAhzu1aw5QOoF
         G3lDkDnIc3ecA9YQeUtAeA0PtXXAh6hFzFnsIlrcQ2NpRzpgGV+u/Cvn6F1JBbeq+Q
         aoDYDU//0782cRevFh50i61dgILRDMMALbLUE8mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/128] r8152: fix the force speed doesnt work for RTL8156
Date:   Mon, 27 Dec 2021 16:30:24 +0100
Message-Id: <20211227151333.152523601@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit 45bf944e6703d43fe5e285808312acd8a34c1a24 ]

It needs to set mdio force mode. Otherwise, link off always occurs when
setting force speed.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d3da350777a4d..3364e54c177ff 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6584,6 +6584,21 @@ static bool rtl8153_in_nway(struct r8152 *tp)
 		return true;
 }
 
+static void r8156_mdio_force_mode(struct r8152 *tp)
+{
+	u16 data;
+
+	/* Select force mode through 0xa5b4 bit 15
+	 * 0: MDIO force mode
+	 * 1: MMD force mode
+	 */
+	data = ocp_reg_read(tp, 0xa5b4);
+	if (data & BIT(15)) {
+		data &= ~BIT(15);
+		ocp_reg_write(tp, 0xa5b4, data);
+	}
+}
+
 static void set_carrier(struct r8152 *tp)
 {
 	struct net_device *netdev = tp->netdev;
@@ -8016,6 +8031,7 @@ static void r8156_init(struct r8152 *tp)
 	ocp_data |= ACT_ODMA;
 	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_CONFIG, ocp_data);
 
+	r8156_mdio_force_mode(tp);
 	rtl_tally_reset(tp);
 
 	tp->coalesce = 15000;	/* 15 us */
@@ -8145,6 +8161,7 @@ static void r8156b_init(struct r8152 *tp)
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
 
+	r8156_mdio_force_mode(tp);
 	rtl_tally_reset(tp);
 
 	tp->coalesce = 15000;	/* 15 us */
-- 
2.34.1



