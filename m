Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4908D4CF2C5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 08:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiCGHnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 02:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiCGHnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 02:43:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6924D49
        for <stable@vger.kernel.org>; Sun,  6 Mar 2022 23:42:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6D93B80B52
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 07:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08620C340E9;
        Mon,  7 Mar 2022 07:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646638955;
        bh=yX1Ef4Ft0cuGeGkMC3lPAvO4FMVq2CTBgBtlZHD+cUU=;
        h=Subject:To:Cc:From:Date:From;
        b=c6RJfiW9RkH/qcsBKj0U7uF1HAfJmCk+PpS1C1NQ82yZiL9BI3UKZWlFsv7Pi82l9
         xOKYoiSHBi8AWzTmkavGdmetgcY+nfAwt1pYZU5tiXRkuNFXf8jO3NywizjPX2P+aq
         PNQ2Qas1fk0phdl2vOm6XPvPde3rnQLT4potnmdg=
Subject: FAILED: patch "[PATCH] tee: optee: fix error return code in probe function" failed to apply to 5.16-stable tree
To:     yangyingliang@huawei.com, hulkci@huawei.com,
        jens.wiklander@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Mar 2022 08:42:25 +0100
Message-ID: <16466389455912@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 40eb0dcf4114cbfff4d207890fa5a19e82da9fdc Mon Sep 17 00:00:00 2001
From: Yang Yingliang <yangyingliang@huawei.com>
Date: Thu, 10 Feb 2022 17:10:53 +0800
Subject: [PATCH] tee: optee: fix error return code in probe function

If teedev_open() fails, probe function need return
error code.

Fixes: aceeafefff73 ("optee: use driver internal tee_context for some rpc")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index 545f61af1248..0c90355896a0 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -860,8 +860,10 @@ static int optee_ffa_probe(struct ffa_device *ffa_dev)
 	optee_supp_init(&optee->supp);
 	ffa_dev_set_drvdata(ffa_dev, optee);
 	ctx = teedev_open(optee->teedev);
-	if (IS_ERR(ctx))
+	if (IS_ERR(ctx)) {
+		rc = PTR_ERR(ctx);
 		goto err_rhashtable_free;
+	}
 	optee->ctx = ctx;
 	rc = optee_notif_init(optee, OPTEE_DEFAULT_MAX_NOTIF_VALUE);
 	if (rc)
diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index bacd1a1d79ee..4157f4b41bdd 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -1427,8 +1427,10 @@ static int optee_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, optee);
 	ctx = teedev_open(optee->teedev);
-	if (IS_ERR(ctx))
+	if (IS_ERR(ctx)) {
+		rc = PTR_ERR(ctx);
 		goto err_supp_uninit;
+	}
 	optee->ctx = ctx;
 	rc = optee_notif_init(optee, max_notif_value);
 	if (rc)

