Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B9C608C6A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiJVLQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJVLPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:15:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B079B489
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 03:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7B2F60B7B
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 10:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6714C433C1;
        Sat, 22 Oct 2022 10:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666435161;
        bh=+YGe7CGe0d+59ZtdUjH7fDAMKlF91Qur1Wpart1sR7Q=;
        h=Subject:To:From:Date:From;
        b=Ni/KNwp66JJ+1B3A/8Nd/p5DHnPaCovcyvvjPZGbMHD+YyKrUn9YwQ/Wg+v1biAm/
         a/PUVb3o05d+tWj87fgQ776IIHhnW92csIUG9K6tWYACHCj0HRHkSxiyc8vQr7/kT5
         QSWYOTWTKojXivphGmFrtrezRrQ4mAzGDkrzYL6w=
Subject: patch "usb: typec: ucsi: acpi: Implement resume callback" added to usb-linus
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Oct 2022 12:39:10 +0200
Message-ID: <166643515070202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: acpi: Implement resume callback

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4e3a50293c2b21961f02e1afa2f17d3a1a90c7c8 Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Fri, 7 Oct 2022 13:09:51 +0300
Subject: usb: typec: ucsi: acpi: Implement resume callback

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
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

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
-- 
2.38.1


