Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CDF147B4C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgAXJmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:42:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732644AbgAXJmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:23 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D5D320718;
        Fri, 24 Jan 2020 09:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858943;
        bh=1Z30YvobrovymqmVeIeZ2ZcTosiixf4aUJ3Vw5PR/R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJr5ZxxWOXC/xl9tfW0mAr9QJhkVeLuE1cEPsIkhK2Af2XwJXdFOEx+JeT3WlkNuM
         +ObaBXRTgw/lpAHKMEO4JdLlwgQjy3HCo9b8I1ff96lQ+3Lsv8IUalwzKs8Z14+olz
         Z0MpmuFcCo2q+/CV5xbYQw9Ta74YW/sXG8jfKPqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/102] tee: optee: fix device enumeration error handling
Date:   Fri, 24 Jan 2020 10:31:27 +0100
Message-Id: <20200124092819.662526497@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1854a3db73457..b830e0a87fbac 100644
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



