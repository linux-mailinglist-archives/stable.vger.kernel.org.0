Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87B037C445
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhELP3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234873AbhELPZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:25:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C722C61622;
        Wed, 12 May 2021 15:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832254;
        bh=x5LkwHZCSOj6v8hl+/4ZA7wohYZotNMR/r1Yl5sA1sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAfhSQQxzLRkw68yblVOT/ImuyXjsG/o3TKtaa2uPYyfjkiqZQaqYR7HVcbqK9OTu
         9a+VeVsKb1JWppB6QRBomk7jYIp+s4E/X3BjJzDqUYpQ4SC49UJ5NBu4lRZdrziGJr
         AfDedOY/FWW4GMFrBo5K0HR9PKwjyPLwLdvhMKxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elliot Berman <eberman@codeaurora.org>,
        Brian Masney <masneyb@onstation.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 204/530] firmware: qcom_scm: Reduce locking section for __get_convention()
Date:   Wed, 12 May 2021 16:45:14 +0200
Message-Id: <20210512144826.545867700@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit f6ea568f0ddcdfad52807110ed8983e610f0e03b ]

We shouldn't need to hold this spinlock here around the entire SCM call
into the firmware and back. Instead, we should be able to query the
firmware, potentially in parallel with other CPUs making the same
convention detection firmware call, and then grab the lock to update the
calling convention detected. The convention doesn't change at runtime so
calling into firmware more than once is possibly wasteful but simpler.
Besides, this is the slow path, not the fast path where we've already
detected the convention used.

More importantly, this allows us to add more logic here to workaround
the case where the firmware call to check for availability isn't
implemented in the firmware at all. In that case we can check the
firmware node compatible string and force a calling convention.

Note that we remove the 'has_queried' logic that is repeated twice. That
could lead to the calling convention being printed multiple times to the
kernel logs if the bool is true but __query_convention() is running on
multiple CPUs. We also shorten the time where the lock is held, but we
keep the lock held around the printk because it doesn't seem hugely
important to drop it for that.

Cc: Elliot Berman <eberman@codeaurora.org>
Cc: Brian Masney <masneyb@onstation.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Douglas Anderson <dianders@chromium.org>
Fixes: 9a434cee773a ("firmware: qcom_scm: Dynamically support SMCCC and legacy conventions")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210223214539.1336155-3-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm-smc.c | 12 ++++---
 drivers/firmware/qcom_scm.c     | 55 ++++++++++++++++-----------------
 drivers/firmware/qcom_scm.h     |  7 +++--
 3 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/firmware/qcom_scm-smc.c b/drivers/firmware/qcom_scm-smc.c
index 497c13ba98d6..d111833364ba 100644
--- a/drivers/firmware/qcom_scm-smc.c
+++ b/drivers/firmware/qcom_scm-smc.c
@@ -77,8 +77,10 @@ static void __scm_smc_do(const struct arm_smccc_args *smc,
 	}  while (res->a0 == QCOM_SCM_V2_EBUSY);
 }
 
-int scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
-		 struct qcom_scm_res *res, bool atomic)
+
+int __scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
+		   enum qcom_scm_convention qcom_convention,
+		   struct qcom_scm_res *res, bool atomic)
 {
 	int arglen = desc->arginfo & 0xf;
 	int i;
@@ -87,9 +89,8 @@ int scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
 	size_t alloc_len;
 	gfp_t flag = atomic ? GFP_ATOMIC : GFP_KERNEL;
 	u32 smccc_call_type = atomic ? ARM_SMCCC_FAST_CALL : ARM_SMCCC_STD_CALL;
-	u32 qcom_smccc_convention =
-			(qcom_scm_convention == SMC_CONVENTION_ARM_32) ?
-			ARM_SMCCC_SMC_32 : ARM_SMCCC_SMC_64;
+	u32 qcom_smccc_convention = (qcom_convention == SMC_CONVENTION_ARM_32) ?
+				    ARM_SMCCC_SMC_32 : ARM_SMCCC_SMC_64;
 	struct arm_smccc_res smc_res;
 	struct arm_smccc_args smc = {0};
 
@@ -148,4 +149,5 @@ int scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
 	}
 
 	return (long)smc_res.a0 ? qcom_scm_remap_error(smc_res.a0) : 0;
+
 }
diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 54ba2834e763..a455c22bcdbd 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -113,11 +113,10 @@ static void qcom_scm_clk_disable(void)
 	clk_disable_unprepare(__scm->bus_clk);
 }
 
-enum qcom_scm_convention qcom_scm_convention;
-static bool has_queried __read_mostly;
-static DEFINE_SPINLOCK(query_lock);
+enum qcom_scm_convention qcom_scm_convention = SMC_CONVENTION_UNKNOWN;
+static DEFINE_SPINLOCK(scm_query_lock);
 
-static void __query_convention(void)
+static enum qcom_scm_convention __get_convention(void)
 {
 	unsigned long flags;
 	struct qcom_scm_desc desc = {
@@ -130,36 +129,36 @@ static void __query_convention(void)
 		.owner = ARM_SMCCC_OWNER_SIP,
 	};
 	struct qcom_scm_res res;
+	enum qcom_scm_convention probed_convention;
 	int ret;
 
-	spin_lock_irqsave(&query_lock, flags);
-	if (has_queried)
-		goto out;
+	if (likely(qcom_scm_convention != SMC_CONVENTION_UNKNOWN))
+		return qcom_scm_convention;
 
-	qcom_scm_convention = SMC_CONVENTION_ARM_64;
-	// Device isn't required as there is only one argument - no device
-	// needed to dma_map_single to secure world
-	ret = scm_smc_call(NULL, &desc, &res, true);
+	/*
+	 * Device isn't required as there is only one argument - no device
+	 * needed to dma_map_single to secure world
+	 */
+	probed_convention = SMC_CONVENTION_ARM_64;
+	ret = __scm_smc_call(NULL, &desc, probed_convention, &res, true);
 	if (!ret && res.result[0] == 1)
-		goto out;
+		goto found;
 
-	qcom_scm_convention = SMC_CONVENTION_ARM_32;
-	ret = scm_smc_call(NULL, &desc, &res, true);
+	probed_convention = SMC_CONVENTION_ARM_32;
+	ret = __scm_smc_call(NULL, &desc, probed_convention, &res, true);
 	if (!ret && res.result[0] == 1)
-		goto out;
-
-	qcom_scm_convention = SMC_CONVENTION_LEGACY;
-out:
-	has_queried = true;
-	spin_unlock_irqrestore(&query_lock, flags);
-	pr_info("qcom_scm: convention: %s\n",
-		qcom_scm_convention_names[qcom_scm_convention]);
-}
+		goto found;
+
+	probed_convention = SMC_CONVENTION_LEGACY;
+found:
+	spin_lock_irqsave(&scm_query_lock, flags);
+	if (probed_convention != qcom_scm_convention) {
+		qcom_scm_convention = probed_convention;
+		pr_info("qcom_scm: convention: %s\n",
+			qcom_scm_convention_names[qcom_scm_convention]);
+	}
+	spin_unlock_irqrestore(&scm_query_lock, flags);
 
-static inline enum qcom_scm_convention __get_convention(void)
-{
-	if (unlikely(!has_queried))
-		__query_convention();
 	return qcom_scm_convention;
 }
 
@@ -1233,7 +1232,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 	__scm = scm;
 	__scm->dev = &pdev->dev;
 
-	__query_convention();
+	__get_convention();
 
 	/*
 	 * If requested enable "download mode", from this point on warmboot
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index 95cd1ac30ab0..632fe3142462 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -61,8 +61,11 @@ struct qcom_scm_res {
 };
 
 #define SCM_SMC_FNID(s, c)	((((s) & 0xFF) << 8) | ((c) & 0xFF))
-extern int scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
-			struct qcom_scm_res *res, bool atomic);
+extern int __scm_smc_call(struct device *dev, const struct qcom_scm_desc *desc,
+			  enum qcom_scm_convention qcom_convention,
+			  struct qcom_scm_res *res, bool atomic);
+#define scm_smc_call(dev, desc, res, atomic) \
+	__scm_smc_call((dev), (desc), qcom_scm_convention, (res), (atomic))
 
 #define SCM_LEGACY_FNID(s, c)	(((s) << 10) | ((c) & 0x3ff))
 extern int scm_legacy_call_atomic(struct device *dev,
-- 
2.30.2



