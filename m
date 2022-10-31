Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20E5612FCA
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiJaFlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJaFlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:41:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A814CB873
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:41:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65CEAB810BF
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:41:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BF7C433C1;
        Mon, 31 Oct 2022 05:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194863;
        bh=VWT/ygX5u0Ot5ZZPU+TFa1/5cvkz3fLOhLsx9oPD14s=;
        h=Subject:To:Cc:From:Date:From;
        b=hem5/us7561sTGeQY2hwtzzWe0tYbXP7lUtyOHjJXljlT2tj+L9vu2qdDpjzwFmhh
         dgQujPWo1kJnusHAU0y4+7ahUp+JBd99AXu5p7Ey4fql24TjhIQJmjj+1MxY/bJHI+
         gH4GBYlEXBtTObMnHJGwkexFnxJdy5dWFb8p/9HU=
Subject: FAILED: patch "[PATCH] mtd: rawnand: tegra: Fix PM disable depth imbalance in probe" failed to apply to 5.15-stable tree
To:     zhangqilong3@huawei.com, miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:41:59 +0100
Message-ID: <16671949195931@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

3ada71310d2c ("mtd: rawnand: tegra: Fix PM disable depth imbalance in probe")
6902dc2fd57c ("mtd: rawnand: tegra: Add runtime PM and OPP support")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3ada71310d2c68eebb57772df6bb1f5f033ae802 Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Mon, 26 Sep 2022 16:44:56 +0800
Subject: [PATCH] mtd: rawnand: tegra: Fix PM disable depth imbalance in probe

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Cc: stable@vger.kernel.org
Fixes: d7d9f8ec77fe9 ("mtd: rawnand: add NVIDIA Tegra NAND Flash controller driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220926084456.98160-1-zhangqilong3@huawei.com

diff --git a/drivers/mtd/nand/raw/tegra_nand.c b/drivers/mtd/nand/raw/tegra_nand.c
index e12f9f580a15..a9b9031ce616 100644
--- a/drivers/mtd/nand/raw/tegra_nand.c
+++ b/drivers/mtd/nand/raw/tegra_nand.c
@@ -1181,7 +1181,7 @@ static int tegra_nand_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
 	if (err)
-		return err;
+		goto err_dis_pm;
 
 	err = reset_control_reset(rst);
 	if (err) {
@@ -1215,6 +1215,8 @@ static int tegra_nand_probe(struct platform_device *pdev)
 err_put_pm:
 	pm_runtime_put_sync_suspend(ctrl->dev);
 	pm_runtime_force_suspend(ctrl->dev);
+err_dis_pm:
+	pm_runtime_disable(&pdev->dev);
 	return err;
 }
 

