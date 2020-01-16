Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF05313F905
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbgAPTWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730970AbgAPQx2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D09F2176D;
        Thu, 16 Jan 2020 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193608;
        bh=GzZVKs81gxE1HKrzsUYG7XcO8p7ZAY/XBjGplBuf6U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc5xmr3JPIZGe+hQ0AYmRDikOU42o2AwLZwIDbu4/rcqORMvqNrS5RQ8IKA9nRxjQ
         LOLTRYiZUbIP2cnOblstTueKIMTPo1NhzBVgBdvTt7+8cNKHha4cj7kpjh9PVYBd0b
         X8wMBCgKXxql+sOtua0TaLI+P+wjYGTqh7BNJI0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Sasha Levin <sashal@kernel.org>, tee-dev@lists.linaro.org
Subject: [PATCH AUTOSEL 5.4 146/205] tee: optee: fix device enumeration error handling
Date:   Thu, 16 Jan 2020 11:42:01 -0500
Message-Id: <20200116164300.6705-146-sashal@kernel.org>
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

From: Jens Wiklander <jens.wiklander@linaro.org>

[ Upstream commit 03212e347f9443e524d6383c6806ac08295c1fb0 ]

Prior to this patch in optee_probe() when optee_enumerate_devices() was
called the struct optee was fully initialized. If
optee_enumerate_devices() returns an error optee_probe() is supposed to
clean up and free the struct optee completely, but will at this late
stage need to call optee_remove() instead. This isn't done and thus
freeing the struct optee prematurely.

With this patch the call to optee_enumerate_devices() is done after
optee_probe() has returned successfully and in case
optee_enumerate_devices() fails everything is cleaned up with a call to
optee_remove().

Fixes: c3fa24af9244 ("tee: optee: add TEE bus device enumeration support")
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/core.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
index 1854a3db7345..b830e0a87fba 100644
--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -643,11 +643,6 @@ static struct optee *optee_probe(struct device_node *np)
 	if (optee->sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
 		pr_info("dynamic shared memory is enabled\n");
 
-	rc = optee_enumerate_devices();
-	if (rc)
-		goto err;
-
-	pr_info("initialized driver\n");
 	return optee;
 err:
 	if (optee) {
@@ -702,9 +697,10 @@ static struct optee *optee_svc;
 
 static int __init optee_driver_init(void)
 {
-	struct device_node *fw_np;
-	struct device_node *np;
-	struct optee *optee;
+	struct device_node *fw_np = NULL;
+	struct device_node *np = NULL;
+	struct optee *optee = NULL;
+	int rc = 0;
 
 	/* Node is supposed to be below /firmware */
 	fw_np = of_find_node_by_name(NULL, "firmware");
@@ -723,6 +719,14 @@ static int __init optee_driver_init(void)
 	if (IS_ERR(optee))
 		return PTR_ERR(optee);
 
+	rc = optee_enumerate_devices();
+	if (rc) {
+		optee_remove(optee);
+		return rc;
+	}
+
+	pr_info("initialized driver\n");
+
 	optee_svc = optee;
 
 	return 0;
-- 
2.20.1

