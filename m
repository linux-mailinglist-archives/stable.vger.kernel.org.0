Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EBC6D47C3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjDCOXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbjDCOXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDED2D7CC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1553B81BC0
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A21DC433EF;
        Mon,  3 Apr 2023 14:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531766;
        bh=rfVv/EPGmOJfARn5s/5qZBQLEMqSzOYVFm85EhrcRl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGeRd0p6kzu/uhtfhBtiIYe2dHINInVgbtOqril6LxZAVn1U/VTzKSGChhSjS+7e/
         aMYMLBOUO+KmMatacCiCpwlr2ZNSJT9TLfBLRLaLlLHywNXcyyiYSRCsUY+HU7P51X
         YMMk8GzywhOtpWzuTg2skvwGN43zstGaHc2CA/zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.4 104/104] gfs2: Always check inode size of inline inodes
Date:   Mon,  3 Apr 2023 16:09:36 +0200
Message-Id: <20230403140408.234088998@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
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
[pchelkin@ispras.ru: adjust the inode variable inside gfs2_dinode_in with
the format used before upstream commit 7db354444ad8 ("gfs2: Cosmetic
gfs2_dinode_{in,out} cleanup")]
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/aops.c  |    2 --
 fs/gfs2/bmap.c  |    3 ---
 fs/gfs2/glops.c |    3 +++
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -456,8 +456,6 @@ static int stuffed_readpage(struct gfs2_
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -70,9 +70,6 @@ static int gfs2_unstuffer_page(struct gf
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
@@ -411,6 +411,9 @@ static int gfs2_dinode_in(struct gfs2_in
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
+	if (gfs2_is_stuffed(ip) && ip->i_inode.i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
 	if (S_ISREG(ip->i_inode.i_mode))
 		gfs2_set_aops(&ip->i_inode);
 


