Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993EC29B6EB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368780AbgJ0P1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797258AbgJ0PWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD32C2064B;
        Tue, 27 Oct 2020 15:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812152;
        bh=biabbz6vVQve8wqA4V1ide8c+rFTbecPsv24HC4oUuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOrexxz97TgN1hM9aAmJ76qRNimA80LhIANXBk5MHq/sxHa7joEul2QAwUxL9YJ9h
         9LNYfFdneo/r2rnOlOfb7DHfgEjj+uU9IgjAVTwJEftIuZAhNjc49RAa7ZQYXayUnJ
         WPDXJ7aAPpGjv16uEk+BG9B3/KrHUJA4q7xTon+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.9 079/757] ima: Dont ignore errors from crypto_shash_update()
Date:   Tue, 27 Oct 2020 14:45:29 +0100
Message-Id: <20201027135454.258996188@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
@@ -829,6 +829,8 @@ static int ima_calc_boot_aggregate_tfm(c
 		/* now accumulate with current aggregate */
 		rc = crypto_shash_update(shash, d.digest,
 					 crypto_shash_digestsize(tfm));
+		if (rc != 0)
+			return rc;
 	}
 	/*
 	 * Extend cumulative digest over TPM registers 8-9, which contain


