Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EDF44C743
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhKJSth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:49:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhKJSsc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:48:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C62A661250;
        Wed, 10 Nov 2021 18:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569944;
        bh=FJWUPVMHT2DM3DWqrQBzZ1SeN2TtCRd6e/zHpoXnl3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUyCjs9lzBVGEMRR8FAhRc5cmag/sh5Ko+7Iil66QPCwQLDd3ChURgrsP/8ne2UBr
         7XazCzJgKFNmThVHCCca0C5bB62sa3sGojd9TmbEtWP/cPWRWjqWMA1C/OdpnkXyBE
         tEwFDMqxIS8cxGqq9uBHlOkgoKqsXYYZ8zJpyCok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        syzbot+6fc7fb214625d82af7d1@syzkaller.appspotmail.com
Subject: [PATCH 4.14 14/22] isofs: Fix out of bound access for corrupted isofs image
Date:   Wed, 10 Nov 2021 19:43:34 +0100
Message-Id: <20211110182003.124943663@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.666244094@linuxfoundation.org>
References: <20211110182002.666244094@linuxfoundation.org>
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
@@ -1326,6 +1326,8 @@ static int isofs_read_inode(struct inode
 
 	de = (struct iso_directory_record *) (bh->b_data + offset);
 	de_len = *(unsigned char *) de;
+	if (de_len < sizeof(struct iso_directory_record))
+		goto fail;
 
 	if (offset + de_len > bufsize) {
 		int frag1 = bufsize - offset;


