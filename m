Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D233C2D65
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhGJCWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232866AbhGJCWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB2D2613C3;
        Sat, 10 Jul 2021 02:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883565;
        bh=oZYv39VanAcQo8CfNJJXpZS4pXJWzXIkBY41UUMDDt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3+Pc1z5cMGuOj3LJjnJ024RvdGtEaOOUQoM5UgTo9MCWOeZfBCR/XnOS3fSXp5nX
         hFr2Y4XDqz1buy4DARrFr4Re+Gpgf+bzp91MNwa/BfJo4ZYCJlatamue8bNTNdOCOk
         n/HPhE24T/WYG5zwJbvhh1Ea3q++qXVDtdVlwsju03ZXlR7alpON2lcVpvvwy6nq9M
         wFNW38d/2FniGuwHfSQalX++Q2FFfzuFOvBlVMTFHhrpLd26lINfi4nhY6dy+g3j/E
         0T+Mul2WjC33I6IGq5sFrd+iA7K/ymIvUJqcNqM4mWRhn8SNcAsUsOPjgfcCnWJqzd
         EnJT3sTP5Xwog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gil Fine <gil.fine@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 072/114] thunderbolt: Fix DROM handling for USB4 DROM
Date:   Fri,  9 Jul 2021 22:17:06 -0400
Message-Id: <20210710021748.3167666-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710021748.3167666-1-sashal@kernel.org>
References: <20210710021748.3167666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

