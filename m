Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4DE31334AC
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgAGU5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:57:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:54974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbgAGU5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:57:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C1A2087F;
        Tue,  7 Jan 2020 20:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430654;
        bh=hFlnMAuexBIYadEPJ22i3/BbCHDfpBlVwdKylJjByHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSezIfPhipttu/ldV9kG7LA12t9eJ3Cu6VXtSJRis4TvP0i8der0fgn1Kv0/gm2rr
         3EfBGnjAnEZx47UrL+nuE5F731HzrNQVBlc6w9Umhy2Eil/Z+xgPGApSLWKF4YUtrF
         ihhBx9fV1kS4uHwE+JOP4cOJuOBYMoqt07GcHXRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Billings <jsbillings@jsbillings.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/191] afs: Fix mountpoint parsing
Date:   Tue,  7 Jan 2020 21:52:41 +0100
Message-Id: <20200107205335.192793624@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 158d58335393af3956a9c06f0816ee75ed1f1447 ]

Each AFS mountpoint has strings that define the target to be mounted.  This
is required to end in a dot that is supposed to be stripped off.  The
string can include suffixes of ".readonly" or ".backup" - which are
supposed to come before the terminal dot.  To add to the confusion, the "fs
lsmount" afs utility does not show the terminal dot when displaying the
string.

The kernel mount source string parser, however, assumes that the terminal
dot marks the suffix and that the suffix is always "" and is thus ignored.
In most cases, there is no suffix and this is not a problem - but if there
is a suffix, it is lost and this affects the ability to mount the correct
volume.

The command line mount command, on the other hand, is expected not to
include a terminal dot - so the problem doesn't arise there.

Fix this by making sure that the dot exists and then stripping it when
passing the string to the mount configuration.

Fixes: bec5eb614130 ("AFS: Implement an autocell mount capability [ver #2]")
Reported-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/mntpt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index f532d6d3bd28..79bc5f1338ed 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -126,7 +126,7 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 		if (src_as->cell)
 			ctx->cell = afs_get_cell(src_as->cell);
 
-		if (size > PAGE_SIZE - 1)
+		if (size < 2 || size > PAGE_SIZE - 1)
 			return -EINVAL;
 
 		page = read_mapping_page(d_inode(mntpt)->i_mapping, 0, NULL);
@@ -140,7 +140,9 @@ static int afs_mntpt_set_params(struct fs_context *fc, struct dentry *mntpt)
 		}
 
 		buf = kmap(page);
-		ret = vfs_parse_fs_string(fc, "source", buf, size);
+		ret = -EINVAL;
+		if (buf[size - 1] == '.')
+			ret = vfs_parse_fs_string(fc, "source", buf, size - 1);
 		kunmap(page);
 		put_page(page);
 		if (ret < 0)
-- 
2.20.1



