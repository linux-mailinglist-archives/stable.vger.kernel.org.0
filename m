Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 494FF59D580
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbiHWJH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347750AbiHWJGo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:06:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8C285FFE;
        Tue, 23 Aug 2022 01:29:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD7F61326;
        Tue, 23 Aug 2022 08:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03452C4314C;
        Tue, 23 Aug 2022 08:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243313;
        bh=9vjKezl3dOytaASgrXKh7da9oZaZWQxs9UU973wrK9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjyeJAcc8zQA4for3QIc9Gwn6514e6AfrPM6yCe55DBpW5ntZO3bBqpHeTku+E0AQ
         sM7bIY+e4PcDvM/bSP4jQxmsJW3q7zjT8MAH0Et5R52lxf8kHjohb6384yf9/KV4xE
         nZ+aphSzNY/paoxzdiOY1nxr7VPFDlNSUt5EauDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Hemant Kumar <quic_hemantk@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 207/365] net: qrtr: start MHI channel after endpoit creation
Date:   Tue, 23 Aug 2022 10:01:48 +0200
Message-Id: <20220823080126.857789357@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Maxim Kochetkov <fido_max@inbox.ru>

commit 68a838b84effb7b57ba7d50b1863fc6ae35a54ce upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/mhi.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -78,11 +78,6 @@ static int qcom_mhi_qrtr_probe(struct mh
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
@@ -96,6 +91,13 @@ static int qcom_mhi_qrtr_probe(struct mh
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


