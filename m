Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B35E59BFD0
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiHVMyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHVMyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:54:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363A5DF04
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:54:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73C661151
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B69C433D6;
        Mon, 22 Aug 2022 12:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661172871;
        bh=vTWxdNd1Qmn6NSC7NWdKQRI//dBCEbzLINQ7wYDyIkw=;
        h=Subject:To:Cc:From:Date:From;
        b=U/Arf/wZuyMuhcZ2Elydl+paJXuL+MkAJbl/wdtkUcqIfNylSzWe0rilMXej5BHjv
         XorwXgkwIacB5ArOfqsSC6mrthKEI3qUZx8bdrLZwgDEoThQCVT1ZOyL2uRE3BysdF
         lT/EsAR7f9+39xQgpXYokWrSohnI0Ounm5S8Y3iw=
Subject: FAILED: patch "[PATCH] net: qrtr: start MHI channel after endpoit creation" failed to apply to 5.10-stable tree
To:     fido_max@inbox.ru, davem@davemloft.net, loic.poulain@linaro.org,
        mani@kernel.org, quic_hemantk@quicinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:54:20 +0200
Message-ID: <166117286022916@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 68a838b84effb7b57ba7d50b1863fc6ae35a54ce Mon Sep 17 00:00:00 2001
From: Maxim Kochetkov <fido_max@inbox.ru>
Date: Thu, 11 Aug 2022 12:48:40 +0300
Subject: [PATCH] net: qrtr: start MHI channel after endpoit creation

MHI channel may generates event/interrupt right after enabling.
It may leads to 2 race conditions issues.

1)
Such event may be dropped by qcom_mhi_qrtr_dl_callback() at check:

	if (!qdev || mhi_res->transaction_status)
		return;

Because dev_set_drvdata(&mhi_dev->dev, qdev) may be not performed at
this moment. In this situation qrtr-ns will be unable to enumerate
services in device.
---------------------------------------------------------------

2)
Such event may come at the moment after dev_set_drvdata() and
before qrtr_endpoint_register(). In this case kernel will panic with
accessing wrong pointer at qcom_mhi_qrtr_dl_callback():

	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
				mhi_res->bytes_xferd);

Because endpoint is not created yet.
--------------------------------------------------------------
So move mhi_prepare_for_transfer_autoqueue after endpoint creation
to fix it.

Fixes: a2e2cc0dbb11 ("net: qrtr: Start MHI channels during init")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Hemant Kumar <quic_hemantk@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 18196e1c8c2f..9ced13c0627a 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -78,11 +78,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
-	if (rc)
-		return rc;
-
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
@@ -96,6 +91,13 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
+	/* start channels */
+	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
+	if (rc) {
+		qrtr_endpoint_unregister(&qdev->ep);
+		return rc;
+	}
+
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;

