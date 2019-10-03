Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C856CA906
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404375AbfJCQgL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:36:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404371AbfJCQgK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B57042086A;
        Thu,  3 Oct 2019 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120570;
        bh=5c5TRDo84sJDQ13UTbdqdWaHh1lRiJyZiHqi4clyXMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enYHxHnE5kNtFbGEHcPAloEAsLISa0TNt9jl0BVsRoceEZsQXDP8ee0uEL/OOsmou
         yo7eeUyTr18/B2hrpFVVfwpKZ80o72bW0/5/sTPT/6i5PftHMsuSwnypC9OllurHEa
         2bCnfhaM+gtoFrVONtgWykx4E1+gI2tBGh6kVEXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: [PATCH 5.2 271/313] KEYS: trusted: correctly initialize digests and fix locking issue
Date:   Thu,  3 Oct 2019 17:54:09 +0200
Message-Id: <20191003154559.738687404@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 9f75c82246313d4c2a6bc77e947b45655b3b5ad5 upstream.

Commit 0b6cf6b97b7e ("tpm: pass an array of tpm_extend_digest structures to
tpm_pcr_extend()") modifies tpm_pcr_extend() to accept a digest for each
PCR bank. After modification, tpm_pcr_extend() expects that digests are
passed in the same order as the algorithms set in chip->allocated_banks.

This patch fixes two issues introduced in the last iterations of the patch
set: missing initialization of the TPM algorithm ID in the tpm_digest
structures passed to tpm_pcr_extend() by the trusted key module, and
unreleased locks in the TPM driver due to returning from tpm_pcr_extend()
without calling tpm_put_ops().

Cc: stable@vger.kernel.org
Fixes: 0b6cf6b97b7e ("tpm: pass an array of tpm_extend_digest structures to tpm_pcr_extend()")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm-interface.c |   14 +++++++++-----
 security/keys/trusted.c          |    5 +++++
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -320,18 +320,22 @@ int tpm_pcr_extend(struct tpm_chip *chip
 	if (!chip)
 		return -ENODEV;
 
-	for (i = 0; i < chip->nr_allocated_banks; i++)
-		if (digests[i].alg_id != chip->allocated_banks[i].alg_id)
-			return -EINVAL;
+	for (i = 0; i < chip->nr_allocated_banks; i++) {
+		if (digests[i].alg_id != chip->allocated_banks[i].alg_id) {
+			rc = EINVAL;
+			goto out;
+		}
+	}
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		rc = tpm2_pcr_extend(chip, pcr_idx, digests);
-		tpm_put_ops(chip);
-		return rc;
+		goto out;
 	}
 
 	rc = tpm1_pcr_extend(chip, pcr_idx, digests[0].digest,
 			     "attempting extend a PCR value");
+
+out:
 	tpm_put_ops(chip);
 	return rc;
 }
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1228,11 +1228,16 @@ hashalg_fail:
 
 static int __init init_digests(void)
 {
+	int i;
+
 	digests = kcalloc(chip->nr_allocated_banks, sizeof(*digests),
 			  GFP_KERNEL);
 	if (!digests)
 		return -ENOMEM;
 
+	for (i = 0; i < chip->nr_allocated_banks; i++)
+		digests[i].alg_id = chip->allocated_banks[i].alg_id;
+
 	return 0;
 }
 


