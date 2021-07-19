Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC633CE1E6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346655AbhGSP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349098AbhGSPZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8797860200;
        Mon, 19 Jul 2021 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710780;
        bh=oZYv39VanAcQo8CfNJJXpZS4pXJWzXIkBY41UUMDDt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmtuDIJmqMU7JNPWnF2lWBEdonJJEPb1k+6166rxL+66kb+eAaQqzUzU0dYwZWMNR
         pSnYWfz7UB7og1p3eqU7IKrDeWgDXKsqYDcovOcxBNB+ri0Gx8u99SUDsd5+RLwSwp
         AzviqPRe5mDXP6inqgzA2g1P8WWIHst07D2FwnSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gil Fine <gil.fine@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 106/351] thunderbolt: Fix DROM handling for USB4 DROM
Date:   Mon, 19 Jul 2021 16:50:52 +0200
Message-Id: <20210719144947.998718321@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gil Fine <gil.fine@intel.com>

[ Upstream commit b18f901382fdb74a138a0bf30458c54a023a1d86 ]

DROM for USB4 host/device has a shorter header than Thunderbolt DROM
header. This patch addresses host/device with USB4 DROM (According to spec:
Universal Serial Bus 4 (USB4) Device ROM Specification, Rev 1.0, Feb-2021).

While there correct the data_len field to be 12 bits and rename
__unknown1 to reserved following the spec.

Signed-off-by: Gil Fine <gil.fine@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/eeprom.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 46d0906a3070..470885e6f1c8 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -214,7 +214,10 @@ static u32 tb_crc32(void *data, size_t len)
 	return ~__crc32c_le(~0, data, len);
 }
 
-#define TB_DROM_DATA_START 13
+#define TB_DROM_DATA_START		13
+#define TB_DROM_HEADER_SIZE		22
+#define USB4_DROM_HEADER_SIZE		16
+
 struct tb_drom_header {
 	/* BYTE 0 */
 	u8 uid_crc8; /* checksum for uid */
@@ -224,9 +227,9 @@ struct tb_drom_header {
 	u32 data_crc32; /* checksum for data_len bytes starting at byte 13 */
 	/* BYTE 13 */
 	u8 device_rom_revision; /* should be <= 1 */
-	u16 data_len:10;
-	u8 __unknown1:6;
-	/* BYTES 16-21 */
+	u16 data_len:12;
+	u8 reserved:4;
+	/* BYTES 16-21 - Only for TBT DROM, nonexistent in USB4 DROM */
 	u16 vendor_id;
 	u16 model_id;
 	u8 model_rev;
@@ -401,10 +404,10 @@ static int tb_drom_parse_entry_port(struct tb_switch *sw,
  *
  * Drom must have been copied to sw->drom.
  */
-static int tb_drom_parse_entries(struct tb_switch *sw)
+static int tb_drom_parse_entries(struct tb_switch *sw, size_t header_size)
 {
 	struct tb_drom_header *header = (void *) sw->drom;
-	u16 pos = sizeof(*header);
+	u16 pos = header_size;
 	u16 drom_size = header->data_len + TB_DROM_DATA_START;
 	int res;
 
@@ -566,7 +569,7 @@ static int tb_drom_parse(struct tb_switch *sw)
 			header->data_crc32, crc);
 	}
 
-	return tb_drom_parse_entries(sw);
+	return tb_drom_parse_entries(sw, TB_DROM_HEADER_SIZE);
 }
 
 static int usb4_drom_parse(struct tb_switch *sw)
@@ -583,7 +586,7 @@ static int usb4_drom_parse(struct tb_switch *sw)
 		return -EINVAL;
 	}
 
-	return tb_drom_parse_entries(sw);
+	return tb_drom_parse_entries(sw, USB4_DROM_HEADER_SIZE);
 }
 
 /**
-- 
2.30.2



