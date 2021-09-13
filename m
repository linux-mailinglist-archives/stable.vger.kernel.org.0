Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD3409439
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345204AbhIMO3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345826AbhIMO1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:27:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E97F61B72;
        Mon, 13 Sep 2021 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540978;
        bh=arBhUMgIy071O92zHpDMFw21GCoEGmEvMtconCL+aPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHgPSfukLDQwynvCL9OCVnDwpak5zBWn1bgfbjed1BSr8Qz3IA/h071E9Tfv22aQ4
         LrjA6bFRgR818ac6Dbv+b72x7DFGd3n7kHky/eh9aEsXvJ0YBEhasq4mnERaVbhdxN
         lxodHY8LyOEWyrlwWXjwiX1BBH89WHi55FWV33OU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 113/334] media: dvb-usb: Fix error handling in dvb_usb_i2c_init
Date:   Mon, 13 Sep 2021 15:12:47 +0200
Message-Id: <20210913131117.186238001@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 131ae388b88e3daf4cb0721ed4b4cb8bfc201465 ]

In dvb_usb_i2c_init, if i2c_add_adapter fails, it only prints an error
message, and then continues to set DVB_USB_STATE_I2C. This affects the
logic of dvb_usb_i2c_exit, which leads to that, the deletion of i2c_adap
even if the i2c_add_adapter fails.

Fix this by returning at the failure of i2c_add_adapter and then move
dvb_usb_i2c_exit out of the error handling code of dvb_usb_i2c_init.

Fixes: 13a79f14ab28 ("media: dvb-usb: Fix memory leak at error in dvb_usb_device_init()")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c  | 9 +++++++--
 drivers/media/usb/dvb-usb/dvb-usb-init.c | 2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
index 2e07106f4680..bc4b2abdde1a 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
@@ -17,7 +17,8 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
 
 	if (d->props.i2c_algo == NULL) {
 		err("no i2c algorithm specified");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	strscpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
@@ -27,11 +28,15 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
 
 	i2c_set_adapdata(&d->i2c_adap, d);
 
-	if ((ret = i2c_add_adapter(&d->i2c_adap)) < 0)
+	ret = i2c_add_adapter(&d->i2c_adap);
+	if (ret < 0) {
 		err("could not add i2c adapter");
+		goto err;
+	}
 
 	d->state |= DVB_USB_STATE_I2C;
 
+err:
 	return ret;
 }
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-init.c b/drivers/media/usb/dvb-usb/dvb-usb-init.c
index 28e1fd64dd3c..61439c8f33ca 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-init.c
@@ -194,8 +194,8 @@ static int dvb_usb_init(struct dvb_usb_device *d, short *adapter_nums)
 
 err_adapter_init:
 	dvb_usb_adapter_exit(d);
-err_i2c_init:
 	dvb_usb_i2c_exit(d);
+err_i2c_init:
 	if (d->priv && d->props.priv_destroy)
 		d->props.priv_destroy(d);
 err_priv_init:
-- 
2.30.2



