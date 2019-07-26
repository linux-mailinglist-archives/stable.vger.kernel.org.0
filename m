Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6CF76A21
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387780AbfGZNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387768AbfGZNlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF37322BF5;
        Fri, 26 Jul 2019 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148507;
        bh=+Q4MS4mg58LWCTZtdP/Zw3UzF8hkUtxnW9TUrrHA0ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONs/B1i/1JR9fdyOlg8cBEqfh3/WH8FyaycC79zdG6603vbr5rd49U1Od9b83LSZS
         7T66iQbAjABKmhiWftYs9mC1HWzs/rvdbzT6njrp6VAso+zABUxB5/trjrnxzda4UZ
         2I7NEDD4yltZAJosxJnrcOu6Vd+spANF6DgRX/4Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Rientjes <rientjes@google.com>, Cfir Cohen <cfir@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 73/85] crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL
Date:   Fri, 26 Jul 2019 09:39:23 -0400
Message-Id: <20190726133936.11177-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Rientjes <rientjes@google.com>

[ Upstream commit 83bf42510d7f7e1daa692c096e8e9919334d7b57 ]

SEV_VERSION_GREATER_OR_EQUAL() will fail if upgrading from 2.2 to 3.1, for
example, because the minor version is not equal to or greater than the
major.

Fix this and move to a static inline function for appropriate type
checking.

Fixes: edd303ff0e9e ("crypto: ccp - Add DOWNLOAD_FIRMWARE SEV command")
Reported-by: Cfir Cohen <cfir@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/psp-dev.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index de5a8ca70d3d..6b17d179ef8a 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -24,10 +24,6 @@
 #include "sp-dev.h"
 #include "psp-dev.h"
 
-#define SEV_VERSION_GREATER_OR_EQUAL(_maj, _min)	\
-		((psp_master->api_major) >= _maj &&	\
-		 (psp_master->api_minor) >= _min)
-
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
 #define SEV_FW_NAME_SIZE	64
@@ -47,6 +43,15 @@ MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during
 static bool psp_dead;
 static int psp_timeout;
 
+static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
+{
+	if (psp_master->api_major > maj)
+		return true;
+	if (psp_master->api_major == maj && psp_master->api_minor >= min)
+		return true;
+	return false;
+}
+
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 {
 	struct device *dev = sp->dev;
@@ -588,7 +593,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	int ret;
 
 	/* SEV GET_ID is available from SEV API v0.16 and up */
-	if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
+	if (!sev_version_greater_or_equal(0, 16))
 		return -ENOTSUPP;
 
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
@@ -651,7 +656,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
 	int ret;
 
 	/* SEV GET_ID available from SEV API v0.16 and up */
-	if (!SEV_VERSION_GREATER_OR_EQUAL(0, 16))
+	if (!sev_version_greater_or_equal(0, 16))
 		return -ENOTSUPP;
 
 	/* SEV FW expects the buffer it fills with the ID to be
@@ -1053,7 +1058,7 @@ void psp_pci_init(void)
 		psp_master->sev_state = SEV_STATE_UNINIT;
 	}
 
-	if (SEV_VERSION_GREATER_OR_EQUAL(0, 15) &&
+	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(psp_master->dev) == 0)
 		sev_get_api_version();
 
-- 
2.20.1

