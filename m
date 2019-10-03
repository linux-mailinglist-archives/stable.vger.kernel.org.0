Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4AFCA1A4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731056AbfJCP5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbfJCP5x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3322222C4;
        Thu,  3 Oct 2019 15:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118271;
        bh=yM8m71Be2pYqomVTYrjF2jhvY6jtc0hAN1c1ya7NIOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmQ+YXw+AtoetvejG4ttu2oDlp35mvEg6hMtf2bgTzLDVWK7uUCw0wqWKxdXrFBK8
         N7x7QSQM+eu9hMpWved9GkcYIJpiy9XxV1fhbbytt6rYR4Su5/kPdVGn5WmuioP6Vz
         eh79uqIj9kFLS6jSQSNrDPQBOMn4jVmRjGKLRKeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+1a35278dd0ebfb3a038a@syzkaller.appspotmail.com,
        syzbot+397fd082ce5143e2f67d@syzkaller.appspotmail.com,
        syzbot+06ddf1788cfd048c5e82@syzkaller.appspotmail.com
Subject: [PATCH 4.4 52/99] media: gspca: zero usb_buf on error
Date:   Thu,  3 Oct 2019 17:53:15 +0200
Message-Id: <20191003154321.620973331@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
index 0f6d57fbf91b7..624b4d24716dd 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -127,6 +127,11 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 value, u16 index)
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
index 599f755e75b86..7ebeee98dc1bb 100644
--- a/drivers/media/usb/gspca/nw80x.c
+++ b/drivers/media/usb/gspca/nw80x.c
@@ -1584,6 +1584,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index c95f32a0c02b4..c7aafdbb57384 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -2116,6 +2116,11 @@ static int reg_r(struct sd *sd, u16 index)
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
@@ -2142,6 +2147,11 @@ static int reg_r8(struct sd *sd,
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
index bfff1d1c70ab0..466f984312ddb 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -644,6 +644,11 @@ static u8 ov534_reg_read(struct gspca_dev *gspca_dev, u16 reg)
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
index 47085cf2d7236..f2dca06069355 100644
--- a/drivers/media/usb/gspca/ov534_9.c
+++ b/drivers/media/usb/gspca/ov534_9.c
@@ -1157,6 +1157,7 @@ static u8 reg_r(struct gspca_dev *gspca_dev, u16 reg)
 	if (ret < 0) {
 		pr_err("reg_r err %d\n", ret);
 		gspca_dev->usb_err = ret;
+		return 0;
 	}
 	return gspca_dev->usb_buf[0];
 }
diff --git a/drivers/media/usb/gspca/se401.c b/drivers/media/usb/gspca/se401.c
index 5102cea504710..6adbb0eca71fe 100644
--- a/drivers/media/usb/gspca/se401.c
+++ b/drivers/media/usb/gspca/se401.c
@@ -115,6 +115,11 @@ static void se401_read_req(struct gspca_dev *gspca_dev, u16 req, int silent)
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
index d0ee899584a9f..e5bd1e84fd875 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -924,6 +924,11 @@ static void reg_r(struct gspca_dev *gspca_dev, u16 reg, u16 length)
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
index 6696b2ec34e96..83e98b85ab6a1 100644
--- a/drivers/media/usb/gspca/sonixb.c
+++ b/drivers/media/usb/gspca/sonixb.c
@@ -466,6 +466,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index fd1c8706d86a8..67e23557a1a94 100644
--- a/drivers/media/usb/gspca/sonixj.c
+++ b/drivers/media/usb/gspca/sonixj.c
@@ -1175,6 +1175,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index f38fd8949609f..ee93bd443df5d 100644
--- a/drivers/media/usb/gspca/spca1528.c
+++ b/drivers/media/usb/gspca/spca1528.c
@@ -84,6 +84,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index e274cf19a3ea2..b236e9dcd4685 100644
--- a/drivers/media/usb/gspca/sq930x.c
+++ b/drivers/media/usb/gspca/sq930x.c
@@ -438,6 +438,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index 46c9f2229a186..cc3e1478c5a09 100644
--- a/drivers/media/usb/gspca/sunplus.c
+++ b/drivers/media/usb/gspca/sunplus.c
@@ -268,6 +268,11 @@ static void reg_r(struct gspca_dev *gspca_dev,
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
index b4efb2fb36fa3..5032b9d7d9bb2 100644
--- a/drivers/media/usb/gspca/vc032x.c
+++ b/drivers/media/usb/gspca/vc032x.c
@@ -2919,6 +2919,11 @@ static void reg_r_i(struct gspca_dev *gspca_dev,
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
index fb9fe2ef3a6f6..a74ac595656f7 100644
--- a/drivers/media/usb/gspca/w996Xcf.c
+++ b/drivers/media/usb/gspca/w996Xcf.c
@@ -139,6 +139,11 @@ static int w9968cf_read_sb(struct sd *sd)
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



