Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692C8CA9F7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389245AbfJCQR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:17:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388397AbfJCQR0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116FC215EA;
        Thu,  3 Oct 2019 16:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119444;
        bh=y3oK5sd44kw9hUTqZ2mEExDtnP5Ij6BKs401hcRk3Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kaf7EZDIxJWUquJPSWTBoIjUKPtP0XZcdKX2gbNQo7YXQJBPobK5frNro2F7m8RZb
         lUVHuvRabIkFhAipbDQKvdWLs8KBJhHso3tUCeWSBStEJY8Qd6a7rSuvkXoP8gSoo0
         R9ov35BkcQ0DhhTCjSWKP+ZTfQFZPKoNkcRI7Gpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1a35278dd0ebfb3a038a@syzkaller.appspotmail.com,
        syzbot+397fd082ce5143e2f67d@syzkaller.appspotmail.com,
        syzbot+06ddf1788cfd048c5e82@syzkaller.appspotmail.com
Subject: [PATCH 4.19 066/211] media: gspca: zero usb_buf on error
Date:   Thu,  3 Oct 2019 17:52:12 +0200
Message-Id: <20191003154503.628090419@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 989ae997f66de..89b9293b31bef 100644
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
index bedc04a72e97e..bde4441f935e7 100644
--- a/drivers/media/usb/gspca/nw80x.c
+++ b/drivers/media/usb/gspca/nw80x.c
@@ -1581,6 +1581,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index 10fcbe9e8614b..cb41e61d50dd3 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2083,6 +2083,11 @@ static int reg_r(struct sd *sd, u16 index)
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
@@ -2111,6 +2116,11 @@ static int reg_r8(struct sd *sd,
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
index d06dc0755b9a5..9e3326b66c792 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -642,6 +642,11 @@ static u8 ov534_reg_read(struct gspca_dev *gspca_dev, u16 reg)
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
index 3d1364d2f83e6..4d4ae22e96406 100644
--- a/drivers/media/usb/gspca/ov534_9.c
+++ b/drivers/media/usb/gspca/ov534_9.c
@@ -1154,6 +1154,7 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 reg)
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
index cfa2a04d9f3f6..a4ae029818586 100644
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
index df8d8482b7959..fa108ce000ad6 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -1171,6 +1171,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index d25924e430f37..a20eb8580db2e 100644
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
index d7cbcf2b39479..3521f5ff428e9 100644
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
index 437a3367ab974..26eae69a2562f 100644
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
index 52d0716596343..6e32264d3825a 100644
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
index abfab3de18662..ef0a839f9b8ae 100644
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



