Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086F229C730
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1814637AbgJ0S2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504071AbgJ0N5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:57:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F4A9221F8;
        Tue, 27 Oct 2020 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807032;
        bh=jgDb0BXKtPATmNWHW5JCRJKV8iyX9vyYTAaYGFFpHyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WuZcgpD1McQsYvF+N3ZWl+GM2nhMxg75yCW11kXzsmXoGrzBRoYN1vw4eqKGv+3tl
         6Zb/SRIb8619DaZ1TFLH6VqkgoQHzYUDP7CgvZuRFvNRCkfmQDeg0Av6cwNUzqppb5
         G/VRIQ/fDX8tQntzdYmtA3SnZq+JeSju1dSIdux0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.4 018/112] ima: Dont ignore errors from crypto_shash_update()
Date:   Tue, 27 Oct 2020 14:48:48 +0100
Message-Id: <20201027134901.431442586@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
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
@@ -555,6 +555,8 @@ static int __init ima_calc_boot_aggregat
 		ima_pcrread(i, pcr_i);
 		/* now accumulate with current aggregate */
 		rc = crypto_shash_update(shash, pcr_i, TPM_DIGEST_SIZE);
+		if (rc != 0)
+			return rc;
 	}
 	if (!rc)
 		crypto_shash_final(shash, digest);


