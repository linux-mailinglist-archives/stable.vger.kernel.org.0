Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1249C40E22C
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241777AbhIPQfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241480AbhIPQdM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:33:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10D59613BD;
        Thu, 16 Sep 2021 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809213;
        bh=y5zwYu7lDFof+ZiAvj92o91Nt3I/SpT/ccGWX4iNuB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rrh+YG4U1VHnRd01MrbZqYdtD2vm9R7+D4jpo5Eh66HeNHBhpJNg/drf/dG1QYQxm
         LvlXwzt1v98mtwGRpJmdYPeweT2Wy2gvBBFIobLt4Uos56n5NgsGrGTxOvK1fbOnvi
         vfNz6daNuqIojQxb5JjwGCX0DqsyriYHZxnAdPy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Nussbaum <lucas.nussbaum@inria.fr>,
        stable@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@gmail.com>
Subject: [PATCH 5.13 041/380] crypto: ccp - shutdown SEV firmware on kexec
Date:   Thu, 16 Sep 2021 17:56:38 +0200
Message-Id: <20210916155805.367705815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

commit 5441a07a127f106c9936e4f9fa1a8a93e3f31828 upstream.

The commit 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the
PSP driver") added support to allocate Trusted Memory Region (TMR)
used during the SEV-ES firmware initialization. The TMR gets locked
during the firmware initialization and unlocked during the shutdown.
While the TMR is locked, access to it is disallowed.

Currently, the CCP driver does not shutdown the firmware during the
kexec reboot, leaving the TMR memory locked.

Register a callback to shutdown the SEV firmware on the kexec boot.

Fixes: 97f9ac3db6612 ("crypto: ccp - Add support for SEV-ES to the PSP driver")
Reported-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
Tested-by: Lucas Nussbaum <lucas.nussbaum@inria.fr>
Cc: <stable@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sev-dev.c |   49 ++++++++++++++++++++-----------------------
 drivers/crypto/ccp/sp-pci.c  |   12 ++++++++++
 2 files changed, 35 insertions(+), 26 deletions(-)

--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -300,6 +300,9 @@ static int __sev_platform_shutdown_locke
 	struct sev_device *sev = psp_master->sev_data;
 	int ret;
 
+	if (sev->state == SEV_STATE_UNINIT)
+		return 0;
+
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
 	if (ret)
 		return ret;
@@ -1019,6 +1022,20 @@ e_err:
 	return ret;
 }
 
+static void sev_firmware_shutdown(struct sev_device *sev)
+{
+	sev_platform_shutdown(NULL);
+
+	if (sev_es_tmr) {
+		/* The TMR area was encrypted, flush it from the cache */
+		wbinvd_on_all_cpus();
+
+		free_pages((unsigned long)sev_es_tmr,
+			   get_order(SEV_ES_TMR_SIZE));
+		sev_es_tmr = NULL;
+	}
+}
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
@@ -1026,6 +1043,8 @@ void sev_dev_destroy(struct psp_device *
 	if (!sev)
 		return;
 
+	sev_firmware_shutdown(sev);
+
 	if (sev->misc)
 		kref_put(&misc_dev->refcount, sev_exit);
 
@@ -1056,21 +1075,6 @@ void sev_pci_init(void)
 	if (sev_get_api_version())
 		goto err;
 
-	/*
-	 * If platform is not in UNINIT state then firmware upgrade and/or
-	 * platform INIT command will fail. These command require UNINIT state.
-	 *
-	 * In a normal boot we should never run into case where the firmware
-	 * is not in UNINIT state on boot. But in case of kexec boot, a reboot
-	 * may not go through a typical shutdown sequence and may leave the
-	 * firmware in INIT or WORKING state.
-	 */
-
-	if (sev->state != SEV_STATE_UNINIT) {
-		sev_platform_shutdown(NULL);
-		sev->state = SEV_STATE_UNINIT;
-	}
-
 	if (sev_version_greater_or_equal(0, 15) &&
 	    sev_update_firmware(sev->dev) == 0)
 		sev_get_api_version();
@@ -1115,17 +1119,10 @@ err:
 
 void sev_pci_exit(void)
 {
-	if (!psp_master->sev_data)
-		return;
-
-	sev_platform_shutdown(NULL);
+	struct sev_device *sev = psp_master->sev_data;
 
-	if (sev_es_tmr) {
-		/* The TMR area was encrypted, flush it from the cache */
-		wbinvd_on_all_cpus();
+	if (!sev)
+		return;
 
-		free_pages((unsigned long)sev_es_tmr,
-			   get_order(SEV_ES_TMR_SIZE));
-		sev_es_tmr = NULL;
-	}
+	sev_firmware_shutdown(sev);
 }
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -241,6 +241,17 @@ e_err:
 	return ret;
 }
 
+static void sp_pci_shutdown(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sp_device *sp = dev_get_drvdata(dev);
+
+	if (!sp)
+		return;
+
+	sp_destroy(sp);
+}
+
 static void sp_pci_remove(struct pci_dev *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -371,6 +382,7 @@ static struct pci_driver sp_pci_driver =
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
+	.shutdown = sp_pci_shutdown,
 	.driver.pm = &sp_pci_pm_ops,
 };
 


