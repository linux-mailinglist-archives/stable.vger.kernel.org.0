Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B38371D9A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhECRBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 13:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233476AbhECQ5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:57:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51EE613D8;
        Mon,  3 May 2021 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060227;
        bh=rzLJr4NPvUoJ9S1sFYRQh7XXMA7S1bVIX8URu8MP7QU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlWe58A/ThSl55B9UzfYUrTIcRVtD3dnWD1sTOMsex9CIvcCSAfy7hMPHuzZzMeNF
         UXoz61CWglauIvHCLfEeyEEkWQBlHAoXRElbLpslUR264Gdr+TzHxkP87INHo0tZva
         gG6RsIh8fh85qBbd9GQyKBmJThzZ1TDyEAT7MneajWNOn54aYru7BvqtKnPBc3nqO1
         PT83qULXUNzEy6/gGSswIO8+tAyjbiKK3bBJQbDzfxnjmFO0Ad0kbtr8vSiPC6fHAj
         KfbNX2pdp2NIF50nngovzTV4jS09RjmmMuBiBwdrHyifCvdw/jW93gBFyNGyYsNhSM
         VYMb4HLGj7kYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+e7f4c64a4248a0340c37@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 12/16] media: gscpa/stv06xx: fix memory leak
Date:   Mon,  3 May 2021 12:43:25 -0400
Message-Id: <20210503164329.2854739-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 4f4e6644cd876c844cdb3bea2dd7051787d5ae25 ]

For two of the supported sensors the stv06xx driver allocates memory which
is stored in sd->sensor_priv. This memory is freed on a disconnect, but if
the probe() fails, then it isn't freed and so this leaks memory.

Add a new probe_error() op that drivers can use to free any allocated
memory in case there was a probe failure.

Thanks to Pavel Skripkin <paskripkin@gmail.com> for discovering the cause
of the memory leak.

Reported-and-tested-by: syzbot+e7f4c64a4248a0340c37@syzkaller.appspotmail.com

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/gspca.c           | 2 ++
 drivers/media/usb/gspca/gspca.h           | 1 +
 drivers/media/usb/gspca/stv06xx/stv06xx.c | 9 +++++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 17b7b02330c9..a4f64bdb8017 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -2131,6 +2131,8 @@ int gspca_dev_probe2(struct usb_interface *intf,
 #endif
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	v4l2_device_unregister(&gspca_dev->v4l2_dev);
+	if (sd_desc->probe_error)
+		sd_desc->probe_error(gspca_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index d39adf90303b..bec8fccc2c94 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -101,6 +101,7 @@ struct sd_desc {
 	cam_cf_op config;	/* called on probe */
 	cam_op init;		/* called on probe and resume */
 	cam_op init_controls;	/* called on probe */
+	cam_v_op probe_error;	/* called if probe failed, do cleanup here */
 	cam_op start;		/* called on stream on after URBs creation */
 	cam_pkt_op pkt_scan;
 /* optional operations */
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 7d255529ed4c..40d4c99debb8 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -541,12 +541,21 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 static int stv06xx_config(struct gspca_dev *gspca_dev,
 			  const struct usb_device_id *id);
 
+static void stv06xx_probe_error(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *)gspca_dev;
+
+	kfree(sd->sensor_priv);
+	sd->sensor_priv = NULL;
+}
+
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
 	.config = stv06xx_config,
 	.init = stv06xx_init,
 	.init_controls = stv06xx_init_controls,
+	.probe_error = stv06xx_probe_error,
 	.start = stv06xx_start,
 	.stopN = stv06xx_stopN,
 	.pkt_scan = stv06xx_pkt_scan,
-- 
2.30.2

