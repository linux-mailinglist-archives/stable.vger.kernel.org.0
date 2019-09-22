Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945B2BAB0B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438418AbfIVTd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390861AbfIVSr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0203B214D9;
        Sun, 22 Sep 2019 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178047;
        bh=wxlemXqcQli902QZT0OQcLMn5GX/KD1gd3Ig9+iAhYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwdsWB0A6FLrilEx+Yx4cWKgtwkaIMsHnLmT3N0iJfAdCiQSV9UrZ+B5WZj5bahKD
         8/fPS9JLHtHU016GsGIA0QzSygTwDOlSymVUa5zIfi5mX8gPEwRZFA9pRXNPMzZzL5
         e1PmEOv7wpwSbFuvOswiROHPDHsDa7oORTt6zwbg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 126/203] media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()
Date:   Sun, 22 Sep 2019 14:42:32 -0400
Message-Id: <20190922184350.30563-126-sashal@kernel.org>
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

From: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>

[ Upstream commit 9d802222a3405599d6e1984d9324cddf592ea1f4 ]

saa7134_i2c_eeprom_md7134_gate() function and the associated comment uses
an inverted i2c gate open / closed terminology.
Let's fix this.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: fix alignment checkpatch warning]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-i2c.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index 493b1858815fb..04e85765373ec 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -342,7 +342,11 @@ static const struct i2c_client saa7134_client_template = {
 
 /* ----------------------------------------------------------- */
 
-/* On Medion 7134 reading EEPROM needs DVB-T demod i2c gate open */
+/*
+ * On Medion 7134 reading the SAA7134 chip config EEPROM needs DVB-T
+ * demod i2c gate closed due to an address clash between this EEPROM
+ * and the demod one.
+ */
 static void saa7134_i2c_eeprom_md7134_gate(struct saa7134_dev *dev)
 {
 	u8 subaddr = 0x7, dmdregval;
@@ -359,14 +363,14 @@ static void saa7134_i2c_eeprom_md7134_gate(struct saa7134_dev *dev)
 
 	ret = i2c_transfer(&dev->i2c_adap, i2cgatemsg_r, 2);
 	if ((ret == 2) && (dmdregval & 0x2)) {
-		pr_debug("%s: DVB-T demod i2c gate was left closed\n",
+		pr_debug("%s: DVB-T demod i2c gate was left open\n",
 			 dev->name);
 
 		data[0] = subaddr;
 		data[1] = (dmdregval & ~0x2);
 		if (i2c_transfer(&dev->i2c_adap, i2cgatemsg_w, 1) != 1)
-			pr_err("%s: EEPROM i2c gate open failure\n",
-			  dev->name);
+			pr_err("%s: EEPROM i2c gate close failure\n",
+			       dev->name);
 	}
 }
 
-- 
2.20.1

