Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335D92E142A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgLWCW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbgLWCW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90AC0229CA;
        Wed, 23 Dec 2020 02:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690129;
        bh=2pl4ejSP8/OhAcZMJCfdsl5czk+mOsk9D0P0/E5v1O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uVhAfGd3+emtlT2/Qeu+i7X9yBz3Ys6F42+LeXDAE/KxG1jGtuywUHsSZUs9PoT4A
         4eDBOMhibHk9hejUii6ppLHgjtKmWIdyQdhWy3tfSFTPOA3m9tsNg2N17KdH8+8z4o
         wvaYaZQMYsJUgJratijhOByNBc0pjtIrQpjRdR4XUWH03+v+YO8Qp+9nCrK7GwGzM9
         RdDuVErbnkyhWRrHAe7m/jAEx9u/LzVVbXg11mVCMu6QORDJOE0ckxFboKuuC2dJEj
         wDYB5L8CwZfKMN0BqRF00+Ji1JxDED3WDkKaclo7pZ+8V9FJ/tZant5ChO1AEOVb6c
         P6r68tWuafSDQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 53/87] media: gp8psk: initialize stats at power control logic
Date:   Tue, 22 Dec 2020 21:20:29 -0500
Message-Id: <20201223022103.2792705-53-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit d0ac1a26ed5943127cb0156148735f5f52a07075 ]

As reported on:
	https://lore.kernel.org/linux-media/20190627222020.45909-1-willemdebruijn.kernel@gmail.com/

if gp8psk_usb_in_op() returns an error, the status var is not
initialized. Yet, this var is used later on, in order to
identify:
	- if the device was already started;
	- if firmware has loaded;
	- if the LNBf was powered on.

Using status = 0 seems to ensure that everything will be
properly powered up.

So, instead of the proposed solution, let's just set
status = 0.

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/gp8psk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 13e96b0aeb0fc..d97eab01cb8c7 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -185,7 +185,7 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 
 static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	u8 status, buf;
+	u8 status = 0, buf;
 	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
 
 	if (onoff) {
-- 
2.27.0

