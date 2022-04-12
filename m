Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34DB4FD513
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351892AbiDLIBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357556AbiDLHk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797EA2B188;
        Tue, 12 Apr 2022 00:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7AE76176E;
        Tue, 12 Apr 2022 07:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB33FC385A1;
        Tue, 12 Apr 2022 07:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747761;
        bh=FuKjtPKoVK7gpsVJPs78/XrHFLnI2blZAVO9LBmv2XM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTdVU9+vvtHQ8OH0gZ9w2ltlQrBZVyxwjQBTPFqkhIY2MY75aQsdnMWR+oKrysHwY
         0Q/c1n6eZJ+IKXF8wcqLkaR1osnT8RnGFzr4eFyMfDRKH+r869K9ROYKCDbiTDCQ1u
         V1HQwboZARh9d+Z6Y6cfZ2YPKVsEXFYc6T9Ssgqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinghua Jin <qhjin.dev@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Jan Kara <jack@suse.cz>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 155/343] minix: fix bug when opening a file with O_DIRECT
Date:   Tue, 12 Apr 2022 08:29:33 +0200
Message-Id: <20220412062955.850949267@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Qinghua Jin <qhjin.dev@gmail.com>

[ Upstream commit 9ce3c0d26c42d279b6c378a03cd6a61d828f19ca ]

Testcase:
1. create a minix file system and mount it
2. open a file on the file system with O_RDWR|O_CREAT|O_TRUNC|O_DIRECT
3. open fails with -EINVAL but leaves an empty file behind. All other
   open() failures don't leave the failed open files behind.

It is hard to check the direct_IO op before creating the inode.  Just as
ext4 and btrfs do, this patch will resolve the issue by allowing to
create the file with O_DIRECT but returning error when writing the file.

Link: https://lkml.kernel.org/r/20220107133626.413379-1-qhjin.dev@gmail.com
Signed-off-by: Qinghua Jin <qhjin.dev@gmail.com>
Reported-by: Colin Ian King <colin.king@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index a71f1cf894b9..d4bd94234ef7 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -447,7 +447,8 @@ static const struct address_space_operations minix_aops = {
 	.writepage = minix_writepage,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
-	.bmap = minix_bmap
+	.bmap = minix_bmap,
+	.direct_IO = noop_direct_IO
 };
 
 static const struct inode_operations minix_symlink_inode_operations = {
-- 
2.35.1



