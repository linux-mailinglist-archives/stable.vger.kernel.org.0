Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BEB521814
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbiEJNdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243830AbiEJNcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA2D2D2E34;
        Tue, 10 May 2022 06:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4238B81D7A;
        Tue, 10 May 2022 13:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04B0C385C9;
        Tue, 10 May 2022 13:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188948;
        bh=mnF5DNybPMFqD1aTb6h8yuUvQgN5VtdclTck+jttI7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YawhcREP+JNqVLVHxmg1DnHWepKbc910HHtuAh4RIF8LBpnqJjStrOC6DK4g+Mb+q
         bZVSROWBIgqfKpKJN7F5dtV3K7HSkH30mVuwR/Tpegz7JgRL67FJH8USifR0cDNmbT
         Ocgq3Rw/wdU2yx17tmbE3gdlEskqqXY+dmHpOxNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 14/52] s390/dasd: fix data corruption for ESE devices
Date:   Tue, 10 May 2022 15:07:43 +0200
Message-Id: <20220510130730.275016996@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 5b53a405e4658580e1faf7c217db3f55a21ba849 upstream.

For ESE devices we get an error when accessing an unformatted track.
The handling of this error will return zero data for read requests and
format the track on demand before writing to it. To do this the code needs
to distinguish between read and write requests. This is done with data from
the blocklayer request. A pointer to the blocklayer request is stored in
the CQR.

If there is an error on the device an ERP request is built to do error
recovery. While the ERP request is mostly a copy of the original CQR the
pointer to the blocklayer request is not copied to not accidentally pass
it back to the blocklayer without cleanup.

This leads to the error that during ESE handling after an ERP request was
built it is not possible to determine the IO direction. This leads to the
formatting of a track for read requests which might in turn lead to data
corruption.

Fixes: 5e2b17e712cf ("s390/dasd: Add dynamic formatting support for ESE volumes")
Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Link: https://lore.kernel.org/r/20220505141733.1989450-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c      |    8 +++++++-
 drivers/s390/block/dasd_eckd.c |    2 +-
 drivers/s390/block/dasd_int.h  |   12 ++++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1680,6 +1680,7 @@ void dasd_int_handler(struct ccw_device
 	unsigned long now;
 	int nrf_suppressed = 0;
 	int fp_suppressed = 0;
+	struct request *req;
 	u8 *sense = NULL;
 	int expires;
 
@@ -1780,7 +1781,12 @@ void dasd_int_handler(struct ccw_device
 	}
 
 	if (dasd_ese_needs_format(cqr->block, irb)) {
-		if (rq_data_dir((struct request *)cqr->callback_data) == READ) {
+		req = dasd_get_callback_data(cqr);
+		if (!req) {
+			cqr->status = DASD_CQR_ERROR;
+			return;
+		}
+		if (rq_data_dir(req) == READ) {
 			device->discipline->ese_read(cqr, irb);
 			cqr->status = DASD_CQR_SUCCESS;
 			cqr->stopclk = now;
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3088,7 +3088,7 @@ dasd_eckd_ese_format(struct dasd_device
 	sector_t curr_trk;
 	int rc;
 
-	req = cqr->callback_data;
+	req = dasd_get_callback_data(cqr);
 	block = cqr->block;
 	base = block->base;
 	private = base->private;
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -723,6 +723,18 @@ dasd_check_blocksize(int bsize)
 	return 0;
 }
 
+/*
+ * return the callback data of the original request in case there are
+ * ERP requests build on top of it
+ */
+static inline void *dasd_get_callback_data(struct dasd_ccw_req *cqr)
+{
+	while (cqr->refers)
+		cqr = cqr->refers;
+
+	return cqr->callback_data;
+}
+
 /* externals in dasd.c */
 #define DASD_PROFILE_OFF	 0
 #define DASD_PROFILE_ON 	 1


