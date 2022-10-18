Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9050D601F4C
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiJRARZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiJRAP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:15:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68220895C4;
        Mon, 17 Oct 2022 17:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20D9E612D8;
        Tue, 18 Oct 2022 00:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E91DC433B5;
        Tue, 18 Oct 2022 00:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051797;
        bh=3WXnQWQsXlcnk4Gq3XwiR1UPflW6u08WFIL/aKLKN9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHCuGCrVjpCxQXawBhhif6wnKjnh54QUb89OuOdhG8826+A2vAvjr5QFZP7zHms4B
         TmVqdIwhPPP6msi+e37VsK3bMEXwqJjOhLqhtFqNk94tR59/E+/KEJXvkw9OpUFR7p
         QDymIEhindBuXZkVB5jUi5Pi+DrLtdJr+wCi+LuazOXL8jUgWJTNGE9ULmJMlWLxqr
         WkC+yFmBD5HU8Xyx9KsC1jK3ola18F66eLuo2K9qsK6IdMK+i2LnUYCIJCEgqhdc5N
         ZBCNE2TyG7/r6q6gkYL+sZwJz0GjlvvMG55E8C5ftJj13IAddmoh7OSJKp9Te51EN0
         Ume8QXmytrdrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Price <anprice@redhat.com>,
        syzbot+dcf33a7aae997956fe06@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, rpeterso@redhat.com,
        cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.15 09/21] gfs2: Check sb_bsize_shift after reading superblock
Date:   Mon, 17 Oct 2022 20:09:28 -0400
Message-Id: <20221018000940.2731329-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000940.2731329-1-sashal@kernel.org>
References: <20221018000940.2731329-1-sashal@kernel.org>
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
index f461a365eb38..fb3b48837083 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -180,7 +180,10 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
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
 
-- 
2.35.1

