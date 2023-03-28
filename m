Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7D06CC52E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjC1PMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjC1PMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:12:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1FB10249
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:12:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94EF261857
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9413C433D2;
        Tue, 28 Mar 2023 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016233;
        bh=vEfryZ1BN7Le09HUlijKeQZfGI3ERr6SEXXz/xwoT1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUUUCX7DPua0tyvvqt7I1+SSjnKzUpwEgId+MjEfPDM5rcAbbT1vRTHj2iHAPCI9B
         Fx7WQZxXi8DSpoY1qUjwwywbi5wsbB51voWEQYK8hukK9Mzgf974ZdCQ/P6g/8eExh
         jQuABQkbW2Vucaro1G0Pyiv2zZMzzej0aqd9JNlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Coly Li <colyli@suse.de>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 114/146] dm thin: fix deadlock when swapping to thin device
Date:   Tue, 28 Mar 2023 16:43:23 +0200
Message-Id: <20230328142607.409266459@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
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
@@ -3383,6 +3383,7 @@ static int pool_ctr(struct dm_target *ti
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4263,6 +4264,7 @@ static int thin_ctr(struct dm_target *ti
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
 


