Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C06D4789
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjDCOVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233112AbjDCOVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F303129F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6CFA61D15
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF45C433EF;
        Mon,  3 Apr 2023 14:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531620;
        bh=Y5S2zwdor8bE26DG/It14NGpXjxdVu5UrUPtvvuV9Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zp/ehRPAhrsluKYZL7odpl4CBFO2SDcRA2nBCWt+4yxKviCdt3osgQDGLKFXfw9i0
         Ygq2JkhRVSFP5JdrDzzcJovq2CeejRuRC3/iUU9nouWT2tybejmJZNiDJw++/9YIoI
         WqhXV3Lxte43ZroDv81cFaHkzeczDJIjKm2vmhDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Coly Li <colyli@suse.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 047/104] dm thin: fix deadlock when swapping to thin device
Date:   Mon,  3 Apr 2023 16:08:39 +0200
Message-Id: <20230403140406.222286811@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 9bbf5feecc7eab2c370496c1c161bbfe62084028 upstream.

This is an already known issue that dm-thin volume cannot be used as
swap, otherwise a deadlock may happen when dm-thin internal memory
demand triggers swap I/O on the dm-thin volume itself.

But thanks to commit a666e5c05e7c ("dm: fix deadlock when swapping to
encrypted device"), the limit_swap_bios target flag can also be used
for dm-thin to avoid the recursive I/O when it is used as swap.

Fix is to simply set ti->limit_swap_bios to true in both pool_ctr()
and thin_ctr().

In my test, I create a dm-thin volume /dev/vg/swap and use it as swap
device. Then I run fio on another dm-thin volume /dev/vg/main and use
large --blocksize to trigger swap I/O onto /dev/vg/swap.

The following fio command line is used in my test,
  fio --name recursive-swap-io --lockmem 1 --iodepth 128 \
     --ioengine libaio --filename /dev/vg/main --rw randrw \
    --blocksize 1M --numjobs 32 --time_based --runtime=12h

Without this fix, the whole system can be locked up within 15 seconds.

With this fix, there is no any deadlock or hung task observed after
2 hours of running fio.

Furthermore, if blocksize is changed from 1M to 128M, after around 30
seconds fio has no visible I/O, and the out-of-memory killer message
shows up in kernel message. After around 20 minutes all fio processes
are killed and the whole system is back to being alive.

This is exactly what is expected when recursive I/O happens on dm-thin
volume when it is used as swap.

Depends-on: a666e5c05e7c ("dm: fix deadlock when swapping to encrypted device")
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3407,6 +3407,7 @@ static int pool_ctr(struct dm_target *ti
 	pt->adjusted_pf = pt->requested_pf = pf;
 	bio_init(&pt->flush_bio, NULL, 0);
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4292,6 +4293,7 @@ static int thin_ctr(struct dm_target *ti
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
 


