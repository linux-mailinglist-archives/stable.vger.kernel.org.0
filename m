Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085536CC461
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbjC1PEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbjC1PEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:04:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3781D514
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CECDFCE1D9C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5391C433EF;
        Tue, 28 Mar 2023 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015782;
        bh=sRGFf43QbpCOhF8T3iMsrGAGJcquxPawIyZ9s16t4aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTCes5hSXbD+44i3KC1ioDvLLt+QrLeEwxgIypvzhda+oV2MgPtZx7bRgcqyut1Ap
         9FHjWs0XY2Y0SiEPs174M2xXNoBJW9DM36ye/2HhJ4CQKUdyCu9fMQmwxGmAo5qAhR
         3FriqKlp5ySUiPWhSJUIO8GypLmGgJeQTH9FFAIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Coly Li <colyli@suse.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 173/224] dm thin: fix deadlock when swapping to thin device
Date:   Tue, 28 Mar 2023 16:42:49 +0200
Message-Id: <20230328142624.584577982@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
@@ -3357,6 +3357,7 @@ static int pool_ctr(struct dm_target *ti
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4235,6 +4236,7 @@ static int thin_ctr(struct dm_target *ti
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);


