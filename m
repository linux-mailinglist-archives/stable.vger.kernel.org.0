Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9099B00
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388857AbfHVRIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388772AbfHVRIO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:14 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 292C523404;
        Thu, 22 Aug 2019 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493693;
        bh=E+G7d0QVYHqcRsB9iKm+JSwup6AH9Ae3hpxG49tVs2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Yh9ezz6MFE5yJpTHcynLxIx/DRNLub6zrBY1tdzaKK5J2A0tsF3WVjk6w2BkB6oX
         R9lEkmWeh+ywyqqrSCoZh8JL2E1dAA/aUT/js25uOr/mLsVSv6soDr7ZcGUcm8wRo5
         KeM+CVB6cfQSnRZw5qZW84Rst+EBvO/hYQCH6tYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roberto Sassu <roberto.sassu@huawei.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 001/135] KEYS: trusted: allow module init if TPM is inactive or deactivated
Date:   Thu, 22 Aug 2019 13:05:57 -0400
Message-Id: <20190822170811.13303-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 2d6c25215ab26bb009de3575faab7b685f138e92 upstream.

Commit c78719203fc6 ("KEYS: trusted: allow trusted.ko to initialize w/o a
TPM") allows the trusted module to be loaded even if a TPM is not found, to
avoid module dependency problems.

However, trusted module initialization can still fail if the TPM is
inactive or deactivated. tpm_get_random() returns an error.

This patch removes the call to tpm_get_random() and instead extends the PCR
specified by the user with zeros. The security of this alternative is
equivalent to the previous one, as either option prevents with a PCR update
unsealing and misuse of sealed data by a user space process.

Even if a PCR is extended with zeros, instead of random data, it is still
computationally infeasible to find a value as input for a new PCR extend
operation, to obtain again the PCR value that would allow unsealing.

Cc: stable@vger.kernel.org
Fixes: 240730437deb ("KEYS: trusted: explicitly use tpm_chip structure...")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/keys/trusted.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 9a94672e7adcc..ade6991310654 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1228,24 +1228,11 @@ static int __init trusted_shash_alloc(void)
 
 static int __init init_digests(void)
 {
-	u8 digest[TPM_MAX_DIGEST_SIZE];
-	int ret;
-	int i;
-
-	ret = tpm_get_random(chip, digest, TPM_MAX_DIGEST_SIZE);
-	if (ret < 0)
-		return ret;
-	if (ret < TPM_MAX_DIGEST_SIZE)
-		return -EFAULT;
-
 	digests = kcalloc(chip->nr_allocated_banks, sizeof(*digests),
 			  GFP_KERNEL);
 	if (!digests)
 		return -ENOMEM;
 
-	for (i = 0; i < chip->nr_allocated_banks; i++)
-		memcpy(digests[i].digest, digest, TPM_MAX_DIGEST_SIZE);
-
 	return 0;
 }
 
-- 
2.20.1

