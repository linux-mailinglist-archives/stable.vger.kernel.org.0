Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4382F5B1
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfE3Et0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728417AbfE3DLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:12 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D2D5244D2;
        Thu, 30 May 2019 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185872;
        bh=2r2AVMBcDo2NVf7ZljylpUx4Chpoy5HgvQ9SSUgJUCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMVk1343aHB/e9ZQIKPUr8FcnFnGj6uFvpTeaJHmJwMDm/lYNPD9gqabLNc004t9B
         HP0AxX/+46d8kFkdc0mHtIEM9Cw5nmroPvOG75tHYzzR+6BiihTqss86VCR0dRbjK2
         XrJQm2uEKBts1dxEAx+z0Pl1A6iT13A4hL5LbinM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 215/405] s390: zcrypt: initialize variables before_use
Date:   Wed, 29 May 2019 20:03:33 -0700
Message-Id: <20190530030551.968108708@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 913140e221567b3ecd21b4242257a7e3fa279026 ]

The 'func_code' variable gets printed in debug statements without
a prior initialization in multiple functions, as reported when building
with clang:

drivers/s390/crypto/zcrypt_api.c:659:6: warning: variable 'func_code' is used uninitialized whenever 'if' condition is true
      [-Wsometimes-uninitialized]
        if (mex->outputdatalength < mex->inputdatalength) {
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/s390/crypto/zcrypt_api.c:725:29: note: uninitialized use occurs here
        trace_s390_zcrypt_rep(mex, func_code, rc,
                                   ^~~~~~~~~
drivers/s390/crypto/zcrypt_api.c:659:2: note: remove the 'if' if its condition is always false
        if (mex->outputdatalength < mex->inputdatalength) {
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/s390/crypto/zcrypt_api.c:654:24: note: initialize the variable 'func_code' to silence this warning
        unsigned int func_code;
                              ^

Add initializations to all affected code paths to shut up the warning
and make the warning output consistent.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 689c2af7026a3..c31b2d31cd832 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -659,6 +659,7 @@ static long zcrypt_rsa_modexpo(struct ap_perms *perms,
 	trace_s390_zcrypt_req(mex, TP_ICARSAMODEXPO);
 
 	if (mex->outputdatalength < mex->inputdatalength) {
+		func_code = 0;
 		rc = -EINVAL;
 		goto out;
 	}
@@ -742,6 +743,7 @@ static long zcrypt_rsa_crt(struct ap_perms *perms,
 	trace_s390_zcrypt_req(crt, TP_ICARSACRT);
 
 	if (crt->outputdatalength < crt->inputdatalength) {
+		func_code = 0;
 		rc = -EINVAL;
 		goto out;
 	}
@@ -951,6 +953,7 @@ static long zcrypt_send_ep11_cprb(struct ap_perms *perms,
 
 		targets = kcalloc(target_num, sizeof(*targets), GFP_KERNEL);
 		if (!targets) {
+			func_code = 0;
 			rc = -ENOMEM;
 			goto out;
 		}
@@ -958,6 +961,7 @@ static long zcrypt_send_ep11_cprb(struct ap_perms *perms,
 		uptr = (struct ep11_target_dev __force __user *) xcrb->targets;
 		if (copy_from_user(targets, uptr,
 				   target_num * sizeof(*targets))) {
+			func_code = 0;
 			rc = -EFAULT;
 			goto out_free;
 		}
-- 
2.20.1



