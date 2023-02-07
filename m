Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9509168D872
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjBGNJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjBGNJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B633A87B
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:09:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E142B613F8
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0059FC433EF;
        Tue,  7 Feb 2023 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775334;
        bh=aNbRP+T/2CloZxL9VgkOkLYd2XK9wox7j6Mx58K6hBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Flr5SkNx3ZO1L6lSmOcMHCZ5rGfhzsFlcsaABlLsk/sO96YVmcVReZdt69vb2aCmj
         nL4NcxRhJAHJwAyIFMHV7qHlSRomcO4fQ8M5QYdpwpP8NesOwhyLjGShEh45jpIU3V
         TPWvwVD/dwXYOAxNeQA26ymwjR0q7vdVMP8T3dSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.1 207/208] gfs2: Always check inode size of inline inodes
Date:   Tue,  7 Feb 2023 13:57:41 +0100
Message-Id: <20230207125643.901619474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 70376c7ff31221f1d21db5611d8209e677781d3a upstream.

Check if the inode size of stuffed (inline) inodes is within the allowed
range when reading inodes from disk (gfs2_dinode_in()).  This prevents
us from on-disk corruption.

The two checks in stuffed_readpage() and gfs2_unstuffer_page() that just
truncate inline data to the maximum allowed size don't actually make
sense, and they can be removed now as well.

Reported-by: syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/aops.c  |    2 --
 fs/gfs2/bmap.c  |    3 ---
 fs/gfs2/glops.c |    3 +++
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -427,8 +427,6 @@ static int stuffed_readpage(struct gfs2_
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -61,9 +61,6 @@ static int gfs2_unstuffer_page(struct gf
 		void *kaddr = kmap(page);
 		u64 dsize = i_size_read(inode);
  
-		if (dsize > gfs2_max_stuffed_size(ip))
-			dsize = gfs2_max_stuffed_size(ip);
-
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 		kunmap(page);
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -449,6 +449,9 @@ static int gfs2_dinode_in(struct gfs2_in
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
+	if (gfs2_is_stuffed(ip) && inode->i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
 	if (S_ISREG(inode->i_mode))
 		gfs2_set_aops(inode);
 


