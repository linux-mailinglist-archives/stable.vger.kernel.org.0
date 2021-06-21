Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1983AEE60
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhFUQ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231490AbhFUQ1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C842D613C9;
        Mon, 21 Jun 2021 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292553;
        bh=hTz6v/1RGudAMYzurTVT52HbBS10uIElahHMVyqxRAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNlB5Ly+Hz0TOgQS6EkkaxexUfve6BuqKncHohW2HlR2c1E2d+VsYuc3L96Av2/7+
         lNsys+oBirOnJHeNJf4bBZrFiTE0mg+3VT7/gA1zFQAiEoVyNoN6zeg6GCUHRWuyGA
         ZThF6APArAm1lVKtGAy1VKwB5nDX0XA8CMxX/0H8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/146] cxgb4: fix endianness when flashing boot image
Date:   Mon, 21 Jun 2021 18:14:31 +0200
Message-Id: <20210621154912.686470274@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

[ Upstream commit 42a2039753a7f758ba5c85cb199fcf10dc2111eb ]

Boot images are copied to memory and updated with current underlying
device ID before flashing them to adapter. Ensure the updated images
are always flashed in Big Endian to allow the firmware to read the
new images during boot properly.

Fixes: 550883558f17 ("cxgb4: add support to flash boot image")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 44 +++++++++++++---------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 581670dced6e..236f6bf2858a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3067,16 +3067,19 @@ int t4_read_flash(struct adapter *adapter, unsigned int addr,
  *	@addr: the start address to write
  *	@n: length of data to write in bytes
  *	@data: the data to write
+ *	@byte_oriented: whether to store data as bytes or as words
  *
  *	Writes up to a page of data (256 bytes) to the serial flash starting
  *	at the given address.  All the data must be written to the same page.
+ *	If @byte_oriented is set the write data is stored as byte stream
+ *	(i.e. matches what on disk), otherwise in big-endian.
  */
 static int t4_write_flash(struct adapter *adapter, unsigned int addr,
-			  unsigned int n, const u8 *data)
+			  unsigned int n, const u8 *data, bool byte_oriented)
 {
-	int ret;
-	u32 buf[64];
 	unsigned int i, c, left, val, offset = addr & 0xff;
+	u32 buf[64];
+	int ret;
 
 	if (addr >= adapter->params.sf_size || offset + n > SF_PAGE_SIZE)
 		return -EINVAL;
@@ -3087,10 +3090,14 @@ static int t4_write_flash(struct adapter *adapter, unsigned int addr,
 	    (ret = sf1_write(adapter, 4, 1, 1, val)) != 0)
 		goto unlock;
 
-	for (left = n; left; left -= c) {
+	for (left = n; left; left -= c, data += c) {
 		c = min(left, 4U);
-		for (val = 0, i = 0; i < c; ++i)
-			val = (val << 8) + *data++;
+		for (val = 0, i = 0; i < c; ++i) {
+			if (byte_oriented)
+				val = (val << 8) + data[i];
+			else
+				val = (val << 8) + data[c - i - 1];
+		}
 
 		ret = sf1_write(adapter, c, c != left, 1, val);
 		if (ret)
@@ -3103,7 +3110,8 @@ static int t4_write_flash(struct adapter *adapter, unsigned int addr,
 	t4_write_reg(adapter, SF_OP_A, 0);    /* unlock SF */
 
 	/* Read the page to verify the write succeeded */
-	ret = t4_read_flash(adapter, addr & ~0xff, ARRAY_SIZE(buf), buf, 1);
+	ret = t4_read_flash(adapter, addr & ~0xff, ARRAY_SIZE(buf), buf,
+			    byte_oriented);
 	if (ret)
 		return ret;
 
@@ -3699,7 +3707,7 @@ int t4_load_fw(struct adapter *adap, const u8 *fw_data, unsigned int size)
 	 */
 	memcpy(first_page, fw_data, SF_PAGE_SIZE);
 	((struct fw_hdr *)first_page)->fw_ver = cpu_to_be32(0xffffffff);
-	ret = t4_write_flash(adap, fw_start, SF_PAGE_SIZE, first_page);
+	ret = t4_write_flash(adap, fw_start, SF_PAGE_SIZE, first_page, true);
 	if (ret)
 		goto out;
 
@@ -3707,14 +3715,14 @@ int t4_load_fw(struct adapter *adap, const u8 *fw_data, unsigned int size)
 	for (size -= SF_PAGE_SIZE; size; size -= SF_PAGE_SIZE) {
 		addr += SF_PAGE_SIZE;
 		fw_data += SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, fw_data);
+		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, fw_data, true);
 		if (ret)
 			goto out;
 	}
 
-	ret = t4_write_flash(adap,
-			     fw_start + offsetof(struct fw_hdr, fw_ver),
-			     sizeof(hdr->fw_ver), (const u8 *)&hdr->fw_ver);
+	ret = t4_write_flash(adap, fw_start + offsetof(struct fw_hdr, fw_ver),
+			     sizeof(hdr->fw_ver), (const u8 *)&hdr->fw_ver,
+			     true);
 out:
 	if (ret)
 		dev_err(adap->pdev_dev, "firmware download failed, error %d\n",
@@ -10215,7 +10223,7 @@ int t4_load_cfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 			n = size - i;
 		else
 			n = SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+		ret = t4_write_flash(adap, addr, n, cfg_data, true);
 		if (ret)
 			goto out;
 
@@ -10684,13 +10692,14 @@ int t4_load_boot(struct adapter *adap, u8 *boot_data,
 	for (size -= SF_PAGE_SIZE; size; size -= SF_PAGE_SIZE) {
 		addr += SF_PAGE_SIZE;
 		boot_data += SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, boot_data);
+		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, boot_data,
+				     false);
 		if (ret)
 			goto out;
 	}
 
 	ret = t4_write_flash(adap, boot_sector, SF_PAGE_SIZE,
-			     (const u8 *)header);
+			     (const u8 *)header, false);
 
 out:
 	if (ret)
@@ -10765,7 +10774,7 @@ int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 	for (i = 0; i < size; i += SF_PAGE_SIZE) {
 		n = min_t(u32, size - i, SF_PAGE_SIZE);
 
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+		ret = t4_write_flash(adap, addr, n, cfg_data, false);
 		if (ret)
 			goto out;
 
@@ -10777,7 +10786,8 @@ int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 	for (i = 0; i < npad; i++) {
 		u8 data = 0;
 
-		ret = t4_write_flash(adap, cfg_addr + size + i, 1, &data);
+		ret = t4_write_flash(adap, cfg_addr + size + i, 1, &data,
+				     false);
 		if (ret)
 			goto out;
 	}
-- 
2.30.2



