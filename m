Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7696813F92C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729849AbgAPQxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:53:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729610AbgAPQxM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7E9E205F4;
        Thu, 16 Jan 2020 16:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193591;
        bh=z7UtFpjytQG8OQ4ULKWVO8VA52K/0wUewiNVs40n9VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ9oDdJkDvbAsROK7Llo4chxJhLZ1iDOMa9c6S5Oz3xiW+kMQqWZmQYHdl29FzCNl
         XaUOOEpSOLYgs0M3Bbhk6wR+Pgl9pCH3oTn0dLEVxQBdkhF4YMc24s1wC+LPVcamJN
         zquePOvPVcpl1P67DaEmYF4ebYP0ZPbKX8n6rYsc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 131/205] s390/pkey: fix memory leak within _copy_apqns_from_user()
Date:   Thu, 16 Jan 2020 11:41:46 -0500
Message-Id: <20200116164300.6705-131-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[ Upstream commit f9cac4fd8878929c6ebff0bd272317905d77c38a ]

Fixes: f2bbc96e7cfad ("s390/pkey: add CCA AES cipher key support")
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/pkey_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/pkey_api.c b/drivers/s390/crypto/pkey_api.c
index 9de3d46b3253..e17fac20127e 100644
--- a/drivers/s390/crypto/pkey_api.c
+++ b/drivers/s390/crypto/pkey_api.c
@@ -740,8 +740,10 @@ static void *_copy_apqns_from_user(void __user *uapqns, size_t nr_apqns)
 		kapqns = kmalloc(nbytes, GFP_KERNEL);
 		if (!kapqns)
 			return ERR_PTR(-ENOMEM);
-		if (copy_from_user(kapqns, uapqns, nbytes))
+		if (copy_from_user(kapqns, uapqns, nbytes)) {
+			kfree(kapqns);
 			return ERR_PTR(-EFAULT);
+		}
 	}
 
 	return kapqns;
-- 
2.20.1

