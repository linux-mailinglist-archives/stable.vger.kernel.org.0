Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85163BA929
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436640AbfIVTMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438752AbfIVS6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:58:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C16208C2;
        Sun, 22 Sep 2019 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178691;
        bh=IDiLjBDkhdSTYy13LJPXeb2vgRK8rk/1PZIMxmnGyW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEGsLUeGEdG7/WGHsN0rabWx9bzdFG2YIYj/1Xw2A50T/RSA+cefpW78pUo55ZfVE
         jTNVEmwggqB5tV9TKV/jitAKcp1g79K7v6sgvp2i36gFp5qYxnCMrH+5GWWRxM4qIu
         oHpomSzOll/9y1KDQ95jcesPD8ttgMRvcQawtwSc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+1a35278dd0ebfb3a038a@syzkaller.appspotmail.com,
        syzbot+397fd082ce5143e2f67d@syzkaller.appspotmail.com,
        syzbot+06ddf1788cfd048c5e82@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 32/89] media: gspca: zero usb_buf on error
Date:   Sun, 22 Sep 2019 14:56:20 -0400
Message-Id: <20190922185717.3412-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 4843a543fad3bf8221cf14e5d5f32d15cee89e84 ]

If reg_r() fails, then gspca_dev->usb_buf was left uninitialized,
and some drivers used the contents of that buffer in logic.

This caused several syzbot errors:

https://syzkaller.appspot.com/bug?extid=397fd082ce5143e2f67d
https://syzkaller.appspot.com/bug?extid=1a35278dd0ebfb3a038a
https://syzkaller.appspot.com/bug?extid=06ddf1788cfd048c5e82

I analyzed the gspca drivers and zeroed the buffer where needed.

Reported-and-tested-by: syzbot+1a35278dd0ebfb3a038a@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+397fd082ce5143e2f67d@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+06ddf1788cfd048c5e82@syzkaller.appspotmail.com

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/gspca/konica.c   |  5 +++++
 drivers/media/usb/gspca/nw80x.c    |  5 +++++
 drivers/media/usb/gspca/ov519.c    | 10 ++++++++++
 drivers/media/usb/gspca/ov534.c    |  5 +++++
 drivers/media/usb/gspca/ov534_9.c  |  1 +
 drivers/media/usb/gspca/se401.c    |  5 +++++
 drivers/media/usb/gspca/sn9c20x.c  |  5 +++++
 drivers/media/usb/gspca/sonixb.c   |  5 +++++
 drivers/media/usb/gspca/sonixj.c   |  5 +++++
 drivers/media/usb/gspca/spca1528.c |  5 +++++
 drivers/media/usb/gspca/sq930x.c   |  5 +++++
 drivers/media/usb/gspca/sunplus.c  |  5 +++++
 drivers/media/usb/gspca/vc032x.c   |  5 +++++
 drivers/media/usb/gspca/w996Xcf.c  |  5 +++++
 14 files changed, 71 insertions(+)

diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
index 31b2117e8f1df..4fac3315cfe69 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -123,6 +123,11 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 value, u16 index)
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, 2);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/nw80x.c b/drivers/media/usb/gspca/nw80x.c
index 5d2d0bcb038d3..4c95341864da4 100644
--- a/drivers/media/usb/gspca/nw80x.c
+++ b/drivers/media/usb/gspca/nw80x.c
@@ -1580,6 +1580,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 		return;
 	}
 	if (len == 1)
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index cdb79c5f0c382..8106a47a0dd0e 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2083,6 +2083,11 @@ static int reg_r(struct sd *sd, u16 index)
 	} else {
 		PERR("reg_r %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
+		/*
+		 * Make sure the result is zeroed to avoid uninitialized
+		 * values.
+		 */
+		gspca_dev->usb_buf[0] = 0;
 	}
 
 	return ret;
@@ -2111,6 +2116,11 @@ static int reg_r8(struct sd *sd,
 	} else {
 		PERR("reg_r8 %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, 8);
 	}
 
 	return ret;
diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 32849ff86b09d..25c0d349fdab2 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -641,6 +641,11 @@ static u8 ov534_reg_read(struct gspca_dev *gspca_dev, u16 reg)
 	if (ret < 0) {
 		pr_err("read failed %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the result is zeroed to avoid uninitialized
+		 * values.
+		 */
+		gspca_dev->usb_buf[0] = 0;
 	}
 	return gspca_dev->usb_buf[0];
 }
diff --git a/drivers/media/usb/gspca/ov534_9.c b/drivers/media/usb/gspca/ov534_9.c
index b2a92e518118f..dadfe1effbc2a 100644
--- a/drivers/media/usb/gspca/ov534_9.c
+++ b/drivers/media/usb/gspca/ov534_9.c
@@ -1153,6 +1153,7 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 reg)
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		return 0;
 	}
 	return gspca_dev->usb_buf[0];
 }
diff --git a/drivers/media/usb/gspca/se401.c b/drivers/media/usb/gspca/se401.c
index 477da0664b7da..40b87717bb5c5 100644
--- a/drivers/media/usb/gspca/se401.c
+++ b/drivers/media/usb/gspca/se401.c
@@ -111,6 +111,11 @@ static void se401_read_req(struct gspca_dev *gspca_dev, u16 req, int silent)
 			pr_err("read req failed req %#04x error %d\n",
 			       req, err);
 		gspca_dev->usb_err = err;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, READ_REQ_SIZE);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index c605f78d61867..e013441fd30ab 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -918,6 +918,11 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
 	if (unlikely(result < 0 || result != length)) {
 		pr_err("Read register %02x failed %d\n", reg, result);
 		gspca_dev->usb_err = result;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
index 5f3f2979540a6..22de65d840dd3 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -462,6 +462,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
 		dev_err(gspca_dev->v4l2_dev.dev,
 			"Error reading register %02x: %d\n", value, res);
 		gspca_dev->usb_err = res;
+		/*
+		 * Make sure the result is zeroed to avoid uninitialized
+		 * values.
+		 */
+		gspca_dev->usb_buf[0] = 0;
 	}
 }
 
diff --git a/drivers/media/usb/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
index 5eeaf16ac5e82..c53002a5ccb7f 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -1170,6 +1170,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/spca1528.c b/drivers/media/usb/gspca/spca1528.c
index 327ec901abe14..769a9d95d2fa0 100644
--- a/drivers/media/usb/gspca/spca1528.c
+++ b/drivers/media/usb/gspca/spca1528.c
@@ -80,6 +80,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/sq930x.c b/drivers/media/usb/gspca/sq930x.c
index aa9a9411b8018..a3e261685ebd9 100644
--- a/drivers/media/usb/gspca/sq930x.c
+++ b/drivers/media/usb/gspca/sq930x.c
@@ -434,6 +434,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (ret < 0) {
 		pr_err("reg_r %04x failed %d\n", value, ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
index 8c2785aea3cd0..d87fcff38310b 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -264,6 +264,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 	}
 }
 
diff --git a/drivers/media/usb/gspca/vc032x.c b/drivers/media/usb/gspca/vc032x.c
index b935febf71468..c026c513f65f7 100644
--- a/drivers/media/usb/gspca/vc032x.c
+++ b/drivers/media/usb/gspca/vc032x.c
@@ -2915,6 +2915,11 @@ static void reg_r_i(struct gspca_dev *gspca_dev,
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, USB_BUF_SZ);
 	}
 }
 static void reg_r(struct gspca_dev *gspca_dev,
diff --git a/drivers/media/usb/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
index 728d2322c433a..cd10e717c7e53 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -143,6 +143,11 @@ static int w9968cf_read_sb(struct sd *sd)
 	} else {
 		pr_err("Read SB reg [01] failed\n");
 		sd->gspca_dev.usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(sd->gspca_dev.usb_buf, 0, 2);
 	}
 
 	udelay(W9968CF_I2C_BUS_DELAY);
-- 
2.20.1

