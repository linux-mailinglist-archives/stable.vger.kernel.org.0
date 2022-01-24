Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD8E49902F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbiAXT6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:58:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50274 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352389AbiAXTwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:52:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E600D60916;
        Mon, 24 Jan 2022 19:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D049AC340E5;
        Mon, 24 Jan 2022 19:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053972;
        bh=Otfz0U8maTLEn+Irs0y44lE82ilMaXIVy8OqHKRQp7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjFgCH6xCGUNGpd3TD/LFWfAIvJ+bwd44q3FSHsEdUl5ox264i91o1lI2kTzAfIDv
         FYFzxOlF0ki7GmpAb6WkIvR5l51QkgUqSMXAzrDcQo8vFelGObUHePvatNaRrItcTq
         4mM67mUhQOHi8JsExcFtZGTvG0eUn7ZAm1CZXSu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Subject: [PATCH 5.10 237/563] net: mcs7830: handle usb read errors properly
Date:   Mon, 24 Jan 2022 19:40:02 +0100
Message-Id: <20220124184032.642319486@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit d668769eb9c52b150753f1653f7f5a0aeb8239d2 ]

Syzbot reported uninit value in mcs7830_bind(). The problem was in
missing validation check for bytes read via usbnet_read_cmd().

usbnet_read_cmd() internally calls usb_control_msg(), that returns
number of bytes read. Code should validate that requested number of bytes
was actually read.

So, this patch adds missing size validation check inside
mcs7830_get_reg() to prevent uninit value bugs

Reported-and-tested-by: syzbot+003c0a286b9af5412510@syzkaller.appspotmail.com
Fixes: 2a36d7083438 ("USB: driver for mcs7830 (aka DeLOCK) USB ethernet adapter")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20220106225716.7425-1-paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/mcs7830.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/mcs7830.c b/drivers/net/usb/mcs7830.c
index 09bfa6a4dfbc1..7e40e2e2f3723 100644
--- a/drivers/net/usb/mcs7830.c
+++ b/drivers/net/usb/mcs7830.c
@@ -108,8 +108,16 @@ static const char driver_name[] = "MOSCHIP usb-ethernet driver";
 
 static int mcs7830_get_reg(struct usbnet *dev, u16 index, u16 size, void *data)
 {
-	return usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
-				0x0000, index, data, size);
+	int ret;
+
+	ret = usbnet_read_cmd(dev, MCS7830_RD_BREQ, MCS7830_RD_BMREQ,
+			      0x0000, index, data, size);
+	if (ret < 0)
+		return ret;
+	else if (ret < size)
+		return -ENODATA;
+
+	return ret;
 }
 
 static int mcs7830_set_reg(struct usbnet *dev, u16 index, u16 size, const void *data)
-- 
2.34.1



