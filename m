Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1186A13E0B5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAPQpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgAPQpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:45:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4818B21582;
        Thu, 16 Jan 2020 16:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193111;
        bh=1105cNsB3lE0xNOzbHnklhaaO2PN7/IcCNpK3vSUZEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rv4Y1RfAQRRXaNv9JxVQSqc8zVos/VIDUOBvNbCrooHrupAQlACTD5h7Ncb+zejhu
         cwdZkkyXqOPa1nluKV2OWmFZLa14/9ZBkxjRZE8DC/MVJ4No8NWscNGIbwMktFZX3X
         wR+u1hkYwP8pD6qtOIAc+zMlAugy2VEGQpuo8HwA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phani Kiran Hemadri <phemadri@marvell.com>,
        Srikanth Jampala <jsrikanth@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 026/205] crypto: cavium/nitrox - fix firmware assignment to AE cores
Date:   Thu, 16 Jan 2020 11:40:01 -0500
Message-Id: <20200116164300.6705-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phani Kiran Hemadri <phemadri@marvell.com>

[ Upstream commit 6a97a99db848748d582d79447f7c9c330ce1688e ]

This patch fixes assigning UCD block number of Asymmetric crypto
firmware to AE cores of CNN55XX device.

Fixes: a7268c4d4205 ("crypto: cavium/nitrox - Add support for loading asymmetric crypto firmware")
Signed-off-by: Phani Kiran Hemadri <phemadri@marvell.com>
Reviewed-by: Srikanth Jampala <jsrikanth@marvell.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index bc924980e10c..c4632d84c9a1 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -103,8 +103,7 @@ static void write_to_ucd_unit(struct nitrox_device *ndev, u32 ucode_size,
 	offset = UCD_UCODE_LOAD_BLOCK_NUM;
 	nitrox_write_csr(ndev, offset, block_num);
 
-	code_size = ucode_size;
-	code_size = roundup(code_size, 8);
+	code_size = roundup(ucode_size, 16);
 	while (code_size) {
 		data = ucode_data[i];
 		/* write 8 bytes at a time */
@@ -220,11 +219,11 @@ static int nitrox_load_fw(struct nitrox_device *ndev)
 
 	/* write block number and firmware length
 	 * bit:<2:0> block number
-	 * bit:3 is set SE uses 32KB microcode
-	 * bit:3 is clear SE uses 64KB microcode
+	 * bit:3 is set AE uses 32KB microcode
+	 * bit:3 is clear AE uses 64KB microcode
 	 */
 	core_2_eid_val.value = 0ULL;
-	core_2_eid_val.ucode_blk = 0;
+	core_2_eid_val.ucode_blk = 2;
 	if (ucode_size <= CNN55XX_UCD_BLOCK_SIZE)
 		core_2_eid_val.ucode_len = 1;
 	else
-- 
2.20.1

