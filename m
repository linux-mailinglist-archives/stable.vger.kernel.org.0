Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F071B267D
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgDUMl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728930AbgDUMlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:11 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F3C0610D5
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:10 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y24so3496768wma.4
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HeNnO5SC6sCx8UtRBsDRGWXZmLJX6hUUh1srBWTHa7Y=;
        b=DXtPnSIifgmM8Oh+sb/f2FSreRlEnP0tpk0o2LUvtoFMTvPpw0AMF9QEvo22d/TTCv
         HnuA++VPn3M/xwGZdcpJ/b+0h0ySBQVvHku5MC8LiOVOTZl9Q1utERAWUO79lgqpM+X9
         6l91cAa9n2ZoFcai/cgfyEdmyk6NB7jJIplWMRmMvSBdsNbHsVkn5WSsUp+nZ+A6MCVZ
         fEyV6q1o4Z38aEynXZJurcUgXqfoKBANh3X/rF1vICinUIp4ucAONnB9fe31pYz//cv8
         XoWhoccoeF2czy+PMsUEffwKjl68jOBwfHi6e1NWjJxRdzpmjUj5c1hf+S5msbYI47m+
         QP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HeNnO5SC6sCx8UtRBsDRGWXZmLJX6hUUh1srBWTHa7Y=;
        b=eglTRU+p8JFX/gByCjmS87VPEiYk05BalpFzGynkDHKcGbP7kG0I0tm5Yay1J3VMQu
         A58i3Nh6WA6z0VoKxw4AugKv4oZKI+ItZtvQ42nc++Qj00l/RtpMyWRNtHIoYbU+BMmy
         C8DtYlrB22f11QBMa9x0mzoDhPJ3KEoUWcGbpNnXYZAuGoSMa+72ty6G2twAXKRpTiQW
         N7k/NI9+an3Pm8TJuMYvG7OFU05oxITqapxSZKn9QGtQTdx2o80d3u0CAH1dBXvmV2Hd
         PSGJfs/CKt47cGwnlyH2FNunaCqsp4RDRKrNbzkgrFdK6t4Z7l06Xke1+drw9oiVJWCp
         vzAg==
X-Gm-Message-State: AGi0Pub/2cqclWyS9wHxjz6JvceQgnsQ/mpnn++UlSChEhL9h/4n3xbC
        WEcGUk0c/YIrMsvzO/CBgttIDDMUbAU=
X-Google-Smtp-Source: APiQypI+q0vX45mSKiHYYZ7ksv2pyxH98HMAQmvLFawgV+xlbxjVyH33bux4VWhl3+sYFa127yypOw==
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr4787083wmm.150.1587472869290;
        Tue, 21 Apr 2020 05:41:09 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Lior David <qca_liord@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 19/24] wil6210: add block size checks during FW load
Date:   Tue, 21 Apr 2020 13:40:12 +0100
Message-Id: <20200421124017.272694-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lior David <qca_liord@qca.qualcomm.com>

[ Upstream commit 705d2fde94b23cd76efbeedde643ffa7c32fac7f ]

When loading FW from file add block size checks to ensure a
corrupted FW file will not cause the driver to write outside
the device memory.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/fw_inc.c  | 58 ++++++++++++++--------
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c     | 11 +++-
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index e01acac88825d..7d090150187c8 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -26,14 +26,17 @@
 					     prefix_type, rowsize,	\
 					     groupsize, buf, len, ascii)
 
-#define FW_ADDR_CHECK(ioaddr, val, msg) do { \
-		ioaddr = wmi_buffer(wil, val); \
-		if (!ioaddr) { \
-			wil_err_fw(wil, "bad " msg ": 0x%08x\n", \
-				   le32_to_cpu(val)); \
-			return -EINVAL; \
-		} \
-	} while (0)
+static bool wil_fw_addr_check(struct wil6210_priv *wil,
+			      void __iomem **ioaddr, __le32 val,
+			      u32 size, const char *msg)
+{
+	*ioaddr = wmi_buffer_block(wil, val, size);
+	if (!(*ioaddr)) {
+		wil_err_fw(wil, "bad %s: 0x%08x\n", msg, le32_to_cpu(val));
+		return false;
+	}
+	return true;
+}
 
 /**
  * wil_fw_verify - verify firmware file validity
@@ -165,7 +168,8 @@ static int fw_handle_data(struct wil6210_priv *wil, const void *data,
 		return -EINVAL;
 	}
 
-	FW_ADDR_CHECK(dst, d->addr, "address");
+	if (!wil_fw_addr_check(wil, &dst, d->addr, s, "address"))
+		return -EINVAL;
 	wil_dbg_fw(wil, "write [0x%08x] <== %zu bytes\n", le32_to_cpu(d->addr),
 		   s);
 	wil_memcpy_toio_32(dst, d->data, s);
@@ -197,7 +201,8 @@ static int fw_handle_fill(struct wil6210_priv *wil, const void *data,
 		return -EINVAL;
 	}
 
-	FW_ADDR_CHECK(dst, d->addr, "address");
+	if (!wil_fw_addr_check(wil, &dst, d->addr, s, "address"))
+		return -EINVAL;
 
 	v = le32_to_cpu(d->value);
 	wil_dbg_fw(wil, "fill [0x%08x] <== 0x%08x, %zu bytes\n",
@@ -253,7 +258,8 @@ static int fw_handle_direct_write(struct wil6210_priv *wil, const void *data,
 		u32 v = le32_to_cpu(block[i].value);
 		u32 x, y;
 
-		FW_ADDR_CHECK(dst, block[i].addr, "address");
+		if (!wil_fw_addr_check(wil, &dst, block[i].addr, 0, "address"))
+			return -EINVAL;
 
 		x = readl(dst);
 		y = (x & m) | (v & ~m);
@@ -319,10 +325,15 @@ static int fw_handle_gateway_data(struct wil6210_priv *wil, const void *data,
 	wil_dbg_fw(wil, "gw write record [%3d] blocks, cmd 0x%08x\n",
 		   n, gw_cmd);
 
-	FW_ADDR_CHECK(gwa_addr, d->gateway_addr_addr, "gateway_addr_addr");
-	FW_ADDR_CHECK(gwa_val, d->gateway_value_addr, "gateway_value_addr");
-	FW_ADDR_CHECK(gwa_cmd, d->gateway_cmd_addr, "gateway_cmd_addr");
-	FW_ADDR_CHECK(gwa_ctl, d->gateway_ctrl_address, "gateway_ctrl_address");
+	if (!wil_fw_addr_check(wil, &gwa_addr, d->gateway_addr_addr, 0,
+			       "gateway_addr_addr") ||
+	    !wil_fw_addr_check(wil, &gwa_val, d->gateway_value_addr, 0,
+			       "gateway_value_addr") ||
+	    !wil_fw_addr_check(wil, &gwa_cmd, d->gateway_cmd_addr, 0,
+			       "gateway_cmd_addr") ||
+	    !wil_fw_addr_check(wil, &gwa_ctl, d->gateway_ctrl_address, 0,
+			       "gateway_ctrl_address"))
+		return -EINVAL;
 
 	wil_dbg_fw(wil, "gw addresses: addr 0x%08x val 0x%08x"
 		   " cmd 0x%08x ctl 0x%08x\n",
@@ -378,12 +389,19 @@ static int fw_handle_gateway_data4(struct wil6210_priv *wil, const void *data,
 	wil_dbg_fw(wil, "gw4 write record [%3d] blocks, cmd 0x%08x\n",
 		   n, gw_cmd);
 
-	FW_ADDR_CHECK(gwa_addr, d->gateway_addr_addr, "gateway_addr_addr");
+	if (!wil_fw_addr_check(wil, &gwa_addr, d->gateway_addr_addr, 0,
+			       "gateway_addr_addr"))
+		return -EINVAL;
 	for (k = 0; k < ARRAY_SIZE(block->value); k++)
-		FW_ADDR_CHECK(gwa_val[k], d->gateway_value_addr[k],
-			      "gateway_value_addr");
-	FW_ADDR_CHECK(gwa_cmd, d->gateway_cmd_addr, "gateway_cmd_addr");
-	FW_ADDR_CHECK(gwa_ctl, d->gateway_ctrl_address, "gateway_ctrl_address");
+		if (!wil_fw_addr_check(wil, &gwa_val[k],
+				       d->gateway_value_addr[k],
+				       0, "gateway_value_addr"))
+			return -EINVAL;
+	if (!wil_fw_addr_check(wil, &gwa_cmd, d->gateway_cmd_addr, 0,
+			       "gateway_cmd_addr") ||
+	    !wil_fw_addr_check(wil, &gwa_ctl, d->gateway_ctrl_address, 0,
+			       "gateway_ctrl_address"))
+		return -EINVAL;
 
 	wil_dbg_fw(wil, "gw4 addresses: addr 0x%08x cmd 0x%08x ctl 0x%08x\n",
 		   le32_to_cpu(d->gateway_addr_addr),
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index c5b6b783100aa..0bfd51adcc81f 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -865,6 +865,7 @@ void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r);
 int wil_find_cid(struct wil6210_priv *wil, const u8 *mac);
 void wil_set_ethtoolops(struct net_device *ndev);
 
+void __iomem *wmi_buffer_block(struct wil6210_priv *wil, __le32 ptr, u32 size);
 void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr);
 void __iomem *wmi_addr(struct wil6210_priv *wil, u32 ptr);
 int wmi_read_hdr(struct wil6210_priv *wil, __le32 ptr,
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 798516f42f2f9..6cfb820caa3ee 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -140,13 +140,15 @@ static u32 wmi_addr_remap(u32 x)
 /**
  * Check address validity for WMI buffer; remap if needed
  * @ptr - internal (linker) fw/ucode address
+ * @size - if non zero, validate the block does not
+ *  exceed the device memory (bar)
  *
  * Valid buffer should be DWORD aligned
  *
  * return address for accessing buffer from the host;
  * if buffer is not valid, return NULL.
  */
-void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr_)
+void __iomem *wmi_buffer_block(struct wil6210_priv *wil, __le32 ptr_, u32 size)
 {
 	u32 off;
 	u32 ptr = le32_to_cpu(ptr_);
@@ -161,10 +163,17 @@ void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr_)
 	off = HOSTADDR(ptr);
 	if (off > wil->bar_size - 4)
 		return NULL;
+	if (size && ((off + size > wil->bar_size) || (off + size < off)))
+		return NULL;
 
 	return wil->csr + off;
 }
 
+void __iomem *wmi_buffer(struct wil6210_priv *wil, __le32 ptr_)
+{
+	return wmi_buffer_block(wil, ptr_, 0);
+}
+
 /**
  * Check address validity
  */
-- 
2.25.1

