Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3CA2E6485
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404542AbgL1Pu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:50:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391894AbgL1Nlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:41:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE764208B3;
        Mon, 28 Dec 2020 13:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162864;
        bh=6j8gNj3ChfDsSKFT31tCf5q7DGa1g8dy5yXaBnO5t3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnf1OB2QqflmaHy9JpuNTEXlQSrryXs7EU6bptn/mziS7JQfC5As/NIZs4gCLRpob
         hN3LLEycCGThIiaKsyO8kCuShiDr8+5qGkfAfObxWaZARMm4QcUsxUZkxJrhR2CA6M
         Lf4OQY31asnYt3ieXnakOY1exuKc3JQyeo100CL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot+c60ddb60b685777d9d59@syzkaller.appspotmail.com
Subject: [PATCH 5.4 070/453] media: msi2500: assign SPI bus number dynamically
Date:   Mon, 28 Dec 2020 13:45:06 +0100
Message-Id: <20201228124940.615848762@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -1230,7 +1230,7 @@ static int msi2500_probe(struct usb_inte
 	}
 
 	dev->master = master;
-	master->bus_num = 0;
+	master->bus_num = -1;
 	master->num_chipselect = 1;
 	master->transfer_one_message = msi2500_transfer_one_message;
 	spi_master_set_devdata(master, dev);


