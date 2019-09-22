Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612DCBA420
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbfIVSqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:46:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389837AbfIVSqJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:46:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C439C206B6;
        Sun, 22 Sep 2019 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177967;
        bh=mcVwwUpCnN9fmn7EJZ59olz60UlNsWZ2hUma8Ewct/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqS/01SBUcjusUOr7Y0niKk3oX4+tjanaqYY25fPZM2D9Bm9vwkSNA5QdQICapHqG
         S5puAl1HsgKDCadM6Qneo1Ui44YB0rg6m3sCmufDB7+vHsjPIFEpJBmSeFLuKT9ea2
         oH5tNbnIYtKfAvYtDHqII7AmqnuHSHPCFhSYKauE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+1a35278dd0ebfb3a038a@syzkaller.appspotmail.com,
        syzbot+397fd082ce5143e2f67d@syzkaller.appspotmail.com,
        syzbot+06ddf1788cfd048c5e82@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 067/203] media: gspca: zero usb_buf on error
Date:   Sun, 22 Sep 2019 14:41:33 -0400
Message-Id: <20190922184350.30563-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
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
index d8e40137a2043..53db9a2895ea5 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -114,6 +114,11 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 value, u16 index)
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
index 59649704beba1..880f569bda30f 100644
--- a/drivers/media/usb/gspca/nw80x.c
+++ b/drivers/media/usb/gspca/nw80x.c
@@ -1572,6 +1572,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index cfb1f53bc17e7..f417dfc0b8729 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2073,6 +2073,11 @@ static int reg_r(struct sd *sd, u16 index)
 	} else {
 		gspca_err(gspca_dev, "reg_r %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
+		/*
+		 * Make sure the result is zeroed to avoid uninitialized
+		 * values.
+		 */
+		gspca_dev->usb_buf[0] = 0;
 	}
 
 	return ret;
@@ -2101,6 +2106,11 @@ static int reg_r8(struct sd *sd,
 	} else {
 		gspca_err(gspca_dev, "reg_r8 %02x failed %d\n", index, ret);
 		sd->gspca_dev.usb_err = ret;
+		/*
+		 * Make sure the buffer is zeroed to avoid uninitialized
+		 * values.
+		 */
+		memset(gspca_dev->usb_buf, 0, 8);
 	}
 
 	return ret;
diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 56521c991db45..185c1f10fb30b 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -693,6 +693,11 @@ static u8 ov534_reg_read(struct gspca_dev *gspca_dev, u16 reg)
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
index 867f860a96500..91efc650cf769 100644
--- a/drivers/media/usb/gspca/ov534_9.c
+++ b/drivers/media/usb/gspca/ov534_9.c
@@ -1145,6 +1145,7 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 reg)
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		return 0;
 	}
 	return gspca_dev->usb_buf[0];
 }
diff --git a/drivers/media/usb/gspca/se401.c b/drivers/media/usb/gspca/se401.c
index 061deee138c31..e087cfb5980b0 100644
--- a/drivers/media/usb/gspca/se401.c
+++ b/drivers/media/usb/gspca/se401.c
@@ -101,6 +101,11 @@ static void se401_read_req(struct gspca_dev *gspca_dev, u16 req, int silent)
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
index b43f89fee6c1d..12a2395a36ac6 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -909,6 +909,11 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
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
index 046fc2c2a1350..4d655e2da9cba 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -453,6 +453,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index 50a6c8425827f..2e1bd2df8304a 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -1162,6 +1162,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index 2ae03b60163ff..ccc477944ef82 100644
--- a/drivers/media/usb/gspca/spca1528.c
+++ b/drivers/media/usb/gspca/spca1528.c
@@ -71,6 +71,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index d1ba0888d7989..c3610247a90e0 100644
--- a/drivers/media/usb/gspca/sq930x.c
+++ b/drivers/media/usb/gspca/sq930x.c
@@ -425,6 +425,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index d0ddfa957ca9f..f4a4222f0d2e4 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -255,6 +255,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index 588a847ea4834..4cb7c92ea1328 100644
--- a/drivers/media/usb/gspca/vc032x.c
+++ b/drivers/media/usb/gspca/vc032x.c
@@ -2906,6 +2906,11 @@ static void reg_r_i(struct gspca_dev *gspca_dev,
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
index 16b679c2de21f..a8350ee9712fb 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -133,6 +133,11 @@ static int w9968cf_read_sb(struct sd *sd)
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

