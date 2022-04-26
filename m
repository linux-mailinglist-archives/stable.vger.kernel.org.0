Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C513F50F3D3
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344724AbiDZI1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344730AbiDZI1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4F442EF3;
        Tue, 26 Apr 2022 01:23:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 485B9B81CF3;
        Tue, 26 Apr 2022 08:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34CBC385A0;
        Tue, 26 Apr 2022 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961405;
        bh=s3TZoSOvbMjpJ9+4y6K6ChvHNGTS8DnMQhNCoxABoF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIjjcRCKnnZOgB3r7L7bjOMt3JMRllaSajTJ+ZTM/LUOhTMKr0EcxS28j1pi086YC
         FjZwjF7hnxKozSUFc1y7rGAo+zQLQj6u5C6ivM1lidWzW3IYAoo7gyfR59oXZOYWeL
         ngjufmJkeeNJY7wAk0rPX14cgO6iXt+iY7iDZ/ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khazhismel Kumykov <khazhy@google.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 24/24] block/compat_ioctl: fix range check in BLKGETSIZE
Date:   Tue, 26 Apr 2022 10:21:18 +0200
Message-Id: <20220426081732.085252639@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081731.370823950@linuxfoundation.org>
References: <20220426081731.370823950@linuxfoundation.org>
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
 block/compat_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -394,7 +394,7 @@ long compat_blkdev_ioctl(struct file *fi
 		return 0;
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
-		if ((size >> 9) > ~0UL)
+		if ((size >> 9) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(arg, size >> 9);
 


