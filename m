Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C101320577
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 13:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhBTM4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Feb 2021 07:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhBTM4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Feb 2021 07:56:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F19864EDE;
        Sat, 20 Feb 2021 12:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613825752;
        bh=K9h9PwzVuFck/DHhyJJBDnkh9g7ovnOcpR87cc2Yuxw=;
        h=From:To:Cc:Subject:Date:From;
        b=JB7w7aKtndSoF2YCbnKauXDpt6qxCv0c08t34lIgILK/xG4FJ5OXVIETWuIduO7o2
         jxHKvDypSeu4Xvp+SCXvI2WVUtahehY+1yIABz5UJYHADTt65dNFPr7E1sy7IHvl8Z
         1ZMRtCnRiKYIdBalQru4TDqLa5Zs9hU3neJ3Cpnard7vNVL+2HD1BMVlxdc+C/kxxh
         cYeRT6rg3F5GYgLTJF/MHpEULIl7Zwt0cPmyKXstR+wT327PXnYvrcuyCbg/nuFvYi
         z+alJh9wV4dh36eB4wjPuUNLihjguisv4hdfl7LyvolE0rSjAXxf9f77m/qE4/rQsA
         lRmRdP4v8jYvg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Lukasz Majczak <lma@semihalf.com>,
        Laurent Bigonville <bigon@debian.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 2/2] tpm, tpm_tis: Decorate tpm_tis_gen_interrupt() with request_locality()
Date:   Sat, 20 Feb 2021 14:55:33 +0200
Message-Id: <20210220125534.20707-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Majczak <lma@semihalf.com>

This is shown with Samsung Chromebook Pro (Caroline) with TPM 1.2
(SLB 9670):

[    4.324298] TPM returned invalid status
[    4.324806] WARNING: CPU: 2 PID: 1 at drivers/char/tpm/tpm_tis_core.c:275 tpm_tis_status+0x86/0x8f

Background
==========

TCG PC Client Platform TPM Profile (PTP) Specification, paragraph 6.1 FIFO
Interface Locality Usage per Register, Table 39 Register Behavior Based on
Locality Setting for FIFO - a read attempt to TPM_STS_x Registers returns
0xFF in case of lack of locality.

The fix
=======

Decorate tpm_tis_gen_interrupt() with request_locality() and
release_locality().

Cc: Laurent Bigonville <bigon@debian.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Signed-off-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 30843954aa36..a2e0395cbe61 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -707,12 +707,22 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	const char *desc = "attempting to generate an interrupt";
 	u32 cap2;
 	cap_t cap;
+	int ret;
 
+	/* TPM 2.0 */
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		return tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
-	else
-		return tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc,
-				  0);
+
+	/* TPM 1.2 */
+	ret = request_locality(chip, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
+
+	release_locality(chip, 0);
+
+	return ret;
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
-- 
2.30.1

