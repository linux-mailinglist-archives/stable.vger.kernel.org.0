Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E055F76A8
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 12:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJGKJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 06:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiJGKJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 06:09:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48125DE99;
        Fri,  7 Oct 2022 03:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665137384; x=1696673384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kxsqsFTelHvIhbWahvKIu4gWLPuU3Z6yYe+KJ6Mmdnw=;
  b=Zl7EOXeV/Dh/up8tbPeBYeWG/7ihtBkxZTmqpES46aDw2q/yu/K/h5Cw
   XtRYZpfs8EOzsUkOG1T5f2TwV2EgxSEV24tQ97W6+Ivz1j4CGplVihwvI
   a9zt22UwNvc0BZAAssYDVJVZ95+9qpXAtW13uyQYUjxYP0ilPZd8A8n8C
   ydTeMTwOpLyV1i+NIrpUtlgpYSfYtSnw/DbhC3uMkZih9kKOhQgVtuJzp
   Fp6vtBBR/UhKJpq/hEY8APrD5IwvXo+4l07d3ORR9UhSIXeD0opch5Z7g
   XappL/T5zaw/ZiXpQGCkjxTnNeuVpmgtaZpRrTarZfcZAw9QzETbI1brB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="330140341"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="330140341"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 03:09:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="767530686"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="767530686"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2022 03:09:39 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bastian Rieck <bastian@rieck.me>, grzegorz.alibozek@gmail.com,
        andrew.co@free.fr, meven29@gmail.com, pchernik@gmail.com,
        jorge.cep.mart@gmail.com, danielmorgan@disroot.org,
        bernie@codewiz.org, saipavanchitta1998@gmail.com,
        rubin@starset.net, maniette@gmail.com, nate@kde.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 2/2] usb: typec: ucsi: acpi: Implement resume callback
Date:   Fri,  7 Oct 2022 13:09:51 +0300
Message-Id: <20221007100951.43798-3-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
References: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The ACPI driver needs to resume the interface by calling
ucsi_resume(). Otherwise we may fail to detect connections
and disconnections that happen while the system is
suspended.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210425
Fixes: a94ecde41f7e ("usb: typec: ucsi: ccg: enable runtime pm support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 8873c1644a295..ce0c8ef80c043 100644
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
2.35.1

