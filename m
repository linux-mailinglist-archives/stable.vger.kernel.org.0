Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139D5371CC4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhECQ4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234112AbhECQxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873CE613C7;
        Mon,  3 May 2021 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060112;
        bh=Mh0jLuMpRlj7PT8ujy5fCajKV/bIs9e6tDZFhVfAW38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDGJLhQwWyGU7P3LeE1ZDlc5sgb05GsfDgXNtzphRMX4p3Iik3H0jp/Ubqzmk7lhK
         mJLAGkpvSJZbPn3cBJT5oSS9kj2a3fVopGxvoYSO9etSrPxH3DYSxe4viuFkuPcEC4
         eC3BM7e9IsdIU1nItcQ2YO0P85XEQImJ6Ofp7IbfTlSyG2y/y2vOugWF2wZMGAhnUo
         zZVsThMbA6NaFFpWPToX9o2lrlxiHHhjherUhkpM97CkeOyPVBRDGElRrQzNso5rx7
         3EqQ5g7gyjKgQJU3pgSBuTY0NDaVvne/w2hI+6e/RnVvmkh79lm3BEGfi12MDFHdtF
         g5rixIR4LoYRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+e7f4c64a4248a0340c37@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/35] media: gscpa/stv06xx: fix memory leak
Date:   Mon,  3 May 2021 12:41:02 -0400
Message-Id: <20210503164109.2853838-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index 93212ed80bf8..f0562b8eef56 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1586,6 +1586,8 @@ int gspca_dev_probe2(struct usb_interface *intf,
 #endif
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	v4l2_device_unregister(&gspca_dev->v4l2_dev);
+	if (sd_desc->probe_error)
+		sd_desc->probe_error(gspca_dev);
 	kfree(gspca_dev->usb_buf);
 	kfree(gspca_dev);
 	return ret;
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index b0ced2e14006..a6554d5e9e1a 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -105,6 +105,7 @@ struct sd_desc {
 	cam_cf_op config;	/* called on probe */
 	cam_op init;		/* called on probe and resume */
 	cam_op init_controls;	/* called on probe */
+	cam_v_op probe_error;	/* called if probe failed, do cleanup here */
 	cam_op start;		/* called on stream on after URBs creation */
 	cam_pkt_op pkt_scan;
 /* optional operations */
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index b7ea4f982964..ccec6138f678 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -538,12 +538,21 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
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

