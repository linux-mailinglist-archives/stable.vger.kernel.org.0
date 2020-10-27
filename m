Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA93529AF46
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755224AbgJ0OIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755218AbgJ0OIv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:08:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00157206D4;
        Tue, 27 Oct 2020 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807731;
        bh=1lrY8uaOKKFycekhhmbsNdRJz/wptNRp4W5l5mYz1EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaT0BrY+tMtFVznvELSew6xuaAwlLh4AWAG0kdHAEEwEGqztJnS7vdLLrLedNTjNp
         urZfLw4PFDfXRl/bJ8q76ng5EWROJNYLU9dGUvMkK8PDKdiW5Pmwzrt9PUoxAdvAWb
         41gR8dTmUFuQR5BS/VAmcMRtNSu8K96MfAXCfRGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.14 020/191] ima: Dont ignore errors from crypto_shash_update()
Date:   Tue, 27 Oct 2020 14:47:55 +0100
Message-Id: <20201027134910.692837942@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 60386b854008adc951c470067f90a2d85b5d520f upstream.

Errors returned by crypto_shash_update() are not checked in
ima_calc_boot_aggregate_tfm() and thus can be overwritten at the next
iteration of the loop. This patch adds a check after calling
crypto_shash_update() and returns immediately if the result is not zero.

Cc: stable@vger.kernel.org
Fixes: 3323eec921efd ("integrity: IMA as an integrity service provider")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_crypto.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -699,6 +699,8 @@ static int __init ima_calc_boot_aggregat
 		ima_pcrread(i, pcr_i);
 		/* now accumulate with current aggregate */
 		rc = crypto_shash_update(shash, pcr_i, TPM_DIGEST_SIZE);
+		if (rc != 0)
+			return rc;
 	}
 	if (!rc)
 		crypto_shash_final(shash, digest);


