Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C92378F18
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbhEJN2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242920AbhEJM3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E63361432;
        Mon, 10 May 2021 12:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620649719;
        bh=+r27oHZ1a/tQTDcHtEZoHK25erNJaGMCMvSY8xQQE44=;
        h=From:To:Cc:Subject:Date:From;
        b=R4raJGkfjmUstqpiDFgvi85Tk3cHQDR9P1AqLYGVGZ1T+suKkJ3P8k73yhC5kXOvh
         PUZn+lYorbrWTSUwg7xQluGeXuzbDAkGYFhemk/MVyUTJ7wqcKBIiD/sKf3LLixQZn
         8WX/FIsIta6sTAy2vE5dzexiAqfhDAgQ7sJWnu1Iki5jGAF/ZJbCHFoayXjK6cCibq
         E/hbKJOeAHwVPpCSt5jyzEDimMh6jp1ixb9u5UEewR6XDMi+aiFrCGieSgwWoWSEWl
         txZPW8liKfoVLCtUUWAyWXM4ICr9SEgmJ9v0wLslTwvLeNZ9Sph/9Ty2Rk74SDRMEu
         s5KfdTa6/P99A==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 1/2] tpm, tpm_tis: Extend locality handling to TPM2 in tpm_tis_gen_interrupt()
Date:   Mon, 10 May 2021 15:28:30 +0300
Message-Id: <20210510122831.409608-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The earlier fix (linked) only partially fixed the locality handling bug
in tpm_tis_gen_interrupt(), i.e. only for TPM 1.x.

Extend the locality handling to cover TPM2.

Cc: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-integrity/20210220125534.20707-1-jarkko@kernel.org/
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v1:
* Testing done with Intel NUC5i5MYHE with SLB9665 TPM2 chip.

 drivers/char/tpm/tpm_tis_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index a2e0395cbe61..6fa150a3b75e 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -709,16 +709,14 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	cap_t cap;
 	int ret;
 
-	/* TPM 2.0 */
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
-
-	/* TPM 1.2 */
 	ret = request_locality(chip, 0);
 	if (ret < 0)
 		return ret;
 
-	ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		ret = tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
+	else
+		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
 
 	release_locality(chip, 0);
 
-- 
2.31.1

