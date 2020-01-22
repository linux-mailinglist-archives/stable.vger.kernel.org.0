Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2947B1455FB
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgAVNST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbgAVNSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:18:18 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75CA72467A;
        Wed, 22 Jan 2020 13:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699098;
        bh=3JLCLRkSYS0RorDnWGU+Xzdr3ilyL6KOkC6l7RNd9RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l4bAKZnDlyT1MumWqD1H242C7YINzrLjJqeJhEkJ5E5XZBWL4l5VYdbD8IcXYusf
         GIbrfPqv4PWIEmN8WAIBoEil+CfF5kv45gSdME3JevfeGgG0nNzMKxgWyJTj9MQC1Z
         qDEXfpWGkZR2viZWLmyABtNP0ZKK6oB1C0UyLTuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Holy <oholy@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 032/222] fuse: fix fuse_send_readpages() in the syncronous read case
Date:   Wed, 22 Jan 2020 10:26:58 +0100
Message-Id: <20200122092835.775601334@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit 7df1e988c723a066754090b22d047c3225342152 upstream.

Buffered read in fuse normally goes via:

 -> generic_file_buffered_read()
   -> fuse_readpages()
     -> fuse_send_readpages()
       ->fuse_simple_request() [called since v5.4]

In the case of a read request, fuse_simple_request() will return a
non-negative bytecount on success or a negative error value.  A positive
bytecount was taken to be an error and the PG_error flag set on the page.
This resulted in generic_file_buffered_read() falling back to ->readpage(),
which would repeat the read request and succeed.  Because of the repeated
read succeeding the bug was not detected with regression tests or other use
cases.

The FTP module in GVFS however fails the second read due to the
non-seekable nature of FTP downloads.

Fix by checking and ignoring positive return value from
fuse_simple_request().

Reported-by: Ondrej Holy <oholy@redhat.com>
Link: https://gitlab.gnome.org/GNOME/gvfs/issues/441
Fixes: 134831e36bbd ("fuse: convert readpages to simple api")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -882,6 +882,7 @@ static void fuse_send_readpages(struct f
 	struct fuse_args_pages *ap = &ia->ap;
 	loff_t pos = page_offset(ap->pages[0]);
 	size_t count = ap->num_pages << PAGE_SHIFT;
+	ssize_t res;
 	int err;
 
 	ap->args.out_pages = true;
@@ -896,7 +897,8 @@ static void fuse_send_readpages(struct f
 		if (!err)
 			return;
 	} else {
-		err = fuse_simple_request(fc, &ap->args);
+		res = fuse_simple_request(fc, &ap->args);
+		err = res < 0 ? res : 0;
 	}
 	fuse_readpages_end(fc, &ap->args, err);
 }


