Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0C03C24B9
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhGINYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232701AbhGINY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4A8613BC;
        Fri,  9 Jul 2021 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836905;
        bh=Sikym0kdgw7dT7cDHmDWw/WDEsb9PTkWnAYLN3Ac+XI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAvPNgh/dkTi1vEM7FqdaX72/XQRAuD7whf1MTkzEyPiAYxT5yVgWBs13Q9KzsORP
         8sjx+ov5VRFBxf2rQ+/CnV/n1T+GI+0LQegx9TObTpyqHtvXbmF1ftYMRxgFnq9rdU
         5lsk8IBNYvGrK6mZxbc5thuCCAAFzYkMvJQUCtpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tahsin Erdogan <trdgn@amazon.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 24/34] ext4: eliminate bogus error in ext4_data_block_valid_rcu()
Date:   Fri,  9 Jul 2021 15:20:40 +0200
Message-Id: <20210709131657.520194374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131644.969303901@linuxfoundation.org>
References: <20210709131644.969303901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tahsin Erdogan <trdgn@amazon.com>

Mainline commit ce9f24cccdc0 ("ext4: check journal inode extents more carefully")
enabled validity checks for journal inode's data blocks. This change got
ported to stable branches, but the backport for 4.19 has a bug where it will
flag an error even when system block entry's inode number matches journal
inode.

The way error is reported is also problematic because it updates the superblock
without following journaling rules. This may result in superblock checksum
errors if the superblock is in the process of being committed but has a
previously calculated checksum that doesn't include the bogus error update.

This patch eliminates the bogus error by trying to match how other backports
were implemented, which is to flag an error only when inode numbers mismatch.

Fixes: commit a75a5d163857 ("ext4: check journal inode extents more carefully")
Signed-off-by: Tahsin Erdogan <trdgn@amazon.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/block_validity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -171,8 +171,10 @@ static int ext4_data_block_valid_rcu(str
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
 		else {
+			if (entry->ino == ino)
+				return 1;
 			sbi->s_es->s_last_error_block = cpu_to_le64(start_blk);
-			return entry->ino == ino;
+			return 0;
 		}
 	}
 	return 1;


