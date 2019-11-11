Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65559F7D7B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730608AbfKKS5Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:57:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730801AbfKKS5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:57:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 784FD2173B;
        Mon, 11 Nov 2019 18:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498632;
        bh=2yS4gRpxf/2gEhhzNNa75eK9CfmmxLHaADM6e7yB17k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYrDD4QgUwA3u4i6NSLesnurV/ewjoQxwGSwzkd0wItKgBXdC7UrY6EEON3JaIjOj
         bGW5bEBceNqZ/VWryc4h14r9X/ParE6TBPSOYza9Rkvj35hdij7LqR5T2smAKn1zIl
         RPcEgok4L7UWGl7I9m2PEZ2s0zSdHPig7bWhUOyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 175/193] efi/tpm: Return -EINVAL when determining tpm final events log size fails
Date:   Mon, 11 Nov 2019 19:29:17 +0100
Message-Id: <20191111181514.033406325@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerry Snitselaar <jsnitsel@redhat.com>

[ Upstream commit 2bb6a81633cb47dcba4c9f75605cbe49e6b73d60 ]

Currently nothing checks the return value of efi_tpm_eventlog_init(),
but in case that changes in the future make sure an error is
returned when it fails to determine the tpm final events log
size.

Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Fixes: e658c82be556 ("efi/tpm: Only set 'efi_tpm_final_log_size' after ...")
Link: https://lkml.kernel.org/r/20191029173755.27149-3-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/tpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index ebd7977653a8e..31f9f0e369b97 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -88,6 +88,7 @@ int __init efi_tpm_eventlog_init(void)
 
 	if (tbl_size < 0) {
 		pr_err(FW_BUG "Failed to parse event in TPM Final Events Log\n");
+		ret = -EINVAL;
 		goto out_calc;
 	}
 
-- 
2.20.1



