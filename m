Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401E2320328
	for <lists+stable@lfdr.de>; Sat, 20 Feb 2021 03:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBTChn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 21:37:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhBTChl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 21:37:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD88B64E54;
        Sat, 20 Feb 2021 02:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613788620;
        bh=11VjwrLVTaCchWbSZbfpOpPCXvnZn7rLf+bfTZNteK0=;
        h=From:To:Cc:Subject:Date:From;
        b=shuls3n1ZfjhymTGI0HzOP4nDn77pgLswngIsQrM/9QfWkOzjJJdpnFmiIvaXzKST
         eM64BxW7r8sb9di/kYILPup5NHw9PKOvoPmRQizFQRLXCUUOiMLLtpGlLiEjLGWJdT
         aXgCn7A1yn+E1w2mIgU0KRKXraCuqKJJ3lowS7hQEmaU6VMZrjYW+LuRxGE3o3aCyc
         IVmTgv5O+EKpgvt2EdGzxgMPpys5DOlk7sAicYOf4myKNmCR60Ugk6hA6Dw/Jjvly4
         YkA6a3j2LxMEqFVaD7uZvr+nu+cG1CXNgVVDun/lGORtFzrcVdtdiHeRqufnMif2l/
         LeWU0c2wNQYZA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Laurent Bigonville <bigon@debian.org>, stable@vger.kernel.org,
        Lukasz Majczak <lma@semihalf.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [PATCH 1/2] tpm, tpm_tis: Decorate tpm_get_timeouts() with request_locality()
Date:   Sat, 20 Feb 2021 04:36:41 +0200
Message-Id: <20210220023641.8568-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Decorate tpm_get_timeouts() with request_locality() and release_locality().

Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()")
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Laurent Bigonville <bigon@debian.org>
Cc: stable@vger.kernel.org
Reported-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 431919d5f48a..30843954aa36 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1019,11 +1019,21 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	init_waitqueue_head(&priv->read_queue);
 	init_waitqueue_head(&priv->int_queue);
 	if (irq != -1) {
-		/* Before doing irq testing issue a command to the TPM in polling mode
+		/*
+		 * Before doing irq testing issue a command to the TPM in polling mode
 		 * to make sure it works. May as well use that command to set the
 		 * proper timeouts for the driver.
 		 */
-		if (tpm_get_timeouts(chip)) {
+
+		rc = request_locality(chip, 0);
+		if (rc < 0)
+			goto out_err;
+
+		rc = tpm_get_timeouts(chip);
+
+		release_locality(chip, 0);
+
+		if (rc) {
 			dev_err(dev, "Could not get TPM timeouts and durations\n");
 			rc = -ENODEV;
 			goto out_err;
-- 
2.30.1

