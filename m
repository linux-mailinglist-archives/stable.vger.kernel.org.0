Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2DE1AC278
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895830AbgDPN2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:28:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895781AbgDPN2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D8F6217D8;
        Thu, 16 Apr 2020 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043712;
        bh=+1jJAipbKsBP4A6cGWqZanA8GOgZ3Am4/T7UsiGhELc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTIzuM8JSwMbAPQjtlNFowWvB7ENUgK+O1VV8gvPB1JNw+OzyZcBHAmYAtgsucriV
         cqnB7LdlBsaKeboQPBqRQZqmeyNLtu97mN5MJiLe8kM6gSPOLxjXD63FXknR8IwdMC
         2tDW+uiwINOdsC58JO+eyKHtXM0e5TGqo9OXHNKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Garrett <matthewgarrett@google.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4.19 068/146] tpm: Dont make log failures fatal
Date:   Thu, 16 Apr 2020 15:23:29 +0200
Message-Id: <20200416131252.245390317@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Garrett <matthewgarrett@google.com>

commit 805fa88e0780b7ce1cc9b649dd91a0a7164c6eb4 upstream.

If a TPM is in disabled state, it's reasonable for it to have an empty
log. Bailing out of probe in this case means that the PPI interface
isn't available, so there's no way to then enable the TPM from the OS.
In general it seems reasonable to ignore log errors - they shouldn't
interfere with any other TPM functionality.

Signed-off-by: Matthew Garrett <matthewgarrett@google.com>
Cc: stable@vger.kernel.org # 4.19.x
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/eventlog/common.c |   12 ++++--------
 drivers/char/tpm/tpm-chip.c        |    4 +---
 drivers/char/tpm/tpm.h             |    2 +-
 3 files changed, 6 insertions(+), 12 deletions(-)

--- a/drivers/char/tpm/eventlog/common.c
+++ b/drivers/char/tpm/eventlog/common.c
@@ -104,11 +104,8 @@ static int tpm_read_log(struct tpm_chip
  *
  * If an event log is found then the securityfs files are setup to
  * export it to userspace, otherwise nothing is done.
- *
- * Returns -ENODEV if the firmware has no event log or securityfs is not
- * supported.
  */
-int tpm_bios_log_setup(struct tpm_chip *chip)
+void tpm_bios_log_setup(struct tpm_chip *chip)
 {
 	const char *name = dev_name(&chip->dev);
 	unsigned int cnt;
@@ -117,7 +114,7 @@ int tpm_bios_log_setup(struct tpm_chip *
 
 	rc = tpm_read_log(chip);
 	if (rc < 0)
-		return rc;
+		return;
 	log_version = rc;
 
 	cnt = 0;
@@ -163,13 +160,12 @@ int tpm_bios_log_setup(struct tpm_chip *
 		cnt++;
 	}
 
-	return 0;
+	return;
 
 err:
-	rc = PTR_ERR(chip->bios_dir[cnt]);
 	chip->bios_dir[cnt] = NULL;
 	tpm_bios_log_teardown(chip);
-	return rc;
+	return;
 }
 
 void tpm_bios_log_teardown(struct tpm_chip *chip)
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -463,9 +463,7 @@ int tpm_chip_register(struct tpm_chip *c
 
 	tpm_sysfs_add_device(chip);
 
-	rc = tpm_bios_log_setup(chip);
-	if (rc != 0 && rc != -ENODEV)
-		return rc;
+	tpm_bios_log_setup(chip);
 
 	tpm_add_ppi(chip);
 
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -602,6 +602,6 @@ int tpm2_prepare_space(struct tpm_chip *
 int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 		      u32 cc, u8 *buf, size_t *bufsiz);
 
-int tpm_bios_log_setup(struct tpm_chip *chip);
+void tpm_bios_log_setup(struct tpm_chip *chip);
 void tpm_bios_log_teardown(struct tpm_chip *chip);
 #endif


