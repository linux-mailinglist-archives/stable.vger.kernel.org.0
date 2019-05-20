Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833D023619
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389860AbfETM3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389274AbfETM3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4189320675;
        Mon, 20 May 2019 12:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355356;
        bh=WupPEC+hMOVZof/t7zKnzKz3HLKKT+Ri07zHZ5ruEwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zsawyAnsmMRtU4loequQAmOE2IHEl/rtOzObput+vnlkispsb1PS8Hvf0P8BnhdIe
         FYRZYmj//hl6p1cwVk2u6ExJglBTkznwuEZ8Qq8N36hswzo0gkb3pYVQKm7ggsIath
         7NOXS92USn9s2Py5zobN5wZUrSXe2bbIhfNXsfOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 5.0 087/123] ext4: actually request zeroing of inode table after grow
Date:   Mon, 20 May 2019 14:14:27 +0200
Message-Id: <20190520115250.679695477@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kirill Tkhai <ktkhai@virtuozzo.com>

commit 310a997fd74de778b9a4848a64be9cda9f18764a upstream.

It is never possible, that number of block groups decreases,
since only online grow is supported.

But after a growing occured, we have to zero inode tables
for just created new block groups.

Fixes: 19c5246d2516 ("ext4: add new online resize interface")
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -977,7 +977,7 @@ mext_out:
 		if (err == 0)
 			err = err2;
 		mnt_drop_write_file(filp);
-		if (!err && (o_group > EXT4_SB(sb)->s_groups_count) &&
+		if (!err && (o_group < EXT4_SB(sb)->s_groups_count) &&
 		    ext4_has_group_desc_csum(sb) &&
 		    test_opt(sb, INIT_INODE_TABLE))
 			err = ext4_register_li_request(sb, o_group);


