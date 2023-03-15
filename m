Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F19A6BB0A9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjCOMU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbjCOMT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:19:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02989303C4
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70EC1CE1986
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7052BC433D2;
        Wed, 15 Mar 2023 12:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882782;
        bh=SJLzFzrVOrtYS4xGB/WTDW00RB5T+mOjo1I/cIMgCiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbzcWx1Gvdg4+MHy1nHZDDP695EKmcZUEa8k0+rqdi7NVQI0UvoakHgB7JftD+qIl
         +yUfeIXccvq5DAxMp8tl9/jT6dhHGF6eL/keKqVxDEov52zTr08WSWpcK4Ww9uMlgZ
         Cp8SiB8PPXWfQom/jlD7JuO1ztU9vyUdFkoegRI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Hoeppner <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 68/68] s390/dasd: add missing discipline function
Date:   Wed, 15 Mar 2023 13:13:02 +0100
Message-Id: <20230315115728.763521815@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/s390/block/dasd_diag.c |    7 ++++++-
 drivers/s390/block/dasd_fba.c  |    7 ++++++-
 drivers/s390/block/dasd_int.h  |    1 -
 3 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -644,12 +644,17 @@ static void dasd_diag_setup_blk_queue(st
 	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
 }
 
+static int dasd_diag_pe_handler(struct dasd_device *device, __u8 tbvpm)
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
@@ -803,13 +803,18 @@ static void dasd_fba_setup_blk_queue(str
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 }
 
+static int dasd_fba_pe_handler(struct dasd_device *device, __u8 tbvpm)
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


