Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81441171DEA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgB0ONC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:13:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbgB0OM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F10020578;
        Thu, 27 Feb 2020 14:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812777;
        bh=s9PRbJgZoRfil7RlXNlak23YZ7mHVGiUFrYZ5T47Uj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm266H4odsENRqXeYb9OMerYowz57EWRmKkM7c4zM3iVF8BboEElFK9XlmARYvUEC
         Kmdpz/iDOTJ8sbj636pJWaLiHW0qDiBOkzTG1ZXEomuRosVVdzCr7Fw1cQUjLW0skk
         LnyccmFV0Dur2I93Wglosgym0DzGTtjNRXYMqkIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Petr Vorel <pvorel@suse.cz>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.5 013/150] tpm: Initialize crypto_id of allocated_banks to HASH_ALGO__LAST
Date:   Thu, 27 Feb 2020 14:35:50 +0100
Message-Id: <20200227132234.635198004@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit dc10e4181c05a2315ddc375e963b7c763b5ee0df upstream.

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

Cc: stable@vger.kernel.org # 5.1.x
Fixes: 879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm2-cmd.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -525,6 +525,8 @@ static int tpm2_init_bank_info(struct tp
 		return 0;
 	}
 
+	bank->crypto_id = HASH_ALGO__LAST;
+
 	return tpm2_pcr_read(chip, 0, &digest, &bank->digest_size);
 }
 


