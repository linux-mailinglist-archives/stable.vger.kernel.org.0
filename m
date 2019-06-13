Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209A9441CE
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbfFMQQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731149AbfFMIlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:41:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E1FB21473;
        Thu, 13 Jun 2019 08:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415276;
        bh=ps35N8dXyDT8sBbLKr32CXqTHpRjXSBruuA29nDeFZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3ilWpdKktSZi8GH7Jeqk+XuOkO/wpmztXezIcj/qvuPIEYzNTww4tL7mVxUvxBAw
         Pd6Ivu9kGbBbGgoOC9tEBdSev2NDSxqEtx3jc4EIgRj4/ii3jvYLLSaCzOSjydOTup
         MDvyVApfYW2Qm2G3YKoK2vX0P69hywRQuzI05JmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kirill Smelkov <kirr@nexedi.com>,
        Han-Wen Nienhuys <hanwen@google.com>,
        Jakob Unterwurzacher <jakobunt@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 066/118] fuse: retrieve: cap requested size to negotiated max_write
Date:   Thu, 13 Jun 2019 10:33:24 +0200
Message-Id: <20190613075647.675913876@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
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
@@ -1681,7 +1681,7 @@ static int fuse_retrieve(struct fuse_con
 	offset = outarg->offset & ~PAGE_MASK;
 	file_size = i_size_read(inode);
 
-	num = outarg->size;
+	num = min(outarg->size, fc->max_write);
 	if (outarg->offset > file_size)
 		num = 0;
 	else if (outarg->offset + num > file_size)


