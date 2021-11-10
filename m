Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE444C713
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhKJSr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:47:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:46910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232956AbhKJSrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:47:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0927061211;
        Wed, 10 Nov 2021 18:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569883;
        bh=tSw2FqKT9juOpAu73M2zBDuG7EHlnsXg5BghqluUKOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8rCewP3hES1QdBiAKRsC+YT9TzF8Az84BFFXmR8zH7K/ExtYenPsxPDnguI1E2+d
         EY8H6EQxbHiCM9RJ3eK65OL3aSjJY22ukf/It8K8oItANxD2S4kKTcgmdlSiquv3A6
         b04eZpERmdzZNFMRL4Dyfl5CJxvxUJGSR1RJpL4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        syzbot+6fc7fb214625d82af7d1@syzkaller.appspotmail.com
Subject: [PATCH 4.9 14/22] isofs: Fix out of bound access for corrupted isofs image
Date:   Wed, 10 Nov 2021 19:43:21 +0100
Message-Id: <20211110182002.047574878@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
References: <20211110182001.579561273@linuxfoundation.org>
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
@@ -1265,6 +1265,8 @@ static int isofs_read_inode(struct inode
 
 	de = (struct iso_directory_record *) (bh->b_data + offset);
 	de_len = *(unsigned char *) de;
+	if (de_len < sizeof(struct iso_directory_record))
+		goto fail;
 
 	if (offset + de_len > bufsize) {
 		int frag1 = bufsize - offset;


