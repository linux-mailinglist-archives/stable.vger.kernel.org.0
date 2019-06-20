Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69D4D8E6
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfFTS3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbfFTSDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8C921479;
        Thu, 20 Jun 2019 18:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053801;
        bh=dXL5b03flAPcpcuWlTJ2U+RH4K9Xbh+O5tOkr79hCb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTvVlQKCRV2rzOYciYmVRtbU+39Ic3NXScuZec6a/Mtd7WjyO65OFYypeKmD+rEHT
         udphNgNq8MAPna9HAZxxt/vxoSC/HFQdf5juzA5KMeFPPV3GzXoXKRRNI57ZsmC0ID
         Wm5kVI32vPy6ZLJQ4YhsKvr1KXJTVQlizkgOUFH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Smelkov <kirr@nexedi.com>,
        Han-Wen Nienhuys <hanwen@google.com>,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 031/117] fuse: retrieve: cap requested size to negotiated max_write
Date:   Thu, 20 Jun 2019 19:56:05 +0200
Message-Id: <20190620174353.861621759@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7640682e67b33cab8628729afec8ca92b851394f ]

FUSE filesystem server and kernel client negotiate during initialization
phase, what should be the maximum write size the client will ever issue.
Correspondingly the filesystem server then queues sys_read calls to read
requests with buffer capacity large enough to carry request header + that
max_write bytes. A filesystem server is free to set its max_write in
anywhere in the range between [1*page, fc->max_pages*page]. In particular
go-fuse[2] sets max_write by default as 64K, wheres default fc->max_pages
corresponds to 128K. Libfuse also allows users to configure max_write, but
by default presets it to possible maximum.

If max_write is < fc->max_pages*page, and in NOTIFY_RETRIEVE handler we
allow to retrieve more than max_write bytes, corresponding prepared
NOTIFY_REPLY will be thrown away by fuse_dev_do_read, because the
filesystem server, in full correspondence with server/client contract, will
be only queuing sys_read with ~max_write buffer capacity, and
fuse_dev_do_read throws away requests that cannot fit into server request
buffer. In turn the filesystem server could get stuck waiting indefinitely
for NOTIFY_REPLY since NOTIFY_RETRIEVE handler returned OK which is
understood by clients as that NOTIFY_REPLY was queued and will be sent
back.

Cap requested size to negotiate max_write to avoid the problem.  This
aligns with the way NOTIFY_RETRIEVE handler works, which already
unconditionally caps requested retrieve size to fuse_conn->max_pages.  This
way it should not hurt NOTIFY_RETRIEVE semantic if we return less data than
was originally requested.

Please see [1] for context where the problem of stuck filesystem was hit
for real, how the situation was traced and for more involving patch that
did not make it into the tree.

[1] https://marc.info/?l=linux-fsdevel&m=155057023600853&w=2
[2] https://github.com/hanwen/go-fuse

Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
Cc: Han-Wen Nienhuys <hanwen@google.com>
Cc: Jakob Unterwurzacher <jakobunt@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1668,7 +1668,7 @@ static int fuse_retrieve(struct fuse_con
 	offset = outarg->offset & ~PAGE_MASK;
 	file_size = i_size_read(inode);
 
-	num = outarg->size;
+	num = min(outarg->size, fc->max_write);
 	if (outarg->offset > file_size)
 		num = 0;
 	else if (outarg->offset + num > file_size)


