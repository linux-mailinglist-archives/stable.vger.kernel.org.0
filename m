Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98824147D0A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbgAXJ42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:56:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731098AbgAXJ42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:56:28 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDF6620718;
        Fri, 24 Jan 2020 09:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859787;
        bh=GT79FooQqGTj/KIsUOKgKa9dqw9ObSDXS8vyvK6kufQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFl0b07mu7Y8f2ycp/M7hxGt9nbovQe1ilM/zR0XQ3BeyYpHd01flzM3ceWlHf/NS
         SvO81fxZnz8rP3g6KmbZu4DLQCzXzfy/KsEJjxoJ+jtRHTEPHSF5AIBr02fb7xlTSS
         wP/ZCTA7Of/yCsrDOPULcS6eIC2WlJajF7eI9Jpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 195/343] afs: Fix the afs.cell and afs.volume xattr handlers
Date:   Fri, 24 Jan 2020 10:30:13 +0100
Message-Id: <20200124092945.633348648@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit c73aa4102f5b9f261a907c3b3df94cd2c478504d ]

Fix the ->get handlers for the afs.cell and afs.volume xattrs to pass the
source data size to memcpy() rather than target buffer size.

Overcopying the source data occasionally causes the kernel to oops.

Fixes: d3e3b7eac886 ("afs: Add metadata xattrs")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
index 2830e4f48d854..7c6b62a94e7e7 100644
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -50,7 +50,7 @@ static int afs_xattr_get_cell(const struct xattr_handler *handler,
 		return namelen;
 	if (namelen > size)
 		return -ERANGE;
-	memcpy(buffer, cell->name, size);
+	memcpy(buffer, cell->name, namelen);
 	return namelen;
 }
 
@@ -104,7 +104,7 @@ static int afs_xattr_get_volume(const struct xattr_handler *handler,
 		return namelen;
 	if (namelen > size)
 		return -ERANGE;
-	memcpy(buffer, volname, size);
+	memcpy(buffer, volname, namelen);
 	return namelen;
 }
 
-- 
2.20.1



