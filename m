Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55A5A6E93
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbfICQ1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730757AbfICQ1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FD523431;
        Tue,  3 Sep 2019 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528019;
        bh=9MJwHwx/i5eFDX9Gr3lWzuowR0jSdDPVE76DZgdiHJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLZDi4Fsps4vnlzBTIcaZ+mE4YqYj/fDJ8R+FxT/CK01LcEwQ98HBbACtiwhTVWKa
         ceVGVNXQXPMIKQToDl3y7IZbU9xaDa57VIVDxlRnInjAEnRNJJmPP52lO6oicPaLj/
         gPojHzBURCdlrHRsUCdSapiyFnHVBwf8gcN5PCcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 056/167] crypto: ccree - fix resume race condition on init
Date:   Tue,  3 Sep 2019 12:23:28 -0400
Message-Id: <20190903162519.7136-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 1358c13a48c43f5e4de0c1835291837a27b9720c ]

We were enabling autosuspend, which is using data set by the
hash module, prior to the hash module being inited, casuing
a crash on resume as part of the startup sequence if the race
was lost.

This was never a real problem because the PM infra was using low
res timers so we were always winning the race, until commit 8234f6734c5d
("PM-runtime: Switch autosuspend over to using hrtimers") changed that :-)

Fix this by seperating the PM setup and enablement and doing the
latter only at the end of the init sequence.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: stable@kernel.org # v4.20
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c |  7 ++++---
 drivers/crypto/ccree/cc_pm.c     | 13 ++++++-------
 drivers/crypto/ccree/cc_pm.h     |  3 +++
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 1ff229c2aeab1..186a2536fb8b9 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -364,7 +364,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	rc = cc_ivgen_init(new_drvdata);
 	if (rc) {
 		dev_err(dev, "cc_ivgen_init failed\n");
-		goto post_power_mgr_err;
+		goto post_buf_mgr_err;
 	}
 
 	/* Allocate crypto algs */
@@ -387,6 +387,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_hash_err;
 	}
 
+	/* All set, we can allow autosuspend */
+	cc_pm_go(new_drvdata);
+
 	/* If we got here and FIPS mode is enabled
 	 * it means all FIPS test passed, so let TEE
 	 * know we're good.
@@ -401,8 +404,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_cipher_free(new_drvdata);
 post_ivgen_err:
 	cc_ivgen_fini(new_drvdata);
-post_power_mgr_err:
-	cc_pm_fini(new_drvdata);
 post_buf_mgr_err:
 	 cc_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 79fc0a37ba6e4..638082dff183a 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -103,20 +103,19 @@ int cc_pm_put_suspend(struct device *dev)
 
 int cc_pm_init(struct cc_drvdata *drvdata)
 {
-	int rc = 0;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* must be before the enabling to avoid resdundent suspending */
 	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
 	/* activate the PM module */
-	rc = pm_runtime_set_active(dev);
-	if (rc)
-		return rc;
-	/* enable the PM module*/
-	pm_runtime_enable(dev);
+	return pm_runtime_set_active(dev);
+}
 
-	return rc;
+/* enable the PM module*/
+void cc_pm_go(struct cc_drvdata *drvdata)
+{
+	pm_runtime_enable(drvdata_to_dev(drvdata));
 }
 
 void cc_pm_fini(struct cc_drvdata *drvdata)
diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index 020a5403c58ba..f626243570209 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -16,6 +16,7 @@
 extern const struct dev_pm_ops ccree_pm;
 
 int cc_pm_init(struct cc_drvdata *drvdata);
+void cc_pm_go(struct cc_drvdata *drvdata);
 void cc_pm_fini(struct cc_drvdata *drvdata);
 int cc_pm_suspend(struct device *dev);
 int cc_pm_resume(struct device *dev);
@@ -29,6 +30,8 @@ static inline int cc_pm_init(struct cc_drvdata *drvdata)
 	return 0;
 }
 
+static void cc_pm_go(struct cc_drvdata *drvdata) {}
+
 static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
 
 static inline int cc_pm_suspend(struct device *dev)
-- 
2.20.1

