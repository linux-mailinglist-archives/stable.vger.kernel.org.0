Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206F3AECE3
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbfIJOYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:24:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:58639 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbfIJOYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 10:24:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 07:24:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="196564577"
Received: from agreppma-mobl.ger.corp.intel.com (HELO localhost) ([10.252.53.7])
  by orsmga002.jf.intel.com with ESMTP; 10 Sep 2019 07:24:45 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm: Call tpm_put_ops() when the validation for @digests fails
Date:   Tue, 10 Sep 2019 15:24:36 +0100
Message-Id: <20190910142437.20889-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The chip is not released when the validation for @digests fails. Add
tpm_put_ops() to the failure path.

Cc: stable@vger.kernel.org
Reported-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 208e5ba40e6e..c7eeb40feac8 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -320,18 +320,22 @@ int tpm_pcr_extend(struct tpm_chip *chip, u32 pcr_idx,
 	if (!chip)
 		return -ENODEV;
 
-	for (i = 0; i < chip->nr_allocated_banks; i++)
-		if (digests[i].alg_id != chip->allocated_banks[i].alg_id)
-			return -EINVAL;
+	for (i = 0; i < chip->nr_allocated_banks; i++) {
+		if (digests[i].alg_id != chip->allocated_banks[i].alg_id) {
+			rc = EINVAL;
+			goto out;
+		}
+	}
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		rc = tpm2_pcr_extend(chip, pcr_idx, digests);
-		tpm_put_ops(chip);
-		return rc;
+		goto out;
 	}
 
 	rc = tpm1_pcr_extend(chip, pcr_idx, digests[0].digest,
 			     "attempting extend a PCR value");
+
+out:
 	tpm_put_ops(chip);
 	return rc;
 }
-- 
2.20.1

