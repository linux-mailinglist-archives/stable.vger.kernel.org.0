Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D6855C786
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbiF0Lu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiF0Lso (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C7E101FB;
        Mon, 27 Jun 2022 04:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F22D61214;
        Mon, 27 Jun 2022 11:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C04C3411D;
        Mon, 27 Jun 2022 11:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330130;
        bh=JxkVXlS23oqK2KsdzJD6U26Oq7j6NUtrTCWBhLTB8A0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0adhCRg0L3daaCoi8Kpy5WkT9rogYIWy/ieq57VRiFSL/pnc9fetAQygtCE/vM89
         2I9HV6wUWNd7P7JQPTQuViDGLsZRovJQZ0/hXoWzVWJVs8mPJrx49CFAS8/qa4TcXr
         t5iwhU4Arl5CnwKlt5JNLu79GOemtkoYo8Ad6PL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 054/181] scsi: storvsc: Correct reporting of Hyper-V I/O size limits
Date:   Mon, 27 Jun 2022 13:20:27 +0200
Message-Id: <20220627111946.134166779@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurabh Sengar <ssengar@linux.microsoft.com>

[ Upstream commit 1d3e0980782fbafaf93285779fd3905e4f866802 ]

Current code is based on the idea that the max number of SGL entries
also determines the max size of an I/O request.  While this idea was
true in older versions of the storvsc driver when SGL entry length
was limited to 4 Kbytes, commit 3d9c3dcc58e9 ("scsi: storvsc: Enable
scatterlist entry lengths > 4Kbytes") removed that limitation. It's
now theoretically possible for the block layer to send requests that
exceed the maximum size supported by Hyper-V. This problem doesn't
currently happen in practice because the block layer defaults to a
512 Kbyte maximum, while Hyper-V in Azure supports 2 Mbyte I/O sizes.
But some future configuration of Hyper-V could have a smaller max I/O
size, and the block layer could exceed that max.

Fix this by correctly setting max_sectors as well as sg_tablesize to
reflect the maximum I/O size that Hyper-V reports. While allowing
I/O sizes larger than the block layer default of 512 Kbytes doesn’t
provide any noticeable performance benefit in the tests we ran, it's
still appropriate to report the correct underlying Hyper-V capabilities
to the Linux block layer.

Also tweak the virt_boundary_mask to reflect that the required
alignment derives from Hyper-V communication using a 4 Kbyte page size,
and not on the guest page size, which might be bigger (eg. ARM64).

Link: https://lore.kernel.org/r/1655190355-28722-1-git-send-email-ssengar@linux.microsoft.com
Fixes: 3d9c3dcc58e9 ("scsi: storvsc: Enable scatter list entry lengths > 4Kbytes")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9a0bba5a51a7..4b1f1d73eee8 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1916,7 +1916,7 @@ static struct scsi_host_template scsi_driver = {
 	.cmd_per_lun =		2048,
 	.this_id =		-1,
 	/* Ensure there are no gaps in presented sgls */
-	.virt_boundary_mask =	PAGE_SIZE-1,
+	.virt_boundary_mask =	HV_HYP_PAGE_SIZE - 1,
 	.no_write_same =	1,
 	.track_queue_depth =	1,
 	.change_queue_depth =	storvsc_change_queue_depth,
@@ -1970,6 +1970,7 @@ static int storvsc_probe(struct hv_device *device,
 	int max_targets;
 	int max_channels;
 	int max_sub_channels = 0;
+	u32 max_xfer_bytes;
 
 	/*
 	 * Based on the windows host we are running on,
@@ -2059,12 +2060,28 @@ static int storvsc_probe(struct hv_device *device,
 	}
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
-
 	/*
-	 * set the table size based on the info we got
-	 * from the host.
+	 * Any reasonable Hyper-V configuration should provide
+	 * max_transfer_bytes value aligning to HV_HYP_PAGE_SIZE,
+	 * protecting it from any weird value.
+	 */
+	max_xfer_bytes = round_down(stor_device->max_transfer_bytes, HV_HYP_PAGE_SIZE);
+	/* max_hw_sectors_kb */
+	host->max_sectors = max_xfer_bytes >> 9;
+	/*
+	 * There are 2 requirements for Hyper-V storvsc sgl segments,
+	 * based on which the below calculation for max segments is
+	 * done:
+	 *
+	 * 1. Except for the first and last sgl segment, all sgl segments
+	 *    should be align to HV_HYP_PAGE_SIZE, that also means the
+	 *    maximum number of segments in a sgl can be calculated by
+	 *    dividing the total max transfer length by HV_HYP_PAGE_SIZE.
+	 *
+	 * 2. Except for the first and last, each entry in the SGL must
+	 *    have an offset that is a multiple of HV_HYP_PAGE_SIZE.
 	 */
-	host->sg_tablesize = (stor_device->max_transfer_bytes >> PAGE_SHIFT);
+	host->sg_tablesize = (max_xfer_bytes >> HV_HYP_PAGE_SHIFT) + 1;
 	/*
 	 * For non-IDE disks, the host supports multiple channels.
 	 * Set the number of HW queues we are supporting.
-- 
2.35.1



