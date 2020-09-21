Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF558272E8D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIUQuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:50:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729983AbgIUQuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:50:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3FB5238D7;
        Mon, 21 Sep 2020 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600707016;
        bh=m1aOmsMaItO9yjnr5jAW7/k4QrlW3pciU/xLdgcq+Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqM7oCzabJ4GJ4trxAUlJYU18t8cF+3fo1Bn6/2hH8/6nq8pjwOl4XP052r+79IRo
         cKtyazX13ZcBIifsv/V39kHoNJcnYZQgidKb//QegczHkLGR5ALgLOneeTLXEavD5c
         Lo42j3N5Qk1JyInBRfWPloD/XlxwwRPao7okSYK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Ingo Franzki <ifranzki@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 65/72] s390/zcrypt: fix kmalloc 256k failure
Date:   Mon, 21 Sep 2020 18:31:44 +0200
Message-Id: <20200921163124.961788267@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harald Freudenberger <freude@linux.ibm.com>

commit b6186d7fb53349efd274263a45f0b08749ccaa2d upstream.

Tests showed that under stress conditions the kernel may
temporary fail to allocate 256k with kmalloc. However,
this fix reworks the related code in the cca_findcard2()
function to use kvmalloc instead.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/zcrypt_ccamisc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/s390/crypto/zcrypt_ccamisc.c
+++ b/drivers/s390/crypto/zcrypt_ccamisc.c
@@ -1684,9 +1684,9 @@ int cca_findcard2(u32 **apqns, u32 *nr_a
 	*nr_apqns = 0;
 
 	/* fetch status of all crypto cards */
-	device_status = kmalloc_array(MAX_ZDEV_ENTRIES_EXT,
-				      sizeof(struct zcrypt_device_status_ext),
-				      GFP_KERNEL);
+	device_status = kvmalloc_array(MAX_ZDEV_ENTRIES_EXT,
+				       sizeof(struct zcrypt_device_status_ext),
+				       GFP_KERNEL);
 	if (!device_status)
 		return -ENOMEM;
 	zcrypt_device_status_mask_ext(device_status);
@@ -1754,7 +1754,7 @@ int cca_findcard2(u32 **apqns, u32 *nr_a
 		verify = 0;
 	}
 
-	kfree(device_status);
+	kvfree(device_status);
 	return rc;
 }
 EXPORT_SYMBOL(cca_findcard2);


