Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8661E20B3A4
	for <lists+stable@lfdr.de>; Fri, 26 Jun 2020 16:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgFZOeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 10:34:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:45202 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgFZOeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jun 2020 10:34:44 -0400
IronPort-SDR: G3DGm09CveZ+FRfIXAQHdLZZ3pE/R1QmJgfjFX440THoGOA01xv2bYBbbbGI3NRwWLy67gkNQf
 O0b5qUnX20/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="125543201"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="125543201"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 07:34:43 -0700
IronPort-SDR: hvr2GwvSgu67UN13TX3i1cx6xPeuqscnnbTFJUQtLl8I/4XRPZUo8yycMk+bABaIixayDn61GU
 np7qqGSSD24w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="265639847"
Received: from cgheban-mobl.ger.corp.intel.com (HELO localhost) ([10.249.40.199])
  by fmsmga008.fm.intel.com with ESMTP; 26 Jun 2020 07:34:38 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm: Define TPM2_SPACE_BUFFER_SIZE to replace the use of PAGE_SIZE
Date:   Fri, 26 Jun 2020 17:34:35 +0300
Message-Id: <20200626143436.396889-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The size of the buffers for storing context's and sessions can vary from
arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
maximum for PPC64). Define a fixed buffer size set to 16 kB. This should
be enough for most use with three handles (that is how many we allow at
the moment).

Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm2-space.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 982d341d8837..9bef646093d1 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -15,6 +15,8 @@
 #include <asm/unaligned.h>
 #include "tpm.h"
 
+#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
+
 enum tpm2_handle_types {
 	TPM2_HT_HMAC_SESSION	= 0x02000000,
 	TPM2_HT_POLICY_SESSION	= 0x03000000,
@@ -40,11 +42,11 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
 
 int tpm2_init_space(struct tpm_space *space)
 {
-	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->context_buf = kzalloc(TPM2_SPACE_BUFFER_SIZE, GFP_KERNEL);
 	if (!space->context_buf)
 		return -ENOMEM;
 
-	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->session_buf = kzalloc(TPM2_SPACE_BUFFER_SIZE, GFP_KERNEL);
 	if (space->session_buf == NULL) {
 		kfree(space->context_buf);
 		return -ENOMEM;
@@ -311,8 +313,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
 	       sizeof(space->context_tbl));
 	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
-	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
+	memcpy(chip->work_space.context_buf, space->context_buf,
+	       TPM2_SPACE_BUFFER_SIZE);
+	memcpy(chip->work_space.session_buf, space->session_buf,
+	       TPM2_SPACE_BUFFER_SIZE);
 
 	rc = tpm2_load_space(chip);
 	if (rc) {
@@ -492,8 +496,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->context_tbl[i],
-				       space->context_buf, PAGE_SIZE,
-				       &offset);
+				       space->context_buf,
+				       TPM2_SPACE_BUFFER_SIZE, &offset);
 		if (rc == -ENOENT) {
 			space->context_tbl[i] = 0;
 			continue;
@@ -509,9 +513,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->session_tbl[i],
-				       space->session_buf, PAGE_SIZE,
-				       &offset);
-
+				       space->session_buf,
+				       TPM2_SPACE_BUFFER_SIZE, &offset);
 		if (rc == -ENOENT) {
 			/* handle error saving session, just forget it */
 			space->session_tbl[i] = 0;
@@ -557,8 +560,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 	       sizeof(space->context_tbl));
 	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
-	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
+	memcpy(space->context_buf, chip->work_space.context_buf,
+	       TPM2_SPACE_BUFFER_SIZE);
+	memcpy(space->session_buf, chip->work_space.session_buf,
+	       TPM2_SPACE_BUFFER_SIZE);
 
 	return 0;
 out:
-- 
2.25.1

