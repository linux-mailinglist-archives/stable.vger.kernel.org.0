Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D07966C5E9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjAPQMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjAPQLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:11:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D302A164
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 740CA6104A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE6EC433F1;
        Mon, 16 Jan 2023 16:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885233;
        bh=RjF66h9NKrNQOTEKnpDrWONZv/BlNFaTw71NsevcSMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1ayiB82gb4IWIT7CG+wQTjSnh+VWkEzmWVPVUxHEtKD4oxvvMhSjxA6O9bYkwoQg
         u2nqSKWi3VbHffykVGnzWw8zw7aY966kb7pWiS5gc/EqBalavo9lBMUSnPHnba0/zT
         0nqM3OpAJD0KiZF87AGykZIeVfeDxrpr+Sgp18yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eliav Farber <farbere@amazon.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>, stable@kernel.org
Subject: [PATCH 5.10 38/64] EDAC/device: Fix period calculation in edac_device_reset_delay_period()
Date:   Mon, 16 Jan 2023 16:51:45 +0100
Message-Id: <20230116154744.882662388@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eliav Farber <farbere@amazon.com>

commit e84077437902ec99eba0a6b516df772653f142c7 upstream.

Fix period calculation in case user sets a value of 1000.  The input of
round_jiffies_relative() should be in jiffies and not in milli-seconds.

  [ bp: Use the same code pattern as in edac_device_workq_setup() for
    clarity. ]

Fixes: c4cf3b454eca ("EDAC: Rework workqueue handling")
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20221020124458.22153-1-farbere@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/edac_device.c |   17 ++++++++---------
 drivers/edac/edac_module.h |    2 +-
 2 files changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -424,17 +424,16 @@ static void edac_device_workq_teardown(s
  *	Then restart the workq on the new delay
  */
 void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
-					unsigned long value)
+				    unsigned long msec)
 {
-	unsigned long jiffs = msecs_to_jiffies(value);
+	edac_dev->poll_msec = msec;
+	edac_dev->delay	    = msecs_to_jiffies(msec);
 
-	if (value == 1000)
-		jiffs = round_jiffies_relative(value);
-
-	edac_dev->poll_msec = value;
-	edac_dev->delay	    = jiffs;
-
-	edac_mod_work(&edac_dev->work, jiffs);
+	/* See comment in edac_device_workq_setup() above */
+	if (edac_dev->poll_msec == 1000)
+		edac_mod_work(&edac_dev->work, round_jiffies_relative(edac_dev->delay));
+	else
+		edac_mod_work(&edac_dev->work, edac_dev->delay);
 }
 
 int edac_device_alloc_index(void)
--- a/drivers/edac/edac_module.h
+++ b/drivers/edac/edac_module.h
@@ -56,7 +56,7 @@ bool edac_stop_work(struct delayed_work
 bool edac_mod_work(struct delayed_work *work, unsigned long delay);
 
 extern void edac_device_reset_delay_period(struct edac_device_ctl_info
-					   *edac_dev, unsigned long value);
+					   *edac_dev, unsigned long msec);
 extern void edac_mc_reset_delay_period(unsigned long value);
 
 extern void *edac_align_ptr(void **p, unsigned size, int n_elems);


