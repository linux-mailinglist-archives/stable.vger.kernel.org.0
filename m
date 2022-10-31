Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501C4612FF8
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiJaFs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaFsz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:48:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ED6AE6F
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 556B5B8111C
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A815AC433C1;
        Mon, 31 Oct 2022 05:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667195332;
        bh=RGoCPsuFxXU4VmBZL347D8YiwSNRWTXs7aV2DKpvHZA=;
        h=Subject:To:Cc:From:Date:From;
        b=DHPepy1HLsOOY6V/XaoBDzxsdMYUEVZQPYZp7YieZ6AEK9Djv24xUFJ/t82nz08FL
         BMVdBAwYZGb8rhGVfg7G/C+naWPk+w3f8EKjoS9tSL3enulwKvPrEtKX3Tvo6o2Rlr
         eE/yMmiJZw496BYUbF3wk2HbSihW63gc8GgKEP1U=
Subject: FAILED: patch "[PATCH] usb: typec: ucsi: acpi: Implement resume callback" failed to apply to 5.15-stable tree
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:49:48 +0100
Message-ID: <166719538819395@kroah.com>
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

4e3a50293c2b ("usb: typec: ucsi: acpi: Implement resume callback")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e3a50293c2b21961f02e1afa2f17d3a1a90c7c8 Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Fri, 7 Oct 2022 13:09:51 +0300
Subject: [PATCH] usb: typec: ucsi: acpi: Implement resume callback

The ACPI driver needs to resume the interface by calling
ucsi_resume(). Otherwise we may fail to detect connections
and disconnections that happen while the system is
suspended.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210425
Fixes: a94ecde41f7e ("usb: typec: ucsi: ccg: enable runtime pm support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221007100951.43798-3-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 8873c1644a29..ce0c8ef80c04 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -185,6 +185,15 @@ static int ucsi_acpi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int ucsi_acpi_resume(struct device *dev)
+{
+	struct ucsi_acpi *ua = dev_get_drvdata(dev);
+
+	return ucsi_resume(ua->ucsi);
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(ucsi_acpi_pm_ops, NULL, ucsi_acpi_resume);
+
 static const struct acpi_device_id ucsi_acpi_match[] = {
 	{ "PNP0CA0", 0 },
 	{ },
@@ -194,6 +203,7 @@ MODULE_DEVICE_TABLE(acpi, ucsi_acpi_match);
 static struct platform_driver ucsi_acpi_platform_driver = {
 	.driver = {
 		.name = "ucsi_acpi",
+		.pm = pm_ptr(&ucsi_acpi_pm_ops),
 		.acpi_match_table = ACPI_PTR(ucsi_acpi_match),
 	},
 	.probe = ucsi_acpi_probe,

