Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E42ABB48
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbgKIN0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732105AbgKINPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:15:36 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 505612076E;
        Mon,  9 Nov 2020 13:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927735;
        bh=u1RFd9eUWYMDgsfHmJHaW91FwZzOe0yAYKR+coiZDfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyTf98hM3fpl5fVFYFkjKSU3ep4dgF/LNm8qrNmodqTxaVg1RipHhxHttN/Zu3Ywd
         RrNkE34w8FqqzVQTbcimt7R2gQO1nc7DxL0CFKnD8gJ7be5SgnCRaDckQyP5dI2OX1
         ROQPhOAfTZxgAWfztRha19vQBjRBnQeLApWY6Mhs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Egorenkov <Alexander.Egorenkov@ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 66/85] s390/pkey: fix paes selftest failure with paes and pkey static build
Date:   Mon,  9 Nov 2020 13:56:03 +0100
Message-Id: <20201109125025.741176408@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit 5b35047eb467c8cdd38a31beb9ac109221777843 upstream.

When both the paes and the pkey kernel module are statically build
into the kernel, the paes cipher selftests run before the pkey
kernel module is initialized. So a static variable set in the pkey
init function and used in the pkey_clr2protkey function is not
initialized when the paes cipher's selftests request to call pckmo for
transforming a clear key value into a protected key.

This patch moves the initial setup of the static variable into
the function pck_clr2protkey. So it's possible, to use the function
for transforming a clear to a protected key even before the pkey
init function has been called and the paes selftests may run
successful.

Reported-by: Alexander Egorenkov <Alexander.Egorenkov@ibm.com>
Cc: <stable@vger.kernel.org> # 4.20
Fixes: f822ad2c2c03 ("s390/pkey: move pckmo subfunction available checks away from module init")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/pkey_api.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -33,9 +33,6 @@ MODULE_DESCRIPTION("s390 protected key i
 #define KEYBLOBBUFSIZE 8192  /* key buffer size used for internal processing */
 #define MAXAPQNSINLIST 64    /* max 64 apqns within a apqn list */
 
-/* mask of available pckmo subfunctions, fetched once at module init */
-static cpacf_mask_t pckmo_functions;
-
 /*
  * debug feature data and functions
  */
@@ -78,6 +75,9 @@ static int pkey_clr2protkey(u32 keytype,
 			    const struct pkey_clrkey *clrkey,
 			    struct pkey_protkey *protkey)
 {
+	/* mask of available pckmo subfunctions */
+	static cpacf_mask_t pckmo_functions;
+
 	long fc;
 	int keysize;
 	u8 paramblock[64];
@@ -101,11 +101,13 @@ static int pkey_clr2protkey(u32 keytype,
 		return -EINVAL;
 	}
 
-	/*
-	 * Check if the needed pckmo subfunction is available.
-	 * These subfunctions can be enabled/disabled by customers
-	 * in the LPAR profile or may even change on the fly.
-	 */
+	/* Did we already check for PCKMO ? */
+	if (!pckmo_functions.bytes[0]) {
+		/* no, so check now */
+		if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
+			return -ENODEV;
+	}
+	/* check for the pckmo subfunction we need now */
 	if (!cpacf_test_func(&pckmo_functions, fc)) {
 		DEBUG_ERR("%s pckmo functions not available\n", __func__);
 		return -ENODEV;
@@ -1504,7 +1506,7 @@ static struct miscdevice pkey_dev = {
  */
 static int __init pkey_init(void)
 {
-	cpacf_mask_t kmc_functions;
+	cpacf_mask_t func_mask;
 
 	/*
 	 * The pckmo instruction should be available - even if we don't
@@ -1512,15 +1514,15 @@ static int __init pkey_init(void)
 	 * is also the minimum level for the kmc instructions which
 	 * are able to work with protected keys.
 	 */
-	if (!cpacf_query(CPACF_PCKMO, &pckmo_functions))
+	if (!cpacf_query(CPACF_PCKMO, &func_mask))
 		return -ENODEV;
 
 	/* check for kmc instructions available */
-	if (!cpacf_query(CPACF_KMC, &kmc_functions))
+	if (!cpacf_query(CPACF_KMC, &func_mask))
 		return -ENODEV;
-	if (!cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_128) ||
-	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_192) ||
-	    !cpacf_test_func(&kmc_functions, CPACF_KMC_PAES_256))
+	if (!cpacf_test_func(&func_mask, CPACF_KMC_PAES_128) ||
+	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_192) ||
+	    !cpacf_test_func(&func_mask, CPACF_KMC_PAES_256))
 		return -ENODEV;
 
 	pkey_debug_init();


