Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09683AEF8F
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhFUQkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhFUQii (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC98261400;
        Mon, 21 Jun 2021 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292973;
        bh=H7XKGf6/cWgnxxp18pnCTKY39huQjoKG9+HQpV+Zpfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7Hrt3aalMFGgrZfMHRYF43bgKugxXequ1mFt9gifkGo47Y4NALTldu6DY5NkaRHk
         qYfNWSpnbCVk7SueEQDS4J9DP/Usp0u4apPxh0j4TX4ttjxfa2/rVwhb6gw5NIBWSv
         yBpCnGFH0jgVY70k5j33SVNQwMoPi6vd/MZP2tIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 050/178] cxgb4: fix endianness when flashing boot image
Date:   Mon, 21 Jun 2021 18:14:24 +0200
Message-Id: <20210621154924.064603565@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index 80882cfc370f..029f0c83d785 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3060,16 +3060,19 @@ int t4_read_flash(struct adapter *adapter, unsigned int addr,
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
@@ -3080,10 +3083,14 @@ static int t4_write_flash(struct adapter *adapter, unsigned int addr,
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
@@ -3096,7 +3103,8 @@ static int t4_write_flash(struct adapter *adapter, unsigned int addr,
 	t4_write_reg(adapter, SF_OP_A, 0);    /* unlock SF */
 
 	/* Read the page to verify the write succeeded */
-	ret = t4_read_flash(adapter, addr & ~0xff, ARRAY_SIZE(buf), buf, 1);
+	ret = t4_read_flash(adapter, addr & ~0xff, ARRAY_SIZE(buf), buf,
+			    byte_oriented);
 	if (ret)
 		return ret;
 
@@ -3692,7 +3700,7 @@ int t4_load_fw(struct adapter *adap, const u8 *fw_data, unsigned int size)
 	 */
 	memcpy(first_page, fw_data, SF_PAGE_SIZE);
 	((struct fw_hdr *)first_page)->fw_ver = cpu_to_be32(0xffffffff);
-	ret = t4_write_flash(adap, fw_start, SF_PAGE_SIZE, first_page);
+	ret = t4_write_flash(adap, fw_start, SF_PAGE_SIZE, first_page, true);
 	if (ret)
 		goto out;
 
@@ -3700,14 +3708,14 @@ int t4_load_fw(struct adapter *adap, const u8 *fw_data, unsigned int size)
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
@@ -10208,7 +10216,7 @@ int t4_load_cfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 			n = size - i;
 		else
 			n = SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+		ret = t4_write_flash(adap, addr, n, cfg_data, true);
 		if (ret)
 			goto out;
 
@@ -10677,13 +10685,14 @@ int t4_load_boot(struct adapter *adap, u8 *boot_data,
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
@@ -10758,7 +10767,7 @@ int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 	for (i = 0; i < size; i += SF_PAGE_SIZE) {
 		n = min_t(u32, size - i, SF_PAGE_SIZE);
 
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+		ret = t4_write_flash(adap, addr, n, cfg_data, false);
 		if (ret)
 			goto out;
 
@@ -10770,7 +10779,8 @@ int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
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



