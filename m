Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD726635953
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236238AbiKWKJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbiKWKIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:08:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE2985A12
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 347E861B5F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4653BC433C1;
        Wed, 23 Nov 2022 09:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197510;
        bh=63XDbQVIpCP1ETewV/6I4HleFyniamk3z1821b7Bh5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifw+vvGQT1qIAuhDgJDL4zdr0zXMSvk8EmoRHsElWLRcRmnzSHDm8oPPm9TyfIxK4
         Kv/EKwr3FtbZgdEBDomnrYWeh3bqOA82ntoORXBrRFK6WaTRcmxh+OmOP4xA2SVUpc
         XOVapY0spngyZWltetTwND0DMNNDO/CNTkjW6S/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+dcf33a7aae997956fe06@syzkaller.appspotmail.com,
        Andrew Price <anprice@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.0 303/314] gfs2: Check sb_bsize_shift after reading superblock
Date:   Wed, 23 Nov 2022 09:52:28 +0100
Message-Id: <20221123084639.285096318@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

commit 670f8ce56dd0632dc29a0322e188cc73ce3c6b92 upstream.

Fuzzers like to scribble over sb_bsize_shift but in reality it's very
unlikely that this field would be corrupted on its own. Nevertheless it
should be checked to avoid the possibility of messy mount errors due to
bad calculations. It's always a fixed value based on the block size so
we can just check that it's the expected value.

Tested with:

    mkfs.gfs2 -O -p lock_nolock /dev/vdb
    for i in 0 -1 64 65 32 33; do
        gfs2_edit -p sb field sb_bsize_shift $i /dev/vdb
        mount /dev/vdb /mnt/test && umount /mnt/test
    done

Before this patch we get a withdraw after

[   76.413681] gfs2: fsid=loop0.0: fatal: invalid metadata block
[   76.413681]   bh = 19 (type: exp=5, found=4)
[   76.413681]   function = gfs2_meta_buffer, file = fs/gfs2/meta_io.c, line = 492

and with UBSAN configured we also get complaints like

[   76.373395] UBSAN: shift-out-of-bounds in fs/gfs2/ops_fstype.c:295:19
[   76.373815] shift exponent 4294967287 is too large for 64-bit type 'long unsigned int'

After the patch, these complaints don't appear, mount fails immediately
and we get an explanation in dmesg.

Reported-by: syzbot+dcf33a7aae997956fe06@syzkaller.appspotmail.com
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/ops_fstype.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -178,7 +178,10 @@ static int gfs2_check_sb(struct gfs2_sbd
 		pr_warn("Invalid block size\n");
 		return -EINVAL;
 	}
-
+	if (sb->sb_bsize_shift != ffs(sb->sb_bsize) - 1) {
+		pr_warn("Invalid block size shift\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 


