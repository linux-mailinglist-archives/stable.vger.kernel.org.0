Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E992395517
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 07:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhEaFhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 01:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhEaFhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 01:37:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B215E61186;
        Mon, 31 May 2021 05:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622439336;
        bh=/pP+VB8UmdQWjfpsEUOQMtIfWcWvdX5x1Oxhp2mP8mk=;
        h=From:To:Cc:Subject:Date:From;
        b=NPY8tEPIkDJGe0gU+cj5lJByuflz4T96so+dlRKX5zDrimPoeEOXrQBVvyjNE8qA/
         JLNS3ABtxs5eE/9JJxoeI0lxP9BrO97bUTMFaBE5lthM8h/NZZqWm7PROhqvQGgpiz
         Hf57WfdexOwopAhGX0HtvriI/eBidg8jF0VhMUHvKqTilP9Or4b4YdUmI6t6qdbhNX
         mkFtLxqQevWtCQYKIrP+zkW076m5jz/NzROdr9XbgmadLDucRbUaWxK0MzFxjAj5Ng
         HqMV6gKsQUzI91heBWsVrWpGwRBmsk9PieKEWJCenoslq5Jovw8uSp7kPTe2CTKY+M
         njMqbWhx8sPfg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2] tpm: Replace WARN_ONCE() with dev_err_once() in tpm_tis_status()
Date:   Mon, 31 May 2021 08:34:27 +0300
Message-Id: <20210531053427.118552-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Do not torn down the system when getting invalid status from a TPM chip.
This can happen when panic-on-warn is used.

In addition, print out the value of TPM_STS.x instead of "invalid
status". In order to get the earlier benefits for forensics, also call
dump_stack().

Link: https://lore.kernel.org/keyrings/YKzlTR1AzUigShtZ@kroah.com/
Fixes: 55707d531af6 ("tpm_tis: Add a check for invalid status")
Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v2:
Dump also stack only once.

 drivers/char/tpm/tpm_tis_core.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 55b9d3965ae1..ce410f19eff2 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -188,21 +188,33 @@ static int request_locality(struct tpm_chip *chip, int l)
 static u8 tpm_tis_status(struct tpm_chip *chip)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc;
+	static unsigned long klog_once;
 	u8 status;
+	int rc;
 
 	rc = tpm_tis_read8(priv, TPM_STS(priv->locality), &status);
 	if (rc < 0)
 		return 0;
 
 	if (unlikely((status & TPM_STS_READ_ZERO) != 0)) {
-		/*
-		 * If this trips, the chances are the read is
-		 * returning 0xff because the locality hasn't been
-		 * acquired.  Usually because tpm_try_get_ops() hasn't
-		 * been called before doing a TPM operation.
-		 */
-		WARN_ONCE(1, "TPM returned invalid status\n");
+		if  (!test_and_set_bit(BIT(0), &klog_once)) {
+			/*
+			 * If this trips, the chances are the read is
+			 * returning 0xff because the locality hasn't been
+			 * acquired.  Usually because tpm_try_get_ops() hasn't
+			 * been called before doing a TPM operation.
+			 */
+			dev_err(&chip->dev, "invalid TPM_STS.x 0x%02x, dumping stack for forensics\n",
+				status);
+
+			/*
+			 * Dump stack for forensics, as invalid TPM_STS.x could be
+			 * potentially triggered by impaired tpm_try_get_ops() or
+			 * tpm_find_get_ops().
+			 */
+			dump_stack();
+		}
+
 		return 0;
 	}
 
-- 
2.31.1

