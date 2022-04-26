Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B20350F6EF
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345803AbiDZJCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345700AbiDZI5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2762564C4;
        Tue, 26 Apr 2022 01:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1A12B81CED;
        Tue, 26 Apr 2022 08:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3511CC385A0;
        Tue, 26 Apr 2022 08:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962564;
        bh=J+4i1vcd5/XjbgPWY6oEshrMLJ1WCfrhyL0vvFwQMNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Da4WgEYiKXmnPFimqfHP0eQYS+QLQ3jfYEgt7pPOBicZBL1tIXBo4yZyvE0oDx6ii
         Cck24CtF1hVAJdRwshG+zW4RGh7h0eWfopREq2APsZrYbhFc4/DEKtahumjXhbJcSN
         eTVkG604nLAQsFJfjhe4OWNgR0mLsvgX4q2vUWN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 004/146] block/compat_ioctl: fix range check in BLKGETSIZE
Date:   Tue, 26 Apr 2022 10:19:59 +0200
Message-Id: <20220426081750.184589989@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Khazhismel Kumykov <khazhy@google.com>

commit ccf16413e520164eb718cf8b22a30438da80ff23 upstream.

kernel ulong and compat_ulong_t may not be same width. Use type directly
to eliminate mismatches.

This would result in truncation rather than EFBIG for 32bit mode for
large disks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -629,7 +629,7 @@ long compat_blkdev_ioctl(struct file *fi
 		return compat_put_long(argp,
 			(bdev->bd_disk->bdi->ra_pages * PAGE_SIZE) / 512);
 	case BLKGETSIZE:
-		if (bdev_nr_sectors(bdev) > ~0UL)
+		if (bdev_nr_sectors(bdev) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(argp, bdev_nr_sectors(bdev));
 


