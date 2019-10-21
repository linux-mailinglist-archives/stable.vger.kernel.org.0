Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0FDEF64
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfJUOZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:25:10 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:10359 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfJUOZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 10:25:10 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2019 10:25:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=12469; q=dns/txt;
  s=iport; t=1571667909; x=1572877509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6IjaSG9TOV1k3+tG7ar4TNl3WU964D+pOGUprL9v/Tg=;
  b=AhP0csPb1+6nRMgNHlM4ilopXSA9eQpeIrIvmfQ7B5VGBE18u0KNQ2xd
   7kbUB3LLaA/C3o5MWSY/NkavZ5HE4mNNqf3OcGfZ9BCFrt7ilB+u8pQj9
   l8rZGZbnAsr7twalAjI4vpxwRsWQwcjyDErVFugtpUwMJIKQtznH3e7Bp
   U=;
X-IronPort-AV: E=Sophos;i="5.67,323,1566864000"; 
   d="scan'208";a="18251355"
Received: from aer-iport-nat.cisco.com (HELO aer-core-3.cisco.com) ([173.38.203.22])
  by aer-iport-1.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 21 Oct 2019 14:18:03 +0000
Received: from onetland-linux.rd.cisco.com ([10.47.77.136])
        by aer-core-3.cisco.com (8.15.2/8.15.2) with ESMTP id x9LEHuNO027696;
        Mon, 21 Oct 2019 14:18:02 GMT
From:   =?UTF-8?q?=C3=98yvind=20Netland?= <onetland@cisco.com>
To:     lys-patches@cisco.com
Cc:     hansverk@cisco.com, hegtvedt@cisco.com,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>, stable@vger.kernel.org
Subject: [PATCH 19/23] media: cec/v4l2: move V4L2 specific CEC functions to V4L2
Date:   Mon, 21 Oct 2019 16:17:52 +0200
Message-Id: <20191021141756.8816-19-onetland@cisco.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191021141756.8816-1-onetland@cisco.com>
References: <20191021141756.8816-1-onetland@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.47.77.136, [10.47.77.136]
X-Outbound-Node: aer-core-3.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

onetland: cherry-picked from mainline: 9cfd2753f8f3

Several CEC functions are actually specific for use with receivers,
i.e. they should be part of the V4L2 subsystem, not CEC.

These functions deal with validating and modifying EDIDs for (HDMI)
receivers, and they do not actually have anything to do with the CEC
subsystem and whether or not CEC is enabled. The problem was that if
the CEC_CORE config option was not set, then these functions would
become stubs, but that's not right: they should always be valid.

So replace the cec_ prefix by v4l2_ and move them to v4l2-dv-timings.c.
Update all drivers that call these accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <stable@vger.kernel.org>      # for v4.17 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 7b1935ab03c8..9257ff49ae20 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2291,8 +2291,8 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		edid->blocks = 2;
 		return -E2BIG;
 	}
-	pa = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, &spa_loc);
-	err = cec_phys_addr_validate(pa, &pa, NULL);
+	pa = v4l2_get_edid_phys_addr(edid->edid, edid->blocks * 128, &spa_loc);
+	err = v4l2_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8c2a52e280af..2cd33925bdc4 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -802,8 +802,8 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	if (!state->hdmi_edid.present)
 		return 0;
 
-	pa = cec_get_edid_phys_addr(edid, 256, &spa_loc);
-	err = cec_phys_addr_validate(pa, &pa, NULL);
+	pa = v4l2_get_edid_phys_addr(edid, 256, &spa_loc);
+	err = v4l2_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 82a6315353f7..ad356aab1c19 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1813,7 +1813,7 @@ int vidioc_s_edid(struct file *file, void *_fh,
 		return -E2BIG;
 	}
 	phys_addr = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, NULL);
-	ret = cec_phys_addr_validate(phys_addr, &phys_addr, NULL);
+	ret = v4l2_phys_addr_validate(phys_addr, &phys_addr, NULL);
 	if (ret)
 		return ret;
 
@@ -1829,7 +1829,7 @@ int vidioc_s_edid(struct file *file, void *_fh,
 
 	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++)
 		cec_s_phys_addr(dev->cec_tx_adap[i],
-				cec_phys_addr_for_input(phys_addr, i + 1),
+				v4l2_phys_addr_for_input(phys_addr, i + 1),
 				false);
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index b701a8ebd424..b35026f0a5a1 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -909,6 +909,6 @@ int vidioc_g_edid(struct file *file, void *_fh,
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
 	memcpy(edid->edid, dev->edid, edid->blocks * 128);
-	cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
+	v4l2_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
 	return 0;
 }
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index eaec17dea161..9bc86899d074 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -27,6 +27,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <linux/math64.h>
 #include <linux/hdmi.h>
+#include <media/cec.h>
 
 MODULE_AUTHOR("Hans Verkuil");
 MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
@@ -900,3 +901,153 @@ v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
 	return c;
 }
 EXPORT_SYMBOL_GPL(v4l2_hdmi_rx_colorimetry);
+
+/**
+ * v4l2_get_edid_phys_addr() - find and return the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @offset:	If not %NULL then the location of the physical address
+ *		bytes in the EDID will be returned here. This is set to 0
+ *		if there is no physical address found.
+ *
+ * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
+ */
+u16 v4l2_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			    unsigned int *offset)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+
+	if (offset)
+		*offset = loc;
+	if (loc == 0)
+		return CEC_PHYS_ADDR_INVALID;
+	return (edid[loc] << 8) | edid[loc + 1];
+}
+EXPORT_SYMBOL_GPL(v4l2_get_edid_phys_addr);
+
+/**
+ * v4l2_set_edid_phys_addr() - find and set the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @phys_addr:	the new physical address
+ *
+ * This function finds the location of the physical address in the EDID
+ * and fills in the given physical address and updates the checksum
+ * at the end of the EDID block. It does nothing if the EDID doesn't
+ * contain a physical address.
+ */
+void v4l2_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+	u8 sum = 0;
+	unsigned int i;
+
+	if (loc == 0)
+		return;
+	edid[loc] = phys_addr >> 8;
+	edid[loc + 1] = phys_addr & 0xff;
+	loc &= ~0x7f;
+
+	/* update the checksum */
+	for (i = loc; i < loc + 127; i++)
+		sum += edid[i];
+	edid[i] = 256 - sum;
+}
+EXPORT_SYMBOL_GPL(v4l2_set_edid_phys_addr);
+
+/**
+ * v4l2_phys_addr_for_input() - calculate the PA for an input
+ *
+ * @phys_addr:	the physical address of the parent
+ * @input:	the number of the input port, must be between 1 and 15
+ *
+ * This function calculates a new physical address based on the input
+ * port number. For example:
+ *
+ * PA = 0.0.0.0 and input = 2 becomes 2.0.0.0
+ *
+ * PA = 3.0.0.0 and input = 1 becomes 3.1.0.0
+ *
+ * PA = 3.2.1.0 and input = 5 becomes 3.2.1.5
+ *
+ * PA = 3.2.1.3 and input = 5 becomes f.f.f.f since it maxed out the depth.
+ *
+ * Return: the new physical address or CEC_PHYS_ADDR_INVALID.
+ */
+u16 v4l2_phys_addr_for_input(u16 phys_addr, u8 input)
+{
+	/* Check if input is sane */
+	if (WARN_ON(input == 0 || input > 0xf))
+		return CEC_PHYS_ADDR_INVALID;
+
+	if (phys_addr == 0)
+		return input << 12;
+
+	if ((phys_addr & 0x0fff) == 0)
+		return phys_addr | (input << 8);
+
+	if ((phys_addr & 0x00ff) == 0)
+		return phys_addr | (input << 4);
+
+	if ((phys_addr & 0x000f) == 0)
+		return phys_addr | input;
+
+	/*
+	 * All nibbles are used so no valid physical addresses can be assigned
+	 * to the input.
+	 */
+	return CEC_PHYS_ADDR_INVALID;
+}
+EXPORT_SYMBOL_GPL(v4l2_phys_addr_for_input);
+
+/**
+ * v4l2_phys_addr_validate() - validate a physical address from an EDID
+ *
+ * @phys_addr:	the physical address to validate
+ * @parent:	if not %NULL, then this is filled with the parents PA.
+ * @port:	if not %NULL, then this is filled with the input port.
+ *
+ * This validates a physical address as read from an EDID. If the
+ * PA is invalid (such as 1.0.1.0 since '0' is only allowed at the end),
+ * then it will return -EINVAL.
+ *
+ * The parent PA is passed into %parent and the input port is passed into
+ * %port. For example:
+ *
+ * PA = 0.0.0.0: has parent 0.0.0.0 and input port 0.
+ *
+ * PA = 1.0.0.0: has parent 0.0.0.0 and input port 1.
+ *
+ * PA = 3.2.0.0: has parent 3.0.0.0 and input port 2.
+ *
+ * PA = f.f.f.f: has parent f.f.f.f and input port 0.
+ *
+ * Return: 0 if the PA is valid, -EINVAL if not.
+ */
+int v4l2_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
+{
+	int i;
+
+	if (parent)
+		*parent = phys_addr;
+	if (port)
+		*port = 0;
+	if (phys_addr == CEC_PHYS_ADDR_INVALID)
+		return 0;
+	for (i = 0; i < 16; i += 4)
+		if (phys_addr & (0xf << i))
+			break;
+	if (i == 16)
+		return 0;
+	if (parent)
+		*parent = phys_addr & (0xfff0 << i);
+	if (port)
+		*port = (phys_addr >> i) & 0xf;
+	for (i += 4; i < 16; i += 4)
+		if ((phys_addr & (0xf << i)) == 0)
+			return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_phys_addr_validate);
diff --git a/include/media/cec.h b/include/media/cec.h
index ae209e542d11..27b95bdaa4a9 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -336,67 +336,6 @@ void cec_queue_pin_hpd_event(struct cec_adapter *adap, bool is_high, ktime_t ts)
 u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 			   unsigned int *offset);
 
-/**
- * cec_set_edid_phys_addr() - find and set the physical address
- *
- * @edid:	pointer to the EDID data
- * @size:	size in bytes of the EDID data
- * @phys_addr:	the new physical address
- *
- * This function finds the location of the physical address in the EDID
- * and fills in the given physical address and updates the checksum
- * at the end of the EDID block. It does nothing if the EDID doesn't
- * contain a physical address.
- */
-void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr);
-
-/**
- * cec_phys_addr_for_input() - calculate the PA for an input
- *
- * @phys_addr:	the physical address of the parent
- * @input:	the number of the input port, must be between 1 and 15
- *
- * This function calculates a new physical address based on the input
- * port number. For example:
- *
- * PA = 0.0.0.0 and input = 2 becomes 2.0.0.0
- *
- * PA = 3.0.0.0 and input = 1 becomes 3.1.0.0
- *
- * PA = 3.2.1.0 and input = 5 becomes 3.2.1.5
- *
- * PA = 3.2.1.3 and input = 5 becomes f.f.f.f since it maxed out the depth.
- *
- * Return: the new physical address or CEC_PHYS_ADDR_INVALID.
- */
-u16 cec_phys_addr_for_input(u16 phys_addr, u8 input);
-
-/**
- * cec_phys_addr_validate() - validate a physical address from an EDID
- *
- * @phys_addr:	the physical address to validate
- * @parent:	if not %NULL, then this is filled with the parents PA.
- * @port:	if not %NULL, then this is filled with the input port.
- *
- * This validates a physical address as read from an EDID. If the
- * PA is invalid (such as 1.0.1.0 since '0' is only allowed at the end),
- * then it will return -EINVAL.
- *
- * The parent PA is passed into %parent and the input port is passed into
- * %port. For example:
- *
- * PA = 0.0.0.0: has parent 0.0.0.0 and input port 0.
- *
- * PA = 1.0.0.0: has parent 0.0.0.0 and input port 1.
- *
- * PA = 3.2.0.0: has parent 3.0.0.0 and input port 2.
- *
- * PA = f.f.f.f: has parent f.f.f.f and input port 0.
- *
- * Return: 0 if the PA is valid, -EINVAL if not.
- */
-int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
-
 #else
 
 static inline int cec_register_adapter(struct cec_adapter *adap,
@@ -431,25 +370,6 @@ static inline u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 	return CEC_PHYS_ADDR_INVALID;
 }
 
-static inline void cec_set_edid_phys_addr(u8 *edid, unsigned int size,
-					  u16 phys_addr)
-{
-}
-
-static inline u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
-{
-	return CEC_PHYS_ADDR_INVALID;
-}
-
-static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
-{
-	if (parent)
-		*parent = phys_addr;
-	if (port)
-		*port = 0;
-	return 0;
-}
-
 #endif
 
 /**
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 5586e8d6c5ed..d987c469136e 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -227,4 +227,10 @@ v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
 			 const struct hdmi_vendor_infoframe *hdmi,
 			 unsigned int height);
 
+u16 v4l2_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			    unsigned int *offset);
+void v4l2_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr);
+u16 v4l2_phys_addr_for_input(u16 phys_addr, u8 input);
+int v4l2_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
+
 #endif
-- 
2.20.1

