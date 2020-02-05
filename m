Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF37115292F
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 11:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgBEKei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 05:34:38 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2366 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727170AbgBEKei (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 05:34:38 -0500
Received: from lhreml702-cah.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 58F93441F3FBC2CB07D9;
        Wed,  5 Feb 2020 10:34:37 +0000 (GMT)
Received: from roberto-HP-EliteDesk-800-G2-DM-65W.huawei.com (10.204.65.160)
 by smtpsuk.huawei.com (10.201.108.43) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 5 Feb 2020 10:34:29 +0000
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <James.Bottomley@HansenPartnership.com>,
        <jarkko.sakkinen@linux.intel.com>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 1/8] tpm: Initialize crypto_id of allocated_banks to HASH_ALGO__LAST
Date:   Wed, 5 Feb 2020 11:33:10 +0100
Message-ID: <20200205103317.29356-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200205103317.29356-1-roberto.sassu@huawei.com>
References: <20200205103317.29356-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.204.65.160]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

chip->allocated_banks, an array of tpm_bank_info structures, contains the
list of TPM algorithm IDs of allocated PCR banks. It also contains the
corresponding ID of the crypto subsystem, so that users of the TPM driver
can calculate a digest for a PCR extend operation.

However, if there is no mapping between TPM algorithm ID and crypto ID, the
crypto_id field of tpm_bank_info remains set to zero (the array is
allocated and initialized with kcalloc() in tpm2_get_pcr_allocation()).
Zero should not be used as value for unknown mappings, as it is a valid
crypto ID (HASH_ALGO_MD4).

Thus, initialize crypto_id to HASH_ALGO__LAST.

Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Cc: stable@vger.kernel.org
---
 drivers/char/tpm/tpm2-cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 13696deceae8..760329598b99 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -525,6 +525,8 @@ static int tpm2_init_bank_info(struct tpm_chip *chip, u32 bank_index)
 		return 0;
 	}
 
+	bank->crypto_id = HASH_ALGO__LAST;
+
 	return tpm2_pcr_read(chip, 0, &digest, &bank->digest_size);
 }
 
-- 
2.17.1

