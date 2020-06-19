Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A8B2017C6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403960AbgFSQnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388143AbgFSOne (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:43:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49DF720CC7;
        Fri, 19 Jun 2020 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577814;
        bh=dKI2bBLdOxhTvg24W0G8MlZlOLhMnxcDkqMRMjlOq/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loX73Dr5Lyc5nL6fAIKK/aOjdZ4qHbLOpE4LwpPHSvXpDndreTlmQPdCLVuMcpIHS
         bNYeQvuWss6bVth8H+uUK2IpRINCNMkxibuKSA3myPBw/QglZ0Xd/hfLtQ27bTBlaY
         hBgocONQfPPWGvYT+VZiyDOVvRHEQUdNAtOq9gxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.9 101/128] evm: Fix possible memory leak in evm_calc_hmac_or_hash()
Date:   Fri, 19 Jun 2020 16:33:15 +0200
Message-Id: <20200619141625.468965144@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 0c4395fb2aa77341269ea619c5419ea48171883f upstream.

Don't immediately return if the signature is portable and security.ima is
not present. Just set error so that memory allocated is freed before
returning from evm_calc_hmac_or_hash().

Fixes: 50b977481fce9 ("EVM: Add support for portable signature format")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/evm/evm_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -240,7 +240,7 @@ static int evm_calc_hmac_or_hash(struct
 
 	/* Portable EVM signatures must include an IMA hash */
 	if (type == EVM_XATTR_PORTABLE_DIGSIG && !ima_present)
-		return -EPERM;
+		error = -EPERM;
 out:
 	kfree(xattr_value);
 	kfree(desc);


