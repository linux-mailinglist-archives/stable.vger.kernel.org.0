Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002D22F308
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbfE3EZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729932AbfE3DOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:40 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A93124502;
        Thu, 30 May 2019 03:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186079;
        bh=P7R1x1pGi94AC5SEkeFz6aQimoGWCT8T1THq+81y3mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFXtL2GvJ+FRdmjDE8JlP1dNO5Bva3kP2kv0CWYO3ahq/oTp2PRyY8M5v2vBuu18h
         GWRLf/HJM/1ijeJ6+dQtlj+suz7KgiyV/kJD8NkiMtTuHhCdTZQAZ1EtQ9Dcp162qE
         QFLK5EEqat4XVsQ3fZTNsg6Is4wp1L0Go61aAZKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 198/346] s390: zcrypt: initialize variables before_use
Date:   Wed, 29 May 2019 20:04:31 -0700
Message-Id: <20190530030551.273654785@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index eb93c2d27d0ad..df1e847dd36e7 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -657,6 +657,7 @@ static long zcrypt_rsa_modexpo(struct ap_perms *perms,
 	trace_s390_zcrypt_req(mex, TP_ICARSAMODEXPO);
 
 	if (mex->outputdatalength < mex->inputdatalength) {
+		func_code = 0;
 		rc = -EINVAL;
 		goto out;
 	}
@@ -739,6 +740,7 @@ static long zcrypt_rsa_crt(struct ap_perms *perms,
 	trace_s390_zcrypt_req(crt, TP_ICARSACRT);
 
 	if (crt->outputdatalength < crt->inputdatalength) {
+		func_code = 0;
 		rc = -EINVAL;
 		goto out;
 	}
@@ -946,6 +948,7 @@ static long zcrypt_send_ep11_cprb(struct ap_perms *perms,
 
 		targets = kcalloc(target_num, sizeof(*targets), GFP_KERNEL);
 		if (!targets) {
+			func_code = 0;
 			rc = -ENOMEM;
 			goto out;
 		}
@@ -953,6 +956,7 @@ static long zcrypt_send_ep11_cprb(struct ap_perms *perms,
 		uptr = (struct ep11_target_dev __force __user *) xcrb->targets;
 		if (copy_from_user(targets, uptr,
 				   target_num * sizeof(*targets))) {
+			func_code = 0;
 			rc = -EFAULT;
 			goto out_free;
 		}
-- 
2.20.1



