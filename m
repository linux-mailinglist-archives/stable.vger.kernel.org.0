Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF6515795A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgBJNOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728511AbgBJMib (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:31 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0518A2085B;
        Mon, 10 Feb 2020 12:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338311;
        bh=t8k9Q5kSvPI0BJMlh67Q6NDygDBgDn1hjsy20lgJwd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WT2mHeufDTBR70CMWadTZZcX14W7k4/PX8qm6Ut1//83vN4fiihXV0I+wboklewSj
         KKLEoWKJQbQ8s4QzpRtcoqO31g4NT7PAXMS1Me5N3j+dVdTvJV0LlXRvgIaiiRfjgw
         JAezSAHw+Yh39y5Lo/DnzQtVdb1btClzOKvkTNu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 234/309] fix up iter on short count in fuse_direct_io()
Date:   Mon, 10 Feb 2020 04:33:10 -0800
Message-Id: <20200210122429.001837630@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit f658adeea45e430a24c7a157c3d5448925ac2038 upstream.

fuse_direct_io() can end up advancing the iterator by more than the amount
of data read or written.  This case is handled by the generic code if going
through ->direct_IO(), but not in the FOPEN_DIRECT_IO case.

Fix by reverting the extra bytes from the iterator in case of error or a
short count.

To test: install lxcfs, then the following testcase
  int fd = open("/var/lib/lxcfs/proc/uptime", O_RDONLY);
  sendfile(1, fd, NULL, 16777216);
  sendfile(1, fd, NULL, 16777216);
will spew WARN_ON() in iov_iter_pipe().

Reported-by: Peter Geis <pgwipeout@gmail.com>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: 3c3db095b68c ("fuse: use iov_iter based generic splice helpers")
Cc: <stable@vger.kernel.org> # v5.1
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1465,6 +1465,7 @@ ssize_t fuse_direct_io(struct fuse_io_pr
 		}
 		ia = NULL;
 		if (nres < 0) {
+			iov_iter_revert(iter, nbytes);
 			err = nres;
 			break;
 		}
@@ -1473,8 +1474,10 @@ ssize_t fuse_direct_io(struct fuse_io_pr
 		count -= nres;
 		res += nres;
 		pos += nres;
-		if (nres != nbytes)
+		if (nres != nbytes) {
+			iov_iter_revert(iter, nbytes - nres);
 			break;
+		}
 		if (count) {
 			max_pages = iov_iter_npages(iter, fc->max_pages);
 			ia = fuse_io_alloc(io, max_pages);


