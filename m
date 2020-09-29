Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B4027CA1E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgI2Lgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729967AbgI2LgV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5917323DC4;
        Tue, 29 Sep 2020 11:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379074;
        bh=cMOMn+SFCJXlYxFMRSeaj8zBYzvgZpg3LElIdt4Okh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYlmy5W2VqyUhfJ1vQ2iemKXLqxQMgbUkxKbWc/iEiBHPtXKT0c6xJpAms6VQv/sy
         CQWtqD77au0faUGNItxQFYgK/5BDdiqwENZBAKuo2qIRKLRS4M3zfv+OJPGUPBREKY
         XV9Euguw/aVITfwGb5M5Dj6siQNTluhPzLRvvIpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 240/245] s390/zcrypt: Fix ZCRYPT_PERDEV_REQCNT ioctl
Date:   Tue, 29 Sep 2020 13:01:31 +0200
Message-Id: <20200929105958.675637750@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit f7e80983f0cf470bb82036e73bff4d5a7daf8fc2 upstream.

reqcnt is an u32 pointer but we do copy sizeof(reqcnt) which is the
size of the pointer. This means we only copy 8 byte. Let us copy
the full monty.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: af4a72276d49 ("s390/zcrypt: Support up to 256 crypto adapters.")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/crypto/zcrypt_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -915,7 +915,8 @@ static long zcrypt_unlocked_ioctl(struct
 		if (!reqcnt)
 			return -ENOMEM;
 		zcrypt_perdev_reqcnt(reqcnt, AP_DEVICES);
-		if (copy_to_user((int __user *) arg, reqcnt, sizeof(reqcnt)))
+		if (copy_to_user((int __user *) arg, reqcnt,
+				 sizeof(u32) * AP_DEVICES))
 			rc = -EFAULT;
 		kfree(reqcnt);
 		return rc;


