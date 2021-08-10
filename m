Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9A73E8186
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhHJSAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhHJR6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BC9A60724;
        Tue, 10 Aug 2021 17:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617562;
        bh=jgEx8dShc2VzbMKEH74GN5kZSTKgwtV9KyXmvTd19Zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1PRs6k1oWxfi3RZ0nyYfs3WfX1fJxTB1H5uksevlvxUaHRTmiW6eMXeFb1MHudtf
         naPWQ/CntTPsknIiwpmTbW5QKioGv80RXe0iFNiEt5XQXqO+vbGyBfW8UcPwVHKiA7
         e0QjrJFNAxa2o86rpvqjmBn20jqHDDgi4LThsg8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Tyler Hicks <tyhicks@linux.microsoft.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [PATCH 5.13 114/175] optee: fix tee out of memory failure seen during kexec reboot
Date:   Tue, 10 Aug 2021 19:30:22 +0200
Message-Id: <20210810173004.706412835@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

commit f25889f93184db8b07a543cc2bbbb9a8fcaf4333 upstream.

The following out of memory errors are seen on kexec reboot
from the optee core.

[    0.368428] tee_bnxt_fw optee-clnt0: tee_shm_alloc failed
[    0.368461] tee_bnxt_fw: probe of optee-clnt0 failed with error -22

tee_shm_release() is not invoked on dma shm buffer.

Implement .shutdown() method to handle the release of the buffers
correctly.

More info:
https://github.com/OP-TEE/optee_os/issues/3637

Cc: stable@vger.kernel.org
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/optee/core.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/tee/optee/core.c
+++ b/drivers/tee/optee/core.c
@@ -574,6 +574,13 @@ static optee_invoke_fn *get_invoke_func(
 	return ERR_PTR(-EINVAL);
 }
 
+/* optee_remove - Device Removal Routine
+ * @pdev: platform device information struct
+ *
+ * optee_remove is called by platform subsystem to alert the driver
+ * that it should release the device
+ */
+
 static int optee_remove(struct platform_device *pdev)
 {
 	struct optee *optee = platform_get_drvdata(pdev);
@@ -604,6 +611,18 @@ static int optee_remove(struct platform_
 	return 0;
 }
 
+/* optee_shutdown - Device Removal Routine
+ * @pdev: platform device information struct
+ *
+ * platform_shutdown is called by the platform subsystem to alert
+ * the driver that a shutdown, reboot, or kexec is happening and
+ * device must be disabled.
+ */
+static void optee_shutdown(struct platform_device *pdev)
+{
+	optee_disable_shm_cache(platform_get_drvdata(pdev));
+}
+
 static int optee_probe(struct platform_device *pdev)
 {
 	optee_invoke_fn *invoke_fn;
@@ -749,6 +768,7 @@ MODULE_DEVICE_TABLE(of, optee_dt_match);
 static struct platform_driver optee_driver = {
 	.probe  = optee_probe,
 	.remove = optee_remove,
+	.shutdown = optee_shutdown,
 	.driver = {
 		.name = "optee",
 		.of_match_table = optee_dt_match,


