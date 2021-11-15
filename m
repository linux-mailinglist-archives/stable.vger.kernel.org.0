Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BDA45135D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348185AbhKOTut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245709AbhKOTVD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F51E632EC;
        Mon, 15 Nov 2021 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001580;
        bh=rc8XOJMOmpEbpYsG8zZOl51LRqyLmsNhcatKgb2d/og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vh/Rwj+Bm4DPWoUUsVvYCQfdl7932jrDeq88ulbrRj3NvQQRwnNpCoO30FSjpDuW
         4TtwX4T/Sjwjez7fO2omX6q9fz3aYAuWnYEA9sjax42VMtNxn/Y4GFDlN5miv47jaE
         LJpacglDwSxQlg8E5bWP+mftlN7S+Lz75NbgBLlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/917] media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()
Date:   Mon, 15 Nov 2021 17:55:40 +0100
Message-Id: <20211115165437.106117064@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit 899a61a3305d49e8a712e9ab20d0db94bde5929f ]

In dibusb_read_eeprom_byte(), if dibusb_i2c_msg() fails, val gets
assigned an value that's not properly initialized.
Using kzalloc() in place of kmalloc() for the buffer fixes this issue,
as the val can now be set to 0 in the event dibusb_i2c_msg() fails.

Reported-by: syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com
Tested-by: syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index 02b51d1a1b67c..aff60c10cb0b2 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -223,7 +223,7 @@ int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
 	u8 *buf;
 	int rc;
 
-	buf = kmalloc(2, GFP_KERNEL);
+	buf = kzalloc(2, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-- 
2.33.0



