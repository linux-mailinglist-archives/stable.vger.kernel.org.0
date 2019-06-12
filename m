Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD63141F72
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfFLImW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 04:42:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46800 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfFLImW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 04:42:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so15872920wrw.13;
        Wed, 12 Jun 2019 01:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IfVZRhqj12lorlSiH6uWMXLG8YWDSUqzogRrWK/FINE=;
        b=P4wGwS1yN5nTEa9Pgn2GKBnV6ajceweuaB9mQYYd1P79XeOnPSt8arslv/pSzyWCBg
         1WQq2eVSYPin3lFnMMsmE0LruLnYfZynh7zYy3/DjuS4p2Xok6iQha98o7MHZULO0Fmx
         OxweR5OUmQmzJ1TKNnZnQshrkRqtlqnI+QC9/qPEeCd0bL2wJt7CKxE1COgbkNDdhENG
         KshRD1UlCSlKbEXM+Eh4DOV/2XzVBlaGsK2c2QehO3FGzieaRnr66UrZaZfzx4i1zADY
         DJKBdgYk6jvb4iO8KD3JYITT3chpAJTQ9ebJor5qhraInIMxbP1rfr0g0ouMnt0tIQMT
         TErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IfVZRhqj12lorlSiH6uWMXLG8YWDSUqzogRrWK/FINE=;
        b=pdVP4avPxHr/jUMzA2iUYdCk8Hv9FOxQUX6oYG7fKBmUW+68wR1TRBpk7+a7BM1mBr
         RzJ5lhdpAjcQbwBmsrvmE0Jkbk8x8xzOS3SY0pNYuHjJMG8tb9gJkJ8YaiAokV0VrfqI
         3auAt0uMGDWlojKPBefkovKcp/czDr1L/MlevQZaePkihkbm7+WjEC5/4hazk+mYdJtg
         Gcgj+YiVE8/7WKqgIlCZ/tk2ggjRAomzB9ozDw+USa9ZGQ4ey+ZrNOkukrVNXNVIHoCi
         LGAJdZEWI0tOZ98etdhdNXdrMFC9RsxyDI3DUiRoJ1X16oKaitePqNJBkR2f+kJ0eCRA
         jdxA==
X-Gm-Message-State: APjAAAWYwLNrPWRZPO5/Y+eLMCmDoLsXiPNpv4NwjjkamxtTrYimAUsA
        uwJDpfoZ2VWQKb/ULeOkdYxhBxmjuww=
X-Google-Smtp-Source: APXvYqwyaArrhZrrMoKMd5qKAhAmt/z7B6na/1vwS/x83Dh0CUzmQFcQmpWvzxVoQClsNv4zvAP5Xw==
X-Received: by 2002:adf:9dcc:: with SMTP id q12mr3396418wre.93.1560328940554;
        Wed, 12 Jun 2019 01:42:20 -0700 (PDT)
Received: from merlot.mazyland.net (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.googlemail.com with ESMTPSA id s9sm5052675wmc.11.2019.06.12.01.42.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 01:42:19 -0700 (PDT)
From:   Milan Broz <gmazyland@gmail.com>
To:     linux-integrity@vger.kernel.org
Cc:     Milan Broz <gmazyland@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] tpm: Fix null pointer dereference on chip register error path
Date:   Wed, 12 Jun 2019 10:42:10 +0200
Message-Id: <20190612084210.13562-1-gmazyland@gmail.com>
X-Mailer: git-send-email 2.20.1
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

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm-chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 90325e1749fb..4c2af643d698 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -95,7 +95,8 @@ int tpm_chip_start(struct tpm_chip *chip)
 	if (chip->locality == -1) {
 		ret = tpm_request_locality(chip);
 		if (ret) {
-			chip->ops->clk_enable(chip, false);
+			if (chip->ops->clk_enable)
+				chip->ops->clk_enable(chip, false);
 			return ret;
 		}
 	}
-- 
2.20.1

