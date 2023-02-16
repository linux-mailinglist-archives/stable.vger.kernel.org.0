Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2426998A5
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 16:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjBPPTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 10:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjBPPTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 10:19:32 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72B855E4E
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:27 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f8so241170ioo.0
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nr9P+q3lnc60G0QD7ZQ8r9aN9DUVZpnJXngdvhp1uOE=;
        b=hmtSj3LLxpeouHeeJ3nCPBuwu55gk23lkWi/SoikASdagk5d1DXV7w0YevnChGwkP4
         I+Nw/5hz+vFwaETiqCXEr2PqGSOr/MIiw4db3IrvOxelwVKw1NvUx98ODIPmsOSz8fiy
         5t6j+LcGMagpyQfAL6E3/6uh1qFW9xP1xq0FKDrJAut33v2pJcdHr34uA0uJHlR4SjuX
         2/sWKkVjlQm4U1V8p3waKECBNf+Tm9zsP82HGZXGYMY8+hIJTB2ijfsAVMGatV4nJm57
         zq5+XZUyaXAGHoIImmLHpcLfHvWlkpqOPD2hWd2qSfskTVfBpN0YrUAZ7MvpLag3Rtbe
         sHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nr9P+q3lnc60G0QD7ZQ8r9aN9DUVZpnJXngdvhp1uOE=;
        b=72zUNI9J2uKlel4EXTaNKYHW5a+McScQO9sGTW7Nbm4xbxBXhqYXfc+CSIcccT62kT
         FrV7tbtClsLD8YIS0gQKWBUaHdKWqzWj8rArukft+WOM0K29Snowpoxk6MD8+81ggEs4
         stIE3QYkAsouuMdv6DT2KDS6pedaHKxyOOI6xpapUxqV+q/AixGT20m2mHIVzbvgc37V
         iFoe01w6AT6C8eNilHqQBFa/mT/WBb0TNn4piWdUKhKny6Gbha0kiTOuB55/OaowxOv/
         xuEDZo+nz8Pu9TgyWCpSNnrth9HeZ4SwoLhzrVaCs8jGkseASHAqnnu80rrym2iu7Ko8
         Py0A==
X-Gm-Message-State: AO0yUKXAR3aDdzVVshQcWLdoXFDI9/F5Ka4R4rdV5nFtZb5LzKh5J1eF
        VlhDqa1CCOxK8O0fgitIOt4lQw==
X-Google-Smtp-Source: AK7set+aGnXeawkhgrUQxhA1aznl3o0LZ42cyIBR/Mu9EDLgtiiI8a+o5RnpeyLcIUCUl0r5DC4s9Q==
X-Received: by 2002:a05:6602:5cd:b0:73a:6c75:5a85 with SMTP id w13-20020a05660205cd00b0073a6c755a85mr3699921iox.0.1676560767271;
        Thu, 16 Feb 2023 07:19:27 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p10-20020a0566022b0a00b006e2f2369d3csm561600iov.50.2023.02.16.07.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:19:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     hch@infradead.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 4/4] brd: mark as nowait compatible
Date:   Thu, 16 Feb 2023 08:19:18 -0700
Message-Id: <20230216151918.319585-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216151918.319585-1-axboe@kernel.dk>
References: <20230216151918.319585-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By default, non-mq drivers do not support nowait. This causes io_uring
to use a slower path as the driver cannot be trust not to block. brd
can safely set the nowait flag, as worst case all it does is a NOIO
allocation.

For io_uring, this makes a substantial difference. Before:

submitter=0, tid=453, file=/dev/ram0, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=440.03K, BW=1718MiB/s, IOS/call=32/31
IOPS=428.96K, BW=1675MiB/s, IOS/call=32/32
IOPS=442.59K, BW=1728MiB/s, IOS/call=32/31
IOPS=419.65K, BW=1639MiB/s, IOS/call=32/32
IOPS=426.82K, BW=1667MiB/s, IOS/call=32/31

and after:

submitter=0, tid=354, file=/dev/ram0, node=-1
polled=0, fixedbufs=1/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=3.37M, BW=13.15GiB/s, IOS/call=32/31
IOPS=3.45M, BW=13.46GiB/s, IOS/call=32/31
IOPS=3.43M, BW=13.42GiB/s, IOS/call=32/32
IOPS=3.43M, BW=13.39GiB/s, IOS/call=32/31
IOPS=3.43M, BW=13.38GiB/s, IOS/call=32/31

or about an 8x in difference. Now that brd is prepared to deal with
REQ_NOWAIT reads/writes, mark it as supporting that.

Cc: stable@vger.kernel.org # 5.10+
Link: https://lore.kernel.org/linux-block/20230203103005.31290-1-p.raghav@samsung.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/brd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 6019ef23344f..522530a6ebca 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -418,6 +418,7 @@ static int brd_alloc(int i)
 	/* Tell the block layer that this is not a rotational device */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, disk->queue);
+	blk_queue_flag_set(QUEUE_FLAG_NOWAIT, disk->queue);
 	err = add_disk(disk);
 	if (err)
 		goto out_cleanup_disk;
-- 
2.39.1

