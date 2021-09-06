Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236F2401C0C
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 15:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243169AbhIFNBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243437AbhIFNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 09:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F109361051;
        Mon,  6 Sep 2021 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933145;
        bh=ultJftXe2XkVYnmOk8UWy08LFzE4g3CVf/4sLRRd5MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSj7lnJd6IE1V2QxKlarFB3jMn4nTZiwdFxIAm1a3yA55AEl1/2YVGnFx3GbkpWty
         ISLpI+yXJQ6j8D2X0//vphDkQuTQUWmgq1aB9sQb/Jse2xqbViVQLpAmgKLrfP4X3i
         zDrxJ+lnz3e3SVmsK8rnYsjOTwQWqxiH2kcR2xTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        syzbot+13146364637c7363a7de@syzkaller.appspotmail.com,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.14 01/14] ext4: fix race writing to an inline_data file while its xattrs are changing
Date:   Mon,  6 Sep 2021 14:55:47 +0200
Message-Id: <20210906125448.209079113@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit a54c4613dac1500b40e4ab55199f7c51f028e848 upstream.

The location of the system.data extended attribute can change whenever
xattr_sem is not taken.  So we need to recalculate the i_inline_off
field since it mgiht have changed between ext4_write_begin() and
ext4_write_end().

This means that caching i_inline_off is probably not helpful, so in
the long run we should probably get rid of it and shrink the in-memory
ext4 inode slightly, but let's fix the race the simple way for now.

Cc: stable@kernel.org
Fixes: f19d5870cbf72 ("ext4: add normal write support for inline data")
Reported-by: syzbot+13146364637c7363a7de@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -750,6 +750,12 @@ int ext4_write_inline_data_end(struct in
 	ext4_write_lock_xattr(inode, &no_expand);
 	BUG_ON(!ext4_has_inline_data(inode));
 
+	/*
+	 * ei->i_inline_off may have changed since ext4_write_begin()
+	 * called ext4_try_to_write_inline_data()
+	 */
+	(void) ext4_find_inline_data_nolock(inode);
+
 	kaddr = kmap_atomic(page);
 	ext4_write_inline_data(inode, &iloc, kaddr, pos, len);
 	kunmap_atomic(kaddr);


