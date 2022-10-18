Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC721601F34
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiJRAQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiJRAOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:14:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BCA804BF;
        Mon, 17 Oct 2022 17:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E8D3B81BEC;
        Tue, 18 Oct 2022 00:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA58C433C1;
        Tue, 18 Oct 2022 00:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051929;
        bh=YeOA7Ok1e9xtqYomYG4RiRf+i+TlMwc7RoKJgQGf3F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nptG1QcQVwH82a0s0mpA0mxDsfLMOfI2btHGEJw4NSb1IQhTQMsiix4sXjc+W3BY7
         tE+nKx55lGJ3Xt+Rh4n4YxhjEPVVBBxtVm9kB7w3cjV/FzDtrIRygOAgRjgHw5/GOJ
         Zm1nTLfq+EgUTr1y0kYdW49vHc22qcV7/pnV+La/oT94yQnMBEXpjztLJZEZtlHg5I
         OMbUD5piJ+z+l2RiHVD2CcRMoqCOIBZqhn89E9SEMvFPfx8m3FU82AsQLmVB7Moevk
         tYQqpU8mlJlQxN0zaG9LnGN+25kSP9a4J9wrjdEcklyZD7MInh1jL4m8Rgv8nsx+Or
         jfC1sKYHwE1Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Price <anprice@redhat.com>,
        syzbot+dcf33a7aae997956fe06@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.9 3/8] gfs2: Check sb_bsize_shift after reading superblock
Date:   Mon, 17 Oct 2022 20:11:57 -0400
Message-Id: <20221018001202.2732458-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001202.2732458-1-sashal@kernel.org>
References: <20221018001202.2732458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Price <anprice@redhat.com>

[ Upstream commit 670f8ce56dd0632dc29a0322e188cc73ce3c6b92 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 0e6fa91f4c8f..55daf740ab8d 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -171,7 +171,10 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 		pr_warn("Invalid superblock size\n");
 		return -EINVAL;
 	}
-
+	if (sb->sb_bsize_shift != ffs(sb->sb_bsize) - 1) {
+		pr_warn("Invalid block size shift\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.35.1

