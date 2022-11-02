Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180376159D8
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKBDTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKBDT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:19:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C51718B0C
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EBF7B8206F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB58C433C1;
        Wed,  2 Nov 2022 03:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359165;
        bh=sBM9+vFl3EEA41wOkKC4IfQrE07wefRdY/gTXSpvF9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8ASsKUsMAs9WX8g0JA31oqvLA9+J+1sw1HvMZiCvsLK3H0f3+pN0qWg462bPYGC1
         YSPhHkPEfmUX0z58V+00t7qJTWIn3+roo4oniu9xmwgSAmR3mcPHk4+WctV8GnYnjU
         fmFYQOGvb7VuN9epLA0pdlt9iUZFR/kZ4zUFxqZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.10 86/91] scsi: sd: Revert "scsi: sd: Remove a local variable"
Date:   Wed,  2 Nov 2022 03:34:09 +0100
Message-Id: <20221102022057.495361135@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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
@@ -1074,6 +1074,7 @@ static blk_status_t sd_setup_write_same_
 	struct bio *bio = rq->bio;
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	blk_status_t ret;
 
 	if (sdkp->device->no_write_same)
@@ -1110,7 +1111,7 @@ static blk_status_t sd_setup_write_same_
 	 */
 	rq->__data_len = sdp->sector_size;
 	ret = scsi_alloc_sgtables(cmd);
-	rq->__data_len = blk_rq_bytes(rq);
+	rq->__data_len = nr_bytes;
 
 	return ret;
 }


