Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A678638FCC
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbfFGPpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731223AbfFGPpY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62E532146E;
        Fri,  7 Jun 2019 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922323;
        bh=4CJuhXHiVHLwn//QvJbFWxdV9qoHj3F4tHEXDE50kSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccxbfmIOe1W/OkVFVgd6dd5owZrKF8MDbnhpMzsxSgdwQxbJ9DNAtzpF1BnUxvScY
         eicaNT9g7x0kaxxITK4GdBLVSCStA2JJsCuUb43nLjpHGuOgxO+uftd2dF8QhJo+HY
         mztHm0bSQV9Gx5uFF1/Ci6Zj+3T4ChSSHMOXS1/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.19 47/73] evm: check hash algorithm passed to init_desc()
Date:   Fri,  7 Jun 2019 17:39:34 +0200
Message-Id: <20190607153854.411997182@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 221be106d75c1b511973301542f47d6000d0b63e upstream.

This patch prevents memory access beyond the evm_tfm array by checking the
validity of the index (hash algorithm) passed to init_desc(). The hash
algorithm can be arbitrarily set if the security.ima xattr type is not
EVM_XATTR_HMAC.

Fixes: 5feeb61183dde ("evm: Allow non-SHA1 digital signatures")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/evm/evm_crypto.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -89,6 +89,9 @@ static struct shash_desc *init_desc(char
 		tfm = &hmac_tfm;
 		algo = evm_hmac;
 	} else {
+		if (hash_algo >= HASH_ALGO__LAST)
+			return ERR_PTR(-EINVAL);
+
 		tfm = &evm_tfm[hash_algo];
 		algo = hash_algo_name[hash_algo];
 	}


