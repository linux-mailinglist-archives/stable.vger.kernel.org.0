Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6BDF9ED4
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 01:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfKMACw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 19:02:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22090 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726910AbfKMACt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 19:02:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573603368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mFZNYzU4aq8T7KuOOh7683mZkvSGsdedXb2PwJoCtQ4=;
        b=LwD23NvnG+Lmyq1AXSYQe28KMn5vIDePVlz6QJaw1vl2gNZaHB/tlPZ3ZTu05knWns8GL6
        veuzD0CmPDGizWIUbCU5y8Nd4mXysdbI8VD2rOK4H67bNHW+202LTJt9JxBESVaNGWq+w7
        gT8JdYqTl23YKbsPeVQ6DtL16Pe9Iok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-5EKU7PrLP_mDMrmo4DPU2w-1; Tue, 12 Nov 2019 19:02:47 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C42CA800EB3;
        Wed, 13 Nov 2019 00:02:45 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-116-198.phx2.redhat.com [10.3.116.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 401CE64020;
        Wed, 13 Nov 2019 00:02:45 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Christian Bundy <christianbundy@fraction.io>
Subject: [PATCH v3] tpm_tis: turn on TPM before calling tpm_get_timeouts
Date:   Tue, 12 Nov 2019 17:02:43 -0700
Message-Id: <20191113000243.16611-1-jsnitsel@redhat.com>
In-Reply-To: <20191111233418.17676-1-jsnitsel@redhat.com>
References: <20191111233418.17676-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 5EKU7PrLP_mDMrmo4DPU2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With power gating moved out of the tpm_transmit code we need
to power on the TPM prior to calling tpm_get_timeouts.

Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: a3fbfae82b4c ("tpm: take TPM chip power gating out of tpm_transmit()=
")
Reported-by: Christian Bundy <christianbundy@fraction.io>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
v3: call tpm_chip_stop in error path
v2: fix stable cc to correct address

 drivers/char/tpm/tpm_tis_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_cor=
e.c
index 270f43acbb77..806acc666696 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -974,13 +974,14 @@ int tpm_tis_core_init(struct device *dev, struct tpm_=
tis_data *priv, int irq,
 =09=09 * to make sure it works. May as well use that command to set the
 =09=09 * proper timeouts for the driver.
 =09=09 */
+=09=09tpm_chip_start(chip);
 =09=09if (tpm_get_timeouts(chip)) {
 =09=09=09dev_err(dev, "Could not get TPM timeouts and durations\n");
 =09=09=09rc =3D -ENODEV;
+=09=09=09tpm_chip_stop(chip);
 =09=09=09goto out_err;
 =09=09}
=20
-=09=09tpm_chip_start(chip);
 =09=09chip->flags |=3D TPM_CHIP_FLAG_IRQ;
 =09=09if (irq) {
 =09=09=09tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
--=20
2.24.0

