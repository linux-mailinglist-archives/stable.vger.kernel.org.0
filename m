Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D551157BF9
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgBJNdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727977AbgBJMfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:32 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3D482085B;
        Mon, 10 Feb 2020 12:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338131;
        bh=SDRFbry5D+++ayj1CQ2pqggCONKq1POMX3F8jvDEQ6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnjmyay3odFzsCWrD445Baaca8FgrvS1KW00GN4dA9Vu/Pa006LfMLxZ0Irb51m0z
         bibA9VvZvMwkRun1PB6hyY+qgTtLCmN8fHixvS+SiEzagV+NkB4M/OlQDYEe1OGTiq
         uhQ/F1leBK8D06+jABBEaKkFnnTplgJGLJtVj8OA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, stable@kernel.org
Subject: [PATCH 4.19 076/195] crypto: ccree - fix PM race condition
Date:   Mon, 10 Feb 2020 04:32:14 -0800
Message-Id: <20200210122313.114061771@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

commit 15fd2566bf54ee4d4781d8f170acfc9472a1541f upstream.

The PM code was racy, possibly causing the driver to submit
requests to a powered down device. Fix the race and while
at it simplify the PM code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
Cc: stable@kernel.org # v4.20
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/ccree/cc_driver.h      |    1 
 drivers/crypto/ccree/cc_pm.c          |   28 ++++---------------
 drivers/crypto/ccree/cc_request_mgr.c |   50 ----------------------------------
 drivers/crypto/ccree/cc_request_mgr.h |    8 -----
 4 files changed, 7 insertions(+), 80 deletions(-)

--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -131,6 +131,7 @@ struct cc_drvdata {
 	u32 axim_mon_offset;
 	u32 sig_offset;
 	u32 ver_offset;
+	bool pm_on;
 };
 
 struct cc_crypto_alg {
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -23,14 +23,8 @@ const struct dev_pm_ops ccree_pm = {
 int cc_pm_suspend(struct device *dev)
 {
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
-	rc = cc_suspend_req_queue(drvdata);
-	if (rc) {
-		dev_err(dev, "cc_suspend_req_queue (%x)\n", rc);
-		return rc;
-	}
 	fini_cc_regs(drvdata);
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	cc_clk_off(drvdata);
@@ -59,13 +53,6 @@ int cc_pm_resume(struct device *dev)
 	/* check if tee fips error occurred during power down */
 	cc_tee_handle_fips_error(drvdata);
 
-	rc = cc_resume_req_queue(drvdata);
-	if (rc) {
-		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
-		return rc;
-	}
-
-	/* must be after the queue resuming as it uses the HW queue*/
 	cc_init_hash_sram(drvdata);
 
 	cc_init_iv_sram(drvdata);
@@ -77,10 +64,8 @@ int cc_pm_get(struct device *dev)
 	int rc = 0;
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
-	if (cc_req_queue_suspended(drvdata))
+	if (drvdata->pm_on)
 		rc = pm_runtime_get_sync(dev);
-	else
-		pm_runtime_get_noresume(dev);
 
 	return (rc == 1 ? 0 : rc);
 }
@@ -90,14 +75,11 @@ int cc_pm_put_suspend(struct device *dev
 	int rc = 0;
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
-	if (!cc_req_queue_suspended(drvdata)) {
+	if (drvdata->pm_on) {
 		pm_runtime_mark_last_busy(dev);
 		rc = pm_runtime_put_autosuspend(dev);
-	} else {
-		/* Something wrong happens*/
-		dev_err(dev, "request to suspend already suspended queue");
-		rc = -EBUSY;
 	}
+
 	return rc;
 }
 
@@ -108,7 +90,7 @@ int cc_pm_init(struct cc_drvdata *drvdat
 	/* must be before the enabling to avoid resdundent suspending */
 	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
-	/* activate the PM module */
+	/* set us as active - note we won't do PM ops until cc_pm_go()! */
 	return pm_runtime_set_active(dev);
 }
 
@@ -116,9 +98,11 @@ int cc_pm_init(struct cc_drvdata *drvdat
 void cc_pm_go(struct cc_drvdata *drvdata)
 {
 	pm_runtime_enable(drvdata_to_dev(drvdata));
+	drvdata->pm_on = true;
 }
 
 void cc_pm_fini(struct cc_drvdata *drvdata)
 {
 	pm_runtime_disable(drvdata_to_dev(drvdata));
+	drvdata->pm_on = false;
 }
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -41,7 +41,6 @@ struct cc_req_mgr_handle {
 #else
 	struct tasklet_struct comptask;
 #endif
-	bool is_runtime_suspended;
 };
 
 struct cc_bl_item {
@@ -661,52 +660,3 @@ static void comp_handler(unsigned long d
 
 	cc_proc_backlog(drvdata);
 }
-
-/*
- * resume the queue configuration - no need to take the lock as this happens
- * inside the spin lock protection
- */
-#if defined(CONFIG_PM)
-int cc_resume_req_queue(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-		drvdata->request_mgr_handle;
-
-	spin_lock_bh(&request_mgr_handle->hw_lock);
-	request_mgr_handle->is_runtime_suspended = false;
-	spin_unlock_bh(&request_mgr_handle->hw_lock);
-
-	return 0;
-}
-
-/*
- * suspend the queue configuration. Since it is used for the runtime suspend
- * only verify that the queue can be suspended.
- */
-int cc_suspend_req_queue(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	/* lock the send_request */
-	spin_lock_bh(&request_mgr_handle->hw_lock);
-	if (request_mgr_handle->req_queue_head !=
-	    request_mgr_handle->req_queue_tail) {
-		spin_unlock_bh(&request_mgr_handle->hw_lock);
-		return -EBUSY;
-	}
-	request_mgr_handle->is_runtime_suspended = true;
-	spin_unlock_bh(&request_mgr_handle->hw_lock);
-
-	return 0;
-}
-
-bool cc_req_queue_suspended(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	return	request_mgr_handle->is_runtime_suspended;
-}
-
-#endif
--- a/drivers/crypto/ccree/cc_request_mgr.h
+++ b/drivers/crypto/ccree/cc_request_mgr.h
@@ -40,12 +40,4 @@ void complete_request(struct cc_drvdata
 
 void cc_req_mgr_fini(struct cc_drvdata *drvdata);
 
-#if defined(CONFIG_PM)
-int cc_resume_req_queue(struct cc_drvdata *drvdata);
-
-int cc_suspend_req_queue(struct cc_drvdata *drvdata);
-
-bool cc_req_queue_suspended(struct cc_drvdata *drvdata);
-#endif
-
 #endif /*__REQUEST_MGR_H__*/


