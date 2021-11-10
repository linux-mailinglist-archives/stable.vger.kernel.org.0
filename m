Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8890B44C6E0
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhKJSq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhKJSq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:46:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD1506117A;
        Wed, 10 Nov 2021 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569820;
        bh=5EfOUOD+KyCEwEOWvfa6KJmBHxZfM7uksdNNfRxLa78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/AY2dsvrC9+/CsQ6yhYdzkl/ySWagDsmgfXGhJm0JZFKoKeJNkKUMif6iZzlycWY
         bUKBz85giBxCqmaHm/VRHDSmkDvmXrju3DNdduuiByedpVj2FdWwFCJ7rxB2qovsMV
         5DYO6X0AG3l9O+ZsEUd7B4sg957UJ320uZyv5ceQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        syzbot+6fc7fb214625d82af7d1@syzkaller.appspotmail.com
Subject: [PATCH 4.4 10/19] isofs: Fix out of bound access for corrupted isofs image
Date:   Wed, 10 Nov 2021 19:43:12 +0100
Message-Id: <20211110182001.592379236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.257350381@linuxfoundation.org>
References: <20211110182001.257350381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit e96a1866b40570b5950cda8602c2819189c62a48 upstream.

When isofs image is suitably corrupted isofs_read_inode() can read data
beyond the end of buffer. Sanity-check the directory entry length before
using it.

Reported-and-tested-by: syzbot+6fc7fb214625d82af7d1@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1268,6 +1268,8 @@ static int isofs_read_inode(struct inode
 
 	de = (struct iso_directory_record *) (bh->b_data + offset);
 	de_len = *(unsigned char *) de;
+	if (de_len < sizeof(struct iso_directory_record))
+		goto fail;
 
 	if (offset + de_len > bufsize) {
 		int frag1 = bufsize - offset;


