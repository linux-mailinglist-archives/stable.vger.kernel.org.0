Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC050171E82
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387782AbgB0OHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:07:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388112AbgB0OHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:07:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6DBC2469F;
        Thu, 27 Feb 2020 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812456;
        bh=wg8/gne6dxpefqG07NpdOWoUXbrsKajZdCwFetq6xxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8zid6CVy/MHE0+UX4GwLMpp+VL5S0WhJk7rhaRPfWSfc4tmDNYevlN8jwbeHYbUv
         JOLMRI/THawNJ1EYfThiyqDeSuaFjnaDkZPDa5vjgTQ5sUHnXqxqfFb30+eFW0r+js
         3v9cEiQeq03bbBoPeqepWGSwmpzyigPL3O+weVFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Petr Vorel <pvorel@suse.cz>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 5.4 007/135] tpm: Initialize crypto_id of allocated_banks to HASH_ALGO__LAST
Date:   Thu, 27 Feb 2020 14:35:47 +0100
Message-Id: <20200227132230.091534974@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
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
@@ -831,6 +831,8 @@ static int tpm2_init_bank_info(struct tp
 		return 0;
 	}
 
+	bank->crypto_id = HASH_ALGO__LAST;
+
 	return tpm2_pcr_read(chip, 0, &digest, &bank->digest_size);
 }
 


