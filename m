Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BB361596D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiKBDKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiKBDKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:10:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F723BE1
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8878CE1EB9
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39325C433C1;
        Wed,  2 Nov 2022 03:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358649;
        bh=xA4mQAal6pHW63JAX1mvRsr/9zyhRBSvZ1pHZWWLQtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L4DuSDxKDX38GaFXR3PKBRQz/ywMWI0kUE6mtr8sgjdPzZEDLM24WtsBuN/HOUdjn
         pZTCFZgo1A6viaYwEMg6TouwvWD9hdqDQRlTBBsPDR2pQBV08R9+r7Ox47I/Ps382d
         kEUa5vMPvkrCq5lTc6jC5mXRcGb/xM+7L1wzaWAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.15 127/132] scsi: sd: Revert "scsi: sd: Remove a local variable"
Date:   Wed,  2 Nov 2022 03:33:53 +0100
Message-Id: <20221102022103.008409308@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

This reverts commit 84f7a9de0602704bbec774a6c7f7c8c4994bee9c.

Because it introduces a problem that rq->__data_len is set to the wrong
value.

before the patch:
1) nr_bytes = rq->__data_len
2) rq->__data_len = sdp->sector_size
3) scsi_init_io()
4) rq->__data_len = nr_bytes

after the patch:
1) rq->__data_len = sdp->sector_size
2) scsi_init_io()
3) rq->__data_len = rq->__data_len -> __data_len is wrong

It will cause that io can only complete one segment each time, and the io
will requeue in scsi_io_completion_action(), which will cause severe
performance degradation.

Scsi write same is removed in commit e383e16e84e9 ("scsi: sd: Remove
WRITE_SAME support") from mainline, hence this patch is only needed for
stable kernels.

Fixes: 84f7a9de0602 ("scsi: sd: Remove a local variable")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1072,6 +1072,7 @@ static blk_status_t sd_setup_write_same_
 	struct bio *bio = rq->bio;
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	blk_status_t ret;
 
 	if (sdkp->device->no_write_same)
@@ -1108,7 +1109,7 @@ static blk_status_t sd_setup_write_same_
 	 */
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
+	rq->__data_len = nr_bytes;
 
 	return ret;
 }


