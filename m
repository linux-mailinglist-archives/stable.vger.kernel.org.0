Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0D8B2055
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390667AbfIMNUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389901AbfIMNUv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:20:51 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 876C5214AE;
        Fri, 13 Sep 2019 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380851;
        bh=V5ryNmRt/DI8n+3VX9CWi5D7HhqLdK0qwkg50RMMFtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NH0PXGCcmp+ehA8t4Fap+g4ijjX0W460jl6C4qOWE4sqB8L7VY/31sSm2uBozci4Y
         L2i1jsDjbUnAb/r8PXEfIhDwdvT77GIoebAcbDaURVYanRnTno2h7LwNo9M1WUZSnw
         ms4S/iWoAMhu316ZSMJqJPiuCWsbNznMTp/ruaVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Jander <david@protonic.nl>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.2 01/37] gpio: pca953x: correct type of reg_direction
Date:   Fri, 13 Sep 2019 14:07:06 +0100
Message-Id: <20190913130510.940562189@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130510.727515099@linuxfoundation.org>
References: <20190913130510.727515099@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jander <david@protonic.nl>

commit bc624a06f0c5190bc37fec7d22cd82b43a579698 upstream.

The type of reg_direction needs to match the type of the regmap, which
is u8.

Fixes: 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
Cc: Cc: <stable@vger.kernel.org>
Signed-off-by: David Jander <david@protonic.nl>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-pca953x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -604,7 +604,7 @@ static void pca953x_irq_bus_sync_unlock(
 	u8 new_irqs;
 	int level, i;
 	u8 invert_irq_mask[MAX_BANK];
-	int reg_direction[MAX_BANK];
+	u8 reg_direction[MAX_BANK];
 
 	regmap_bulk_read(chip->regmap, chip->regs->direction, reg_direction,
 			 NBANK(chip));
@@ -679,7 +679,7 @@ static bool pca953x_irq_pending(struct p
 	bool pending_seen = false;
 	bool trigger_seen = false;
 	u8 trigger[MAX_BANK];
-	int reg_direction[MAX_BANK];
+	u8 reg_direction[MAX_BANK];
 	int ret, i;
 
 	if (chip->driver_data & PCA_PCAL) {
@@ -768,7 +768,7 @@ static int pca953x_irq_setup(struct pca9
 {
 	struct i2c_client *client = chip->client;
 	struct irq_chip *irq_chip = &chip->irq_chip;
-	int reg_direction[MAX_BANK];
+	u8 reg_direction[MAX_BANK];
 	int ret, i;
 
 	if (!client->irq)


