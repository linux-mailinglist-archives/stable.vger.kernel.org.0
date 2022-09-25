Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557705E9149
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 08:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIYGzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 02:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiIYGzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 02:55:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C99224BD3
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 23:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBBA06006F
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 06:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE233C433D6;
        Sun, 25 Sep 2022 06:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664088940;
        bh=rmYIzBXwHB7SM2HrYZoV6bmiQq010Rm99TFKbiSA2dA=;
        h=Subject:To:From:Date:From;
        b=e3hziJ2yGbxcONZH8uaa5+tJ2J/xJi83QEo1TUWcFRJvY8wCK4x64QtpyVqzlkvn7
         i0005zmjShFotow1UX7jPASNOMuG8TlSsYe3GAsg7vkNB7oEE3hSNfEGsL35qtrALY
         rmQa5XDrO7/vKmEGoLJQyt4OgDmba4GiVz6RnaX0=
Subject: patch "slimbus: qcom-ngd: cleanup in probe error path" added to char-misc-next
To:     krzysztof.kozlowski@linaro.org, gregkh@linuxfoundation.org,
        srinivas.kandagatla@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 25 Sep 2022 08:55:12 +0200
Message-ID: <166408891220767@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    slimbus: qcom-ngd: cleanup in probe error path

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 16f14551d0df9e7cd283545d7d748829594d912f Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Fri, 16 Sep 2022 13:29:08 +0100
Subject: slimbus: qcom-ngd: cleanup in probe error path

Add proper error path in probe() to cleanup resources previously
acquired/allocated to fix warnings visible during probe deferral:

  notifier callback qcom_slim_ngd_ssr_notify already registered
  WARNING: CPU: 6 PID: 70 at kernel/notifier.c:28 notifier_chain_register+0x5c/0x90
  Modules linked in:
  CPU: 6 PID: 70 Comm: kworker/u16:1 Not tainted 6.0.0-rc3-next-20220830 #380
  Call trace:
   notifier_chain_register+0x5c/0x90
   srcu_notifier_chain_register+0x44/0x90
   qcom_register_ssr_notifier+0x38/0x4c
   qcom_slim_ngd_ctrl_probe+0xd8/0x400
   platform_probe+0x6c/0xe0
   really_probe+0xbc/0x2d4
   __driver_probe_device+0x78/0xe0
   driver_probe_device+0x3c/0x12c
   __device_attach_driver+0xb8/0x120
   bus_for_each_drv+0x78/0xd0
   __device_attach+0xa8/0x1c0
   device_initial_probe+0x18/0x24
   bus_probe_device+0xa0/0xac
   deferred_probe_work_func+0x88/0xc0
   process_one_work+0x1d4/0x320
   worker_thread+0x2cc/0x44c
   kthread+0x110/0x114
   ret_from_fork+0x10/0x20

Fixes: e1ae85e1830e ("slimbus: qcom-ngd-ctrl: add Protection Domain Restart Support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220916122910.170730-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index f4f330b9fa72..bacc6af1d51e 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1576,18 +1576,27 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 	ctrl->pdr = pdr_handle_alloc(slim_pd_status, ctrl);
 	if (IS_ERR(ctrl->pdr)) {
 		dev_err(dev, "Failed to init PDR handle\n");
-		return PTR_ERR(ctrl->pdr);
+		ret = PTR_ERR(ctrl->pdr);
+		goto err_pdr_alloc;
 	}
 
 	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
 	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
 		ret = PTR_ERR(pds);
 		dev_err(dev, "pdr add lookup failed: %d\n", ret);
-		return ret;
+		goto err_pdr_lookup;
 	}
 
 	platform_driver_register(&qcom_slim_ngd_driver);
 	return of_qcom_slim_ngd_register(dev, ctrl);
+
+err_pdr_alloc:
+	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
+
+err_pdr_lookup:
+	pdr_handle_release(ctrl->pdr);
+
+	return ret;
 }
 
 static int qcom_slim_ngd_ctrl_remove(struct platform_device *pdev)
-- 
2.37.3


