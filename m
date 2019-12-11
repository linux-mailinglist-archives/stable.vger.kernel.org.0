Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DAE11C07C
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 00:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfLKXTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 18:19:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44277 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727030AbfLKXTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 18:19:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576106344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7dJcxVu7RPHrA9N3SIaEzHtFnUyKVlhYarW5FtIpICo=;
        b=QLGm3S2d/zGO8enXkDQ9au3D2Jr54v9o6xpBb6zsqL11Cp3rHEN+zvbuo9iExnQf7CSPAA
        vpvMtVlvEPKMRAK+7SKJybwClh+WZ2FMGP1Z9BfIba77lRNBAuLL3PUcGDVJOmk8jE5txU
        1GE/KI3MpJl9MRpuv5pY6EkIkZrovus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-q9ROnZ_cNXOGc3XKgyn4yA-1; Wed, 11 Dec 2019 18:19:01 -0500
X-MC-Unique: q9ROnZ_cNXOGc3XKgyn4yA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEF6318B5FA1;
        Wed, 11 Dec 2019 23:18:59 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-116-36.phx2.redhat.com [10.3.116.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE09E1891F;
        Wed, 11 Dec 2019 23:18:23 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Christian Bundy <christianbundy@fraction.io>,
        Dan Williams <dan.j.williams@intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        stable@vger.kernel.org, linux-intergrity@vger.kernel.org
Subject: [PATCH] tpm_tis: reserve chip for duration of tpm_tis_core_init
Date:   Wed, 11 Dec 2019 16:17:58 -0700
Message-Id: <20191211231758.22263-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Instead of repeatedly calling tpm_chip_start/tpm_chip_stop when
issuing commands to the tpm during initialization, just reserve the
chip after wait_startup, and release it when we are ready to call
tpm_chip_register.

Cc: Christian Bundy <christianbundy@fraction.io>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Cc: linux-intergrity@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit=
()")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/char/tpm/tpm_tis_core.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_c=
ore.c
index 8af2cee1a762..308756d278b3 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -978,13 +978,13 @@ int tpm_tis_core_init(struct device *dev, struct tp=
m_tis_data *priv, int irq,
=20
 	if (wait_startup(chip, 0) !=3D 0) {
 		rc =3D -ENODEV;
-		goto out_err;
+		goto out_start;
 	}
=20
 	/* Take control of the TPM's interrupt hardware and shut it off */
 	rc =3D tpm_tis_read32(priv, TPM_INT_ENABLE(priv->locality), &intmask);
 	if (rc < 0)
-		goto out_err;
+		goto out_start;
=20
 	intmask |=3D TPM_INTF_CMD_READY_INT | TPM_INTF_LOCALITY_CHANGE_INT |
 		   TPM_INTF_DATA_AVAIL_INT | TPM_INTF_STS_VALID_INT;
@@ -993,9 +993,8 @@ int tpm_tis_core_init(struct device *dev, struct tpm_=
tis_data *priv, int irq,
=20
 	rc =3D tpm_chip_start(chip);
 	if (rc)
-		goto out_err;
+		goto out_start;
 	rc =3D tpm2_probe(chip);
-	tpm_chip_stop(chip);
 	if (rc)
 		goto out_err;
=20
@@ -1059,7 +1058,6 @@ int tpm_tis_core_init(struct device *dev, struct tp=
m_tis_data *priv, int irq,
 			goto out_err;
 		}
=20
-		tpm_chip_start(chip);
 		chip->flags |=3D TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
@@ -1070,18 +1068,17 @@ int tpm_tis_core_init(struct device *dev, struct =
tpm_tis_data *priv, int irq,
 		} else {
 			tpm_tis_probe_irq(chip, intmask);
 		}
-		tpm_chip_stop(chip);
 	}
+	tpm_chip_stop(chip);
=20
 	rc =3D tpm_chip_register(chip);
 	if (rc)
-		goto out_err;
-
-	if (chip->ops->clk_enable !=3D NULL)
-		chip->ops->clk_enable(chip, false);
+		goto out_start;
=20
 	return 0;
 out_err:
+	tpm_chip_stop(chip);
+out_start:
 	if ((chip->ops !=3D NULL) && (chip->ops->clk_enable !=3D NULL))
 		chip->ops->clk_enable(chip, false);
=20
--=20
2.24.0

