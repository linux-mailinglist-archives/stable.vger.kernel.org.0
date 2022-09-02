Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9663D5AAE89
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiIBMZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236281AbiIBMYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:24:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EB2D418A;
        Fri,  2 Sep 2022 05:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34886B82A90;
        Fri,  2 Sep 2022 12:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977A5C433D7;
        Fri,  2 Sep 2022 12:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121352;
        bh=FXyEu8HN2IyznEME5orkFpYzDlXIChtKtF2NvCi/nnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SikpsFpo9mCYuYkgpUiPm0MAJoTWAmhbYhGVwuQkVJtTlLl+YmNvL8qsHnP4XIbKe
         WUFv82G86tAZB0afagBcHY8GC4oS0TK7Ku57vAigua5o2LSXZSbt10lUQY+mhLipeR
         iv32Q/sL6876UjVF8nRtuxxEqnLbjT6FRbnxwbcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Siddh Raman Pant <code@siddh.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com
Subject: [PATCH 4.14 22/42] loop: Check for overflow while configuring loop
Date:   Fri,  2 Sep 2022 14:18:46 +0200
Message-Id: <20220902121359.572611898@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121358.773776406@linuxfoundation.org>
References: <20220902121358.773776406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Siddh Raman Pant <code@siddh.me>

commit c490a0b5a4f36da3918181a8acdc6991d967c5f3 upstream.

The userspace can configure a loop using an ioctl call, wherein
a configuration of type loop_config is passed (see lo_ioctl()'s
case on line 1550 of drivers/block/loop.c). This proceeds to call
loop_configure() which in turn calls loop_set_status_from_info()
(see line 1050 of loop.c), passing &config->info which is of type
loop_info64*. This function then sets the appropriate values, like
the offset.

loop_device has lo_offset of type loff_t (see line 52 of loop.c),
which is typdef-chained to long long, whereas loop_info64 has
lo_offset of type __u64 (see line 56 of include/uapi/linux/loop.h).

The function directly copies offset from info to the device as
follows (See line 980 of loop.c):
	lo->lo_offset = info->lo_offset;

This results in an overflow, which triggers a warning in iomap_iter()
due to a call to iomap_iter_done() which has:
	WARN_ON_ONCE(iter->iomap.offset > iter->pos);

Thus, check for negative value during loop_set_status_from_info().

Bug report: https://syzkaller.appspot.com/bug?id=c620fe14aac810396d3c3edc9ad73848bf69a29e

Reported-and-tested-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Siddh Raman Pant <code@siddh.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220823160810.181275-1-code@siddh.me
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1212,6 +1212,11 @@ loop_get_status(struct loop_device *lo,
 	info->lo_number = lo->lo_number;
 	info->lo_offset = lo->lo_offset;
 	info->lo_sizelimit = lo->lo_sizelimit;
+
+	/* loff_t vars have been assigned __u64 */
+	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
+		return -EOVERFLOW;
+
 	info->lo_flags = lo->lo_flags;
 	memcpy(info->lo_file_name, lo->lo_file_name, LO_NAME_SIZE);
 	memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE);


