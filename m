Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E6744C7A3
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhKJSx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:53:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233809AbhKJSwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:52:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07DC761284;
        Wed, 10 Nov 2021 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570058;
        bh=yWUtxoyE1LvGsOIZ3XXOoR6YIwhHY8BKfdHADlxObWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd1mgIkwEjJ5czHlWkOQ9a+syQ9JwLL+xbBkqOvSFh63Lo7X+n8acgDhh00zCjCCx
         Q66vXjKqBouRtGUoy5fTtKihO/2qZJKKGspKLTzyIbtTlQRy2zfI9Pvz10fwmqghSY
         yw+UN839LxY4wW+yKdp9tcy1kiJkj96oTrIB0eSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        syzbot+6fc7fb214625d82af7d1@syzkaller.appspotmail.com
Subject: [PATCH 5.4 08/17] isofs: Fix out of bound access for corrupted isofs image
Date:   Wed, 10 Nov 2021 19:43:47 +0100
Message-Id: <20211110182002.480508660@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182002.206203228@linuxfoundation.org>
References: <20211110182002.206203228@linuxfoundation.org>
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
@@ -1328,6 +1328,8 @@ static int isofs_read_inode(struct inode
 
 	de = (struct iso_directory_record *) (bh->b_data + offset);
 	de_len = *(unsigned char *) de;
+	if (de_len < sizeof(struct iso_directory_record))
+		goto fail;
 
 	if (offset + de_len > bufsize) {
 		int frag1 = bufsize - offset;


