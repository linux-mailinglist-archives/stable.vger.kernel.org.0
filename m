Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A228C59D88B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241320AbiHWJgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351207AbiHWJe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:34:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDAB96743;
        Tue, 23 Aug 2022 01:39:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92E6FB81C54;
        Tue, 23 Aug 2022 08:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8310C433D6;
        Tue, 23 Aug 2022 08:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243964;
        bh=YWBuCLLxymV+QhIOUC/mNWOy2xc9AppdGJvuTmckJK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1usutJx/KK5pMiLr+C3EIfX4EN4sk5f4lVeCO1cRKh6SdVV9hgcr10W+7nSy0r5mu
         wu/enQwK+i9hnRK0/+ywB9M8BzG0ruXMFeInWGHS+4oRVMieZwtfiT7Jpj49BhDGP2
         PtomYh0Ls78KgZmffNTj2PYLg0zpnJ6RkGd2WZnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Burkov <boris@bur.io>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 015/244] btrfs: reset RO counter on block group if we fail to relocate
Date:   Tue, 23 Aug 2022 10:22:54 +0200
Message-Id: <20220823080059.584832295@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -1575,9 +1575,11 @@ void btrfs_reclaim_bgs_work(struct work_
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


