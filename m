Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2D4FAB91
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 09:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfKMIA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 03:00:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54096 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725993AbfKMIA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 03:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573632057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CMk5IBNgQTUKXm1UH2KRTJi2cKWC2WnWXM6M0NEqON4=;
        b=MzAhovt2G9YZSZ4XyffpYNPH7JlP+a4cFlsASdV0KMV7v9dmcjvmT1rireMSLTzoN5aI5M
        4IjFOSEJRMqZi4GBTQuy8dGcFCnKU0dPEhCr2cqbVQqOR8y4zuMmPWat+3zYkR6wqw10Gg
        U/zC+B9DQqd0LNbWhBwMbjYL7fdwCwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-DZfi_6wuNua0lcrnQv12BA-1; Wed, 13 Nov 2019 03:00:54 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C5D118B5F6A;
        Wed, 13 Nov 2019 08:00:52 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-116-198.phx2.redhat.com [10.3.116.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42F5C5D9E5;
        Wed, 13 Nov 2019 08:00:52 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     linux-integrity@vger.kernel.org
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] tpm: move TPM_CHIP_FLAG_HAVE_TIMEOUTS check
Date:   Wed, 13 Nov 2019 01:00:02 -0700
Message-Id: <20191113080002.14932-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: DZfi_6wuNua0lcrnQv12BA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since tpm1_get_timeouts and tpm2_get_timeouts are now called directly
by the auto startup code in addition to being called by
tpm_get_timeouts, push the flag check down into the individual
functions to avoid going through them again if they've already set the
TPM_CHIP_FLAG_HAVE_TIMEOUTS flag.

Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: d4a317563207 ("tpm: move tpm 1.x selftest code from tpm-interface.c =
tpm1-cmd.c")
Fixes: 9db7fe187c54 ("tpm: factor out tpm_startup function")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/char/tpm/tpm-interface.c | 3 ---
 drivers/char/tpm/tpm1-cmd.c      | 3 +++
 drivers/char/tpm/tpm2-cmd.c      | 3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interf=
ace.c
index d7a3888ad80f..3c9e14981ce6 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -237,9 +237,6 @@ EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
=20
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
-=09if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
-=09=09return 0;
-
 =09if (chip->flags & TPM_CHIP_FLAG_TPM2)
 =09=09return tpm2_get_timeouts(chip);
 =09else
diff --git a/drivers/char/tpm/tpm1-cmd.c b/drivers/char/tpm/tpm1-cmd.c
index 149e953ca369..5330b32d1469 100644
--- a/drivers/char/tpm/tpm1-cmd.c
+++ b/drivers/char/tpm/tpm1-cmd.c
@@ -345,6 +345,9 @@ int tpm1_get_timeouts(struct tpm_chip *chip)
 =09unsigned long timeout_old[4], timeout_chip[4], timeout_eff[4];
 =09ssize_t rc;
=20
+=09if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
+=09=09return 0;
+
 =09rc =3D tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, NULL,
 =09=09=09 sizeof(cap.timeout));
 =09if (rc =3D=3D TPM_ERR_INVALID_POSTINIT) {
diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index ba9acae83bff..55d96be86ed8 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -38,6 +38,9 @@ static struct tpm2_hash tpm2_hash_map[] =3D {
=20
 int tpm2_get_timeouts(struct tpm_chip *chip)
 {
+=09if (chip->flags & TPM_CHIP_FLAG_HAVE_TIMEOUTS)
+=09=09return 0;
+
 =09/* Fixed timeouts for TPM2 */
 =09chip->timeout_a =3D msecs_to_jiffies(TPM2_TIMEOUT_A);
 =09chip->timeout_b =3D msecs_to_jiffies(TPM2_TIMEOUT_B);
--=20
2.24.0

