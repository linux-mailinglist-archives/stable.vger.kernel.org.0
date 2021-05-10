Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829D8378F1C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241816AbhEJN21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242982AbhEJM3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:29:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 397BB6145F;
        Mon, 10 May 2021 12:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620649722;
        bh=thmzAZf9iH1VveaS5sV5nVLiuryScGt+oyOOrDw29CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLBIEcPUQJhjcz4rMbIwrQzGJBkXmoSKFgV9EI65vdWAGAlLZ/a3ZXoeg78ToOJ4u
         XJafKPZ1EAarQoTIa/H9Ls/tCOMGm/0tmnS9bw9/l2xvnla/BkC64brhvH8qy01YDw
         8mXjTKRLwjI9f3vvDr0lP6rKb7AqpWou4euSufNz0Hrz6V/ORdRmmlETKA8XMiIPVn
         ofr4LSItR/eTQpvXQwwETsFk9jB02a7K9K4IL1J1n5uG1kFSF4jHFUT0zyQD7fGvW0
         SzFjIYSnXEt5Mm9pDzLnrG+sgq16e+0USjre8BGxUt7JmDEX7OFBB/nlJ9ALbiY6EF
         /D1q53f6e9eXw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 2/2] tpm, tpm_tis: Reserve locality in tpm_tis_resume()
Date:   Mon, 10 May 2021 15:28:31 +0300
Message-Id: <20210510122831.409608-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510122831.409608-1-jarkko@kernel.org>
References: <20210510122831.409608-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reserve locality in tpm_tis_resume(), as it could be unsert after waking
up from a sleep state.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: stable@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v1:
* Testing done with Intel NUC5i5MYHE containing SLB9665 TPM 2.0 chip.
* The used test case: "echo mee | sudo tee /sys/power/state" executed
  without issues.

 drivers/char/tpm/tpm_tis_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 6fa150a3b75e..55b9d3965ae1 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1125,12 +1125,20 @@ int tpm_tis_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	/* TPM 1.2 requires self-test on resume. This function actually returns
+	/*
+	 * TPM 1.2 requires self-test on resume. This function actually returns
 	 * an error code but for unknown reason it isn't handled.
 	 */
-	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+		ret = request_locality(chip, 0);
+		if (ret < 0)
+			return ret;
+
 		tpm1_do_selftest(chip);
 
+		release_locality(chip, 0);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_tis_resume);
-- 
2.31.1

