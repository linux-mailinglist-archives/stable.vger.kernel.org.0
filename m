Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3C86CC392
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjC1OzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjC1OzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE915D521
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56D536183C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F38C4339B;
        Tue, 28 Mar 2023 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015314;
        bh=xvku7KTGDzRFy4ccL0e8V2lFj3/LsgT4YJuHM8n+pIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcuy3V5Sz9YYcP3CJdWiRMzAWwfZtMNW5AWOA71tvVu8Ph6E675TIUwWH0MyBniMx
         IqKmKzM2fa0lVDxKQcWqOEbyEn2AE8PV//OSoFRobfmNT8ouxtyR2geB0sTwrkwR/4
         6VXIifWYLa37cwChKd7LHZ0Yl1vJ4b8YO2p1i5/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, yangerkun <yangerkun@huawei.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 237/240] dm crypt: add cond_resched() to dmcrypt_write()
Date:   Tue, 28 Mar 2023 16:43:20 +0200
Message-Id: <20230328142629.566386494@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit fb294b1c0ba982144ca467a75e7d01ff26304e2b upstream.

The loop in dmcrypt_write may be running for unbounded amount of time,
thus we need cond_resched() in it.

This commit fixes the following warning:

[ 3391.153255][   C12] watchdog: BUG: soft lockup - CPU#12 stuck for 23s! [dmcrypt_write/2:2897]
...
[ 3391.387210][   C12] Call trace:
[ 3391.390338][   C12]  blk_attempt_bio_merge.part.6+0x38/0x158
[ 3391.395970][   C12]  blk_attempt_plug_merge+0xc0/0x1b0
[ 3391.401085][   C12]  blk_mq_submit_bio+0x398/0x550
[ 3391.405856][   C12]  submit_bio_noacct+0x308/0x380
[ 3391.410630][   C12]  dmcrypt_write+0x1e4/0x208 [dm_crypt]
[ 3391.416005][   C12]  kthread+0x130/0x138
[ 3391.419911][   C12]  ret_from_fork+0x10/0x18

Reported-by: yangerkun <yangerkun@huawei.com>
Fixes: dc2676210c42 ("dm crypt: offload writes to thread")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1933,6 +1933,7 @@ pop_from_list:
 			io = crypt_io_from_node(rb_first(&write_tree));
 			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
+			cond_resched();
 		} while (!RB_EMPTY_ROOT(&write_tree));
 		blk_finish_plug(&plug);
 	}


