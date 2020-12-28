Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4B52E37CE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbgL1NAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729513AbgL1NAm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:00:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A31E522582;
        Mon, 28 Dec 2020 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160427;
        bh=32N3iBa7n5TJdAl+gIU8U6PfxFqNxfabR2e5sxFeG04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/ximupigvadfxW135KkSgjuXimTlM35G8VlG9JzwfK2zkJtVY5RaBCbUb0cgMM1W
         5o/M38v0WiNXRN4KOD1ePl4e9M90JFCLb6w2H0hPK6BQwZCcqavYRcvxi1BTSiQ0Fj
         gsbIlNQ9NR7hiLzIgmgtRwUJaSsAZ3P3eROOKtdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+c60ddb60b685777d9d59@syzkaller.appspotmail.com
Subject: [PATCH 4.9 047/175] media: msi2500: assign SPI bus number dynamically
Date:   Mon, 28 Dec 2020 13:48:20 +0100
Message-Id: <20201228124855.535574802@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antti Palosaari <crope@iki.fi>

commit 9c60cc797cf72e95bb39f32316e9f0e5f85435f9 upstream.

SPI bus number must be assigned dynamically for each device, otherwise it
will crash when multiple devices are plugged to system.

Reported-and-tested-by: syzbot+c60ddb60b685777d9d59@syzkaller.appspotmail.com

Cc: stable@vger.kernel.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/msi2500/msi2500.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1250,7 +1250,7 @@ static int msi2500_probe(struct usb_inte
 	}
 
 	dev->master = master;
-	master->bus_num = 0;
+	master->bus_num = -1;
 	master->num_chipselect = 1;
 	master->transfer_one_message = msi2500_transfer_one_message;
 	spi_master_set_devdata(master, dev);


