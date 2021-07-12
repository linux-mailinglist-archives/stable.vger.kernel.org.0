Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DACC3C50D5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbhGLHfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:35:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347059AbhGLHcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B3C61166;
        Mon, 12 Jul 2021 07:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074954;
        bh=T35JcdOkBA9hBEvgMeSfXdoKPCPo+yTypK9tFhMbz8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLYzj7JyKcXQUbg1up1c87f/hLEppEjSlK6gTjW1bkEhc9XTiIn8/e3rePFjdfdqf
         cmnHeyUJsnAQSG3mZtw+kRfU848YEDfoRYVCnw09xVlr/To0Ym7HylEDZNpbJvdPdA
         twFLuiwfOOVHC0OBOITaTkQ5rfMmpCfrBHEgPlKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.13 054/800] ext4: fix overflow in ext4_iomap_alloc()
Date:   Mon, 12 Jul 2021 08:01:17 +0200
Message-Id: <20210712060921.032968102@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit d0b040f5f2557b2f507c01e88ad8cff424fdc6a9 upstream.

A code in iomap alloc may overflow block number when converting it to
byte offset. Luckily this is mostly harmless as we will just use more
expensive method of writing using unwritten extents even though we are
writing beyond i_size.

Cc: stable@kernel.org
Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210412102333.2676-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3418,7 +3418,7 @@ retry:
 	 * i_disksize out to i_size. This could be beyond where direct I/O is
 	 * happening and thus expose allocated blocks to direct I/O reads.
 	 */
-	else if ((map->m_lblk * (1 << blkbits)) >= i_size_read(inode))
+	else if (((loff_t)map->m_lblk << blkbits) >= i_size_read(inode))
 		m_flags = EXT4_GET_BLOCKS_CREATE;
 	else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		m_flags = EXT4_GET_BLOCKS_IO_CREATE_EXT;


