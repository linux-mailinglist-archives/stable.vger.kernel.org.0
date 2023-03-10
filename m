Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C561A6B4AEA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbjCJP1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbjCJP1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:27:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAEA5D744
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFEF8B822E4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4B0C433EF;
        Fri, 10 Mar 2023 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461022;
        bh=pWWOIX1loM8LiMjF4qcWcfCgBkynaM0w0eWH2qUlrMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7LVPIfS64rsoVEG9K3Ol/VmiHvB9SA959gb7hWmaqNy6tWUWw2xjdsiXLWVJtMIt
         0ETjggMAvcbt3HG6uyzLXF0dFmocyb6r58JUprgFTBZxi3l18eOYV9k+/SCa4pM/G/
         2ZUeHB+bE0Fmfii422vAkM17zjUMLU3zEGd9Apqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Hoeppner <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 529/529] s390/dasd: add missing discipline function
Date:   Fri, 10 Mar 2023 14:41:12 +0100
Message-Id: <20230310133829.304895628@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit c0c8a8397fa8a74d04915f4d3d28cb4a5d401427 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_diag.c |    8 +++++++-
 drivers/s390/block/dasd_fba.c  |    8 +++++++-
 drivers/s390/block/dasd_int.h  |    1 -
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -642,12 +642,18 @@ static void dasd_diag_setup_blk_queue(st
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
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -803,13 +803,19 @@ static void dasd_fba_setup_blk_queue(str
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
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -298,7 +298,6 @@ struct dasd_discipline {
 	 * e.g. verify that new path is compatible with the current
 	 * configuration.
 	 */
-	int (*verify_path)(struct dasd_device *, __u8);
 	int (*pe_handler)(struct dasd_device *, __u8);
 
 	/*


