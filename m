Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5FA266096
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 15:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgIKNru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 09:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgIKNXr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:23:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 500EA22245;
        Fri, 11 Sep 2020 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829100;
        bh=RvG0LabYpbq2WLZtN6SzuRj9R/uwwGt6Z8i5qgMdsA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FF3ivPmg123PDyEy5Cnvu9eRuUK7FtPgoI9C2sc8SE828BYyC8gR0DvZMbKSHisE
         DHmpaW633vS8G6gCZC2+K7/w++TKCC1cVmA/DLDaaTUWi0xWTB9MYhfmkcblWaRcm/
         T819vD5S824vGbeTF09sAJZ2xjlp+ZtI1sHRB6n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/71] drivers: net: usb: qmi_wwan: add QMI_QUIRK_SET_DTR for Telit PID 0x1201
Date:   Fri, 11 Sep 2020 14:46:21 +0200
Message-Id: <20200911122506.777401165@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>

[ Upstream commit 14cf4a771b3098e431d2677e3533bdd962e478d8 ]

Telit LE920A4 uses the same pid 0x1201 of LE920, but modem
implementation is different, since it requires DTR to be set for
answering to qmi messages.

This patch replaces QMI_FIXED_INTF with QMI_QUIRK_SET_DTR: tests on
LE920 have been performed in order to verify backward compatibility.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 97a83d351a100..6104500314d18 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -927,7 +927,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
-	{QMI_FIXED_INTF(0x1bc7, 0x1201, 2)},	/* Telit LE920 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1201, 2)},	/* Telit LE920, LE920A4 */
 	{QMI_FIXED_INTF(0x1c9e, 0x9b01, 3)},	/* XS Stick W100-2 from 4G Systems */
 	{QMI_FIXED_INTF(0x0b3c, 0xc000, 4)},	/* Olivetti Olicard 100 */
 	{QMI_FIXED_INTF(0x0b3c, 0xc001, 4)},	/* Olivetti Olicard 120 */
-- 
2.25.1



