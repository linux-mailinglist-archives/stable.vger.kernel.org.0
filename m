Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76DA32916F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243012AbhCAU0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243208AbhCAUSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:18:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93E4F65291;
        Mon,  1 Mar 2021 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621833;
        bh=lJlcJo5vjrIG2dfiBblGpI5tolIwegM+Ah7c4SbmBTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKroA3vZiCR0FtaNK4Y9C0qNTCmoub0U3Cd3CJO9N02toae14AW0gNvwSx9jVVGzD
         cORbJZ20WcZTeebtRPn8x92yaLsqhxbOThGxY/F0Hw026b6dfBJEMtbqtUoHtx6Ch2
         6NIM6svLm5M5wadqzxPC3mUjh+ZAbxfJc56wgQRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@ger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.11 630/775] tpm_tis: Clean up locality release
Date:   Mon,  1 Mar 2021 17:13:18 +0100
Message-Id: <20210301161232.532896631@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit e42acf104d6e0bd7ccd2f09103d5be5e6d3c637c upstream.

The current release locality code seems to be based on the
misunderstanding that the TPM interrupts when a locality is released:
it doesn't, only when the locality is acquired.

Furthermore, there seems to be no point in waiting for the locality to
be released.  All it does is penalize the last TPM user.  However, if
there's no next TPM user, this is a pointless wait and if there is a
next TPM user, they'll pay the penalty waiting for the new locality
(or possibly not if it's the same as the old locality).

Fix the code by making release_locality as simple write to release
with no waiting for completion.

Cc: stable@ger.kernel.org
Fixes: 33bafe90824b ("tpm_tis: verify locality released before returning from release_locality")
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   47 ----------------------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -135,58 +135,13 @@ static bool check_locality(struct tpm_ch
 	return false;
 }
 
-static bool locality_inactive(struct tpm_chip *chip, int l)
-{
-	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	int rc;
-	u8 access;
-
-	rc = tpm_tis_read8(priv, TPM_ACCESS(l), &access);
-	if (rc < 0)
-		return false;
-
-	if ((access & (TPM_ACCESS_VALID | TPM_ACCESS_ACTIVE_LOCALITY))
-	    == TPM_ACCESS_VALID)
-		return true;
-
-	return false;
-}
-
 static int release_locality(struct tpm_chip *chip, int l)
 {
 	struct tpm_tis_data *priv = dev_get_drvdata(&chip->dev);
-	unsigned long stop, timeout;
-	long rc;
 
 	tpm_tis_write8(priv, TPM_ACCESS(l), TPM_ACCESS_ACTIVE_LOCALITY);
 
-	stop = jiffies + chip->timeout_a;
-
-	if (chip->flags & TPM_CHIP_FLAG_IRQ) {
-again:
-		timeout = stop - jiffies;
-		if ((long)timeout <= 0)
-			return -1;
-
-		rc = wait_event_interruptible_timeout(priv->int_queue,
-						      (locality_inactive(chip, l)),
-						      timeout);
-
-		if (rc > 0)
-			return 0;
-
-		if (rc == -ERESTARTSYS && freezing(current)) {
-			clear_thread_flag(TIF_SIGPENDING);
-			goto again;
-		}
-	} else {
-		do {
-			if (locality_inactive(chip, l))
-				return 0;
-			tpm_msleep(TPM_TIMEOUT);
-		} while (time_before(jiffies, stop));
-	}
-	return -1;
+	return 0;
 }
 
 static int request_locality(struct tpm_chip *chip, int l)


