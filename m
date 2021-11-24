Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB7545BD17
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343931AbhKXMfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:35:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343604AbhKXMdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:33:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C6C561163;
        Wed, 24 Nov 2021 12:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756437;
        bh=4QXA8Sz8+uy2QwtIoTw8eT2RxQ41eRuIz/FE6ziP7eI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXn15gu0KtpjbpLqT4KKtnYDgwoUzpknquucrU9wE1itEbrbaOAGsDV6NpQrM/vSd
         VytWJ+K5+zjNhxxvmL4FEfF+jUY0OmFJ7I9EDlYBC3Vl0X7ZZpqKiZUv7OpiTlyHkE
         9Kaxo1MEBAqah+amCiNg+Q5LkoHvysVx0IXv5cJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e27b4fd589762b0b9329@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/251] media: usb: dvd-usb: fix uninit-value bug in dibusb_read_eeprom_byte()
Date:   Wed, 24 Nov 2021 12:55:28 +0100
Message-Id: <20211124115713.245927123@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index bcacb0f220282..3e45642ae186b 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -226,7 +226,7 @@ int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
 	u8 *buf;
 	int rc;
 
-	buf = kmalloc(2, GFP_KERNEL);
+	buf = kzalloc(2, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-- 
2.33.0



