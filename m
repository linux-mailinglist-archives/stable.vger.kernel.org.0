Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C0E59D345
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbiHWIJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241631AbiHWII1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28B56CD01;
        Tue, 23 Aug 2022 01:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8987A611DD;
        Tue, 23 Aug 2022 08:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF20C433C1;
        Tue, 23 Aug 2022 08:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241918;
        bh=8u3wijuX4ETCv7WV+Sw2MPFZfSqAw8ruOcubsYmUVNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ufgXN2kNhqPSvt//z2dR5B/JrqNbMmTuXl5AqWJNlJKEGA6kxFQPWE5MJrMyoTDBv
         1tzK4BwdB+ZOJgmvOvrO3UI95QqCdGagCEH9OM+UsnyM2E0rnZab7JZINrOAbBHsGV
         c8faVeIMG/ejike7GqObDaHl3jiFDA8aweO+M/IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 019/365] btrfs: reset RO counter on block group if we fail to relocate
Date:   Tue, 23 Aug 2022 09:58:40 +0200
Message-Id: <20220823080119.003247301@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 74944c873602a3ed8d16ff7af3f64af80c0f9dac upstream.

With the automatic block group reclaim code we will preemptively try to
mark the block group RO before we start the relocation.  We do this to
make sure we should actually try to relocate the block group.

However if we hit an error during the actual relocation we won't clean
up our RO counter and the block group will remain RO.  This was observed
internally with file systems reporting less space available from df when
we had failed background relocations.

Fix this by doing the dec_ro in the error case.

Fixes: 18bb8bbf13c1 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1640,9 +1640,11 @@ void btrfs_reclaim_bgs_work(struct work_
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret)
+		if (ret) {
+			btrfs_dec_block_group_ro(bg);
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
+		}
 
 next:
 		btrfs_put_block_group(bg);


