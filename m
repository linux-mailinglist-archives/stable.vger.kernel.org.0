Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FA05F3A5
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 09:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfGDH0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 03:26:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33250 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfGDH0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 03:26:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so5446801wru.0;
        Thu, 04 Jul 2019 00:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=acx589NG1jiLdMklxVwLi+wOV3q1fLOPyM7fTcUpo3I=;
        b=m+iUzkBtjYaLgESnRPV9+Z/nVko0OyGzmiwqgN8BW9oDY1jcJTkJ8ylTuoYrAQAoc8
         FiPG3Mph8IKFK8/i5V4n1VMoQq6jytVBIPcCHrCrC0nWsIEF31I3GECxsdQWI7HjPsgX
         rnpLB5K/HQJS04oXWr+VfisP+kBIdYXR+YcWlqBrA6HNVEe8tTURbnw6WWOOlQY0HAGz
         qeu/3XAcDNdkbXkq+UB+uDcqEmdBAM5BQ6qHqY2+3F83qoesCqGUnHtj/siW1F0YSfqH
         kWYWy35GgNqjXkF1A3ftoROfz04W00OL6E+p95a6etLTuNgPD1LblDGRjT/AH2lrANys
         EZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=acx589NG1jiLdMklxVwLi+wOV3q1fLOPyM7fTcUpo3I=;
        b=ofiVXlvp8r6+fe1K3YOxlTNELOc2QLbLvWJ62OQkueSWBX2Tfu6msVScx/MI680+Go
         YAoWPzE/lfmJPL1QCWZjAN/WzgG4YMmxKFRaGCOr0KjJaphq9m7PsMCJmF8nl0yGwFay
         P13u1UfSxCTPxpPA7NvzxAZCoqMbNemCuEjFc2qwW5Kn3RPPpj3AP+Azyfo93NpyMOif
         rMqUXyyWGfe3fRfkZF46rZqMAuk4Fw9w2boz+NAt4L+qW28ARxtsvb/QsZ5R5h+LPyLE
         LbA4ZqWKsQ+92SJKM7oLuR446lJCRxD3J+JJYyN4qr1r9km24KpFuSruGUvWS16Vv+VW
         PLew==
X-Gm-Message-State: APjAAAUDPDyOogdh8QTIQOCJ2QRdgickCO4GlsvU1BjerR7Ba0O05vfO
        YHMgom8anakOzxM7MnYhpPo=
X-Google-Smtp-Source: APXvYqxMOnY0H5x2seVGKnaSEPGyBJd2lKzLEa8n4+9QTNHnN3GtySgKLzsYZyLUJeTU+jvLOMAuOg==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr31873353wrr.70.1562225201923;
        Thu, 04 Jul 2019 00:26:41 -0700 (PDT)
Received: from merlot.mazyland.net (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.googlemail.com with ESMTPSA id p11sm5163388wrm.53.2019.07.04.00.26.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 00:26:41 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     jarkko.sakkinen@linux.intel.com
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] tpm: Fix null pointer dereference on chip register error path
Date:   Thu,  4 Jul 2019 09:26:15 +0200
Message-Id: <20190704072615.31143-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703230125.aynx4ianvqqjt5d7@linux.intel.com>
References: <20190703230125.aynx4ianvqqjt5d7@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If clk_enable is not defined and chip initialization
is canceled code hits null dereference.

Easily reproducible with vTPM init fail:
  swtpm chardev --tpmstate dir=nonexistent_dir --tpm2 --vtpm-proxy

BUG: kernel NULL pointer dereference, address: 00000000
...
Call Trace:
 tpm_chip_start+0x9d/0xa0 [tpm]
 tpm_chip_register+0x10/0x1a0 [tpm]
 vtpm_proxy_work+0x11/0x30 [tpm_vtpm_proxy]
 process_one_work+0x214/0x5a0
 worker_thread+0x134/0x3e0
 ? process_one_work+0x5a0/0x5a0
 kthread+0xd4/0x100
 ? process_one_work+0x5a0/0x5a0
 ? kthread_park+0x90/0x90
 ret_from_fork+0x19/0x24

Fixes: 719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
Cc: stable@vger.kernel.org # v5.1+
Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/char/tpm/tpm-chip.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 90325e1749fb..db6ac6f83948 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -77,6 +77,18 @@ static int tpm_go_idle(struct tpm_chip *chip)
 	return chip->ops->go_idle(chip);
 }
 
+static void tpm_clk_enable(struct tpm_chip *chip)
+{
+	if (chip->ops->clk_enable)
+		chip->ops->clk_enable(chip, true);
+}
+
+static void tpm_clk_disable(struct tpm_chip *chip)
+{
+	if (chip->ops->clk_enable)
+		chip->ops->clk_enable(chip, false);
+}
+
 /**
  * tpm_chip_start() - power on the TPM
  * @chip:	a TPM chip to use
@@ -89,13 +101,12 @@ int tpm_chip_start(struct tpm_chip *chip)
 {
 	int ret;
 
-	if (chip->ops->clk_enable)
-		chip->ops->clk_enable(chip, true);
+	tpm_clk_enable(chip);
 
 	if (chip->locality == -1) {
 		ret = tpm_request_locality(chip);
 		if (ret) {
-			chip->ops->clk_enable(chip, false);
+			tpm_clk_disable(chip);
 			return ret;
 		}
 	}
@@ -103,8 +114,7 @@ int tpm_chip_start(struct tpm_chip *chip)
 	ret = tpm_cmd_ready(chip);
 	if (ret) {
 		tpm_relinquish_locality(chip);
-		if (chip->ops->clk_enable)
-			chip->ops->clk_enable(chip, false);
+		tpm_clk_disable(chip);
 		return ret;
 	}
 
@@ -124,8 +134,7 @@ void tpm_chip_stop(struct tpm_chip *chip)
 {
 	tpm_go_idle(chip);
 	tpm_relinquish_locality(chip);
-	if (chip->ops->clk_enable)
-		chip->ops->clk_enable(chip, false);
+	tpm_clk_disable(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_chip_stop);
 
-- 
2.20.1

