Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5F56B02F4
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCHJcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjCHJcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:32:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5F05CC3C
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 01:31:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8302B81C12
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 09:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EBDC433EF;
        Wed,  8 Mar 2023 09:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678267904;
        bh=/ovWy1YxM7ckSwLIGMtZ7KcwHBuUV1VzvZsXapmw744=;
        h=Subject:To:Cc:From:Date:From;
        b=UrUzOBLDboMAgG90jWZZJUj72sxzzmGbPn0s8YTbXbh+h6Jn0CgnFiWPLIWV2vb6Z
         tbvEomBEEb8/55BhlCSRYw3KbW2mivS52yxA+lcGde/2gt1BCIw1fuWITe3x4sBDXU
         IHbyBPTVZnzsIRRela/OpoBJoPM7lZ714hJVGBu0=
Subject: FAILED: patch "[PATCH] s390/dasd: add missing discipline function" failed to apply to 5.10-stable tree
To:     sth@linux.ibm.com, axboe@kernel.dk, cohuck@redhat.com,
        hoeppner@linux.ibm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Mar 2023 10:31:33 +0100
Message-ID: <16782678934450@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x c0c8a8397fa8a74d04915f4d3d28cb4a5d401427
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16782678934450@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

c0c8a8397fa8 ("s390/dasd: add missing discipline function")
4d063e646b4b ("s390/dasd: Process FCES path event notification")
b72949328869 ("s390/dasd: Prepare for additional path event handling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c0c8a8397fa8a74d04915f4d3d28cb4a5d401427 Mon Sep 17 00:00:00 2001
From: Stefan Haberland <sth@linux.ibm.com>
Date: Tue, 25 May 2021 14:50:06 +0200
Subject: [PATCH] s390/dasd: add missing discipline function

Fix crash with illegal operation exception in dasd_device_tasklet.
Commit b72949328869 ("s390/dasd: Prepare for additional path event handling")
renamed the verify_path function for ECKD but not for FBA and DIAG.
This leads to a panic when the path verification function is called for a
FBA or DIAG device.

Fix by defining a wrapper function for dasd_generic_verify_path().

Fixes: b72949328869 ("s390/dasd: Prepare for additional path event handling")
Cc: <stable@vger.kernel.org> #5.11
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20210525125006.157531-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 1b9e1442e6a5..fd42a5fffaed 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -642,12 +642,18 @@ static void dasd_diag_setup_blk_queue(struct dasd_block *block)
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
 }
 
+static int dasd_diag_pe_handler(struct dasd_device *device,
+				__u8 tbvpm, __u8 fcsecpm)
+{
+	return dasd_generic_verify_path(device, tbvpm);
+}
+
 static struct dasd_discipline dasd_diag_discipline = {
 	.owner = THIS_MODULE,
 	.name = "DIAG",
 	.ebcname = "DIAG",
 	.check_device = dasd_diag_check_device,
-	.verify_path = dasd_generic_verify_path,
+	.pe_handler = dasd_diag_pe_handler,
 	.fill_geometry = dasd_diag_fill_geometry,
 	.setup_blk_queue = dasd_diag_setup_blk_queue,
 	.start_IO = dasd_start_diag,
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 4789410885e4..3ad319aee51e 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -794,13 +794,19 @@ static void dasd_fba_setup_blk_queue(struct dasd_block *block)
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 }
 
+static int dasd_fba_pe_handler(struct dasd_device *device,
+			       __u8 tbvpm, __u8 fcsecpm)
+{
+	return dasd_generic_verify_path(device, tbvpm);
+}
+
 static struct dasd_discipline dasd_fba_discipline = {
 	.owner = THIS_MODULE,
 	.name = "FBA ",
 	.ebcname = "FBA ",
 	.check_device = dasd_fba_check_characteristics,
 	.do_analysis = dasd_fba_do_analysis,
-	.verify_path = dasd_generic_verify_path,
+	.pe_handler = dasd_fba_pe_handler,
 	.setup_blk_queue = dasd_fba_setup_blk_queue,
 	.fill_geometry = dasd_fba_fill_geometry,
 	.start_IO = dasd_start_IO,
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 1c59b0e86a9f..155428bfed8a 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -297,7 +297,6 @@ struct dasd_discipline {
 	 * e.g. verify that new path is compatible with the current
 	 * configuration.
 	 */
-	int (*verify_path)(struct dasd_device *, __u8);
 	int (*pe_handler)(struct dasd_device *, __u8, __u8);
 
 	/*

