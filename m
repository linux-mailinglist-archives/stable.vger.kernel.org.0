Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9740167433
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbgBUITP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:19:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387971AbgBUITO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:19:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC8A124689;
        Fri, 21 Feb 2020 08:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273153;
        bh=3NpJQF7sZ1rITlgoBsr5kQbSK6labd42PMgCJEzJibE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AMuvzIK2Z6l/iE2Zv/uMcAGvTEPNjjvm8oiWhm8j7jKvLgU0d6tH5HNd0rG8LbWgt
         ltmnhAV/8B3Y3wL3GFnkaD86oMzQfrzA7pWJS4xHlEQc9aPq45dhpi9qcuOGCHruUh
         gOXx99cgIAksSKPxQahY12HgslF9OUGRP5Ene3XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Forest Crossman <cyrozap@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/191] media: cx23885: Add support for AVerMedia CE310B
Date:   Fri, 21 Feb 2020 08:40:38 +0100
Message-Id: <20200221072259.190768039@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Forest Crossman <cyrozap@gmail.com>

[ Upstream commit dc4cac67e13515835ed8081d510aa507aacb013b ]

The AVerMedia CE310B is a simple composite + S-Video + stereo audio
capture card, and uses only the CX23888 to perform all of these
functions.

I've tested both video inputs and the audio interface and confirmed that
they're all working. However, there are some issues:

* Sometimes when I switch inputs the video signal turns black and can't
  be recovered until the system is rebooted. I haven't been able to
  determine the cause of this behavior, nor have I found a solution to
  fix it or any workarounds other than rebooting.
* The card sometimes seems to have trouble syncing to the video signal,
  and some of the VBI data appears as noise at the top of the frame, but
  I assume that to be a result of my very noisy RF environment and the
  card's unshielded input traces rather than a configuration issue.

Signed-off-by: Forest Crossman <cyrozap@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 24 +++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-video.c |  3 ++-
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index ed3210dc50bc2..642aefdbb7bb6 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -811,6 +811,25 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "Hauppauge WinTV-Starburst2",
 		.portb		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_AVERMEDIA_CE310B] = {
+		.name		= "AVerMedia CE310B",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   = CX25840_VIN1_CH1 |
+				  CX25840_NONE_CH2 |
+				  CX25840_NONE0_CH3,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   = CX25840_VIN8_CH1 |
+				  CX25840_NONE_CH2 |
+				  CX25840_VIN7_CH3 |
+				  CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		} },
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -1134,6 +1153,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0xf02a,
 		.card      = CX23885_BOARD_HAUPPAUGE_STARBURST2,
+	}, {
+		.subvendor = 0x1461,
+		.subdevice = 0x3100,
+		.card      = CX23885_BOARD_AVERMEDIA_CE310B,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -2358,6 +2381,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_T982:
 	case CX23885_BOARD_VIEWCAST_260E:
 	case CX23885_BOARD_VIEWCAST_460E:
+	case CX23885_BOARD_AVERMEDIA_CE310B:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index f8a3deadc77a1..2a20c7165e1e8 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -268,7 +268,8 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 		(dev->board == CX23885_BOARD_MYGICA_X8507) ||
 		(dev->board == CX23885_BOARD_AVERMEDIA_HC81R) ||
 		(dev->board == CX23885_BOARD_VIEWCAST_260E) ||
-		(dev->board == CX23885_BOARD_VIEWCAST_460E)) {
+		(dev->board == CX23885_BOARD_VIEWCAST_460E) ||
+		(dev->board == CX23885_BOARD_AVERMEDIA_CE310B)) {
 		/* Configure audio routing */
 		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
 			INPUT(input)->amux, 0, 0);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index cf965efabe666..7bbd62cc993ef 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -111,6 +111,7 @@
 #define CX23885_BOARD_HAUPPAUGE_STARBURST2     59
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_DVB_885 60
 #define CX23885_BOARD_HAUPPAUGE_QUADHD_ATSC_885 61
+#define CX23885_BOARD_AVERMEDIA_CE310B         62
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.20.1



