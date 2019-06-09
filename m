Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAA13A8B9
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388429AbfFIRDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:41960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388441AbfFIRDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B15AF20840;
        Sun,  9 Jun 2019 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099813;
        bh=OOKEluLMKp8acevFWmCmrQcHEyb7K4TvMf/MtOV+0qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUPVBoYXnwMrLHy9G8e7zVPSt1viLU+i/hsKhRW73E89WGGprc1N5LHT0qTImKDcT
         6erfQ5wAJx+b+O9c44ucIIdA8SRi/jWjZ2EYCK3/i419D8lBLFn24FEgwx/uoaU8SM
         EHJ4uHnW1eb6ZIB881rQyV2CLmnCvzdocNrENfro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 174/241] media: saa7146: avoid high stack usage with clang
Date:   Sun,  9 Jun 2019 18:41:56 +0200
Message-Id: <20190609164152.827549603@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 03aa4f191a36f33fce015387f84efa0eee94408e ]

Two saa7146/hexium files contain a construct that causes a warning
when built with clang:

drivers/media/pci/saa7146/hexium_orion.c:210:12: error: stack frame size of 2272 bytes in function 'hexium_probe'
      [-Werror,-Wframe-larger-than=]
static int hexium_probe(struct saa7146_dev *dev)
           ^
drivers/media/pci/saa7146/hexium_gemini.c:257:12: error: stack frame size of 2304 bytes in function 'hexium_attach'
      [-Werror,-Wframe-larger-than=]
static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data *info)
           ^

This one happens regardless of KASAN, and the problem is that a
constructor to initialize a dynamically allocated structure leads
to a copy of that structure on the stack, whereas gcc initializes
it in place.

Link: https://bugs.llvm.org/show_bug.cgi?id=40776

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: fix checkpatch warnings]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7146/hexium_gemini.c | 5 ++---
 drivers/media/pci/saa7146/hexium_orion.c  | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 03cbcd2095c6e..d4b3ce8282856 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -270,9 +270,8 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	/* enable i2c-port pins */
 	saa7146_write(dev, MC1, (MASK_08 | MASK_24 | MASK_10 | MASK_26));
 
-	hexium->i2c_adapter = (struct i2c_adapter) {
-		.name = "hexium gemini",
-	};
+	strscpy(hexium->i2c_adapter.name, "hexium gemini",
+		sizeof(hexium->i2c_adapter.name));
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
 		DEB_S("cannot register i2c-device. skipping.\n");
diff --git a/drivers/media/pci/saa7146/hexium_orion.c b/drivers/media/pci/saa7146/hexium_orion.c
index 15f0d66ff78a2..214396b1ca73c 100644
--- a/drivers/media/pci/saa7146/hexium_orion.c
+++ b/drivers/media/pci/saa7146/hexium_orion.c
@@ -232,9 +232,8 @@ static int hexium_probe(struct saa7146_dev *dev)
 	saa7146_write(dev, DD1_STREAM_B, 0x00000000);
 	saa7146_write(dev, MC2, (MASK_09 | MASK_25 | MASK_10 | MASK_26));
 
-	hexium->i2c_adapter = (struct i2c_adapter) {
-		.name = "hexium orion",
-	};
+	strscpy(hexium->i2c_adapter.name, "hexium orion",
+		sizeof(hexium->i2c_adapter.name));
 	saa7146_i2c_adapter_prepare(dev, &hexium->i2c_adapter, SAA7146_I2C_BUS_BIT_RATE_480);
 	if (i2c_add_adapter(&hexium->i2c_adapter) < 0) {
 		DEB_S("cannot register i2c-device. skipping.\n");
-- 
2.20.1



