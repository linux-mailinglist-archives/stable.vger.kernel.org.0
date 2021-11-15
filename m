Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A77450B3E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbhKORUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237332AbhKORTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDDEA63266;
        Mon, 15 Nov 2021 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996454;
        bh=qtXxlFZzBOL9sJ0Wkl11C77hb6pOVp2j3GqCwfL4QhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urjwCJllAmWttYeLFJchHxCMZAB6GUGLnHkZx8ocI3RVnB0FQG+dmObFda85chwZt
         x9r8mNqRLUr/nBfRhBwhGGVy0zahldnE2dKJJrmUYXd+XV7yA96RDtaM6WaMwFTzvi
         83WIagcP+dPCpJNYzaBnsbkhBdhAtOqtAwHAvr4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/355] media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()
Date:   Mon, 15 Nov 2021 18:01:10 +0100
Message-Id: <20211115165318.512730144@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 59ce2dec11e98..9c1ebea68b544 100644
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



