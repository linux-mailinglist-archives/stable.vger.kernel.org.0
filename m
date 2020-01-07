Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D892B133391
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgAGVEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:04:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729079AbgAGVEn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:04:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 687CF20678;
        Tue,  7 Jan 2020 21:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431082;
        bh=yvSUdJhR7bHfZSJeyF6n2xh+oZ3xjRsEN5JHfOLFMfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgsJ1A/f/ZY9gdICzS8cx3OdJER0eUM9GmyxrbKJPmszBqMh2rZCPfGv1/QmhYujx
         GCq/QgnKgYx+o0i5XErXdf5GK8M3X7akPhDuEJc7eqmZA6AtVnXEHr1Cmes68reifr
         gNKWHLuhiZqfHijsbQAYBISIcXkR4g89Jg4S/o6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jonathan Billings <jsbillings@jsbillings.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/115] afs: Fix creation calls in the dynamic root to fail with EOPNOTSUPP
Date:   Tue,  7 Jan 2020 21:53:56 +0100
Message-Id: <20200107205259.109355598@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1da4bd9f9d187f53618890d7b66b9628bbec3c70 ]

Fix the lookup method on the dynamic root directory such that creation
calls, such as mkdir, open(O_CREAT), symlink, etc. fail with EOPNOTSUPP
rather than failing with some odd error (such as EEXIST).

lookup() itself tries to create automount directories when it is invoked.
These are cached locally in RAM and not committed to storage.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Jonathan Billings <jsbillings@jsbillings.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dynroot.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/afs/dynroot.c b/fs/afs/dynroot.c
index f29c6dade7f6..069273a2483f 100644
--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -145,6 +145,9 @@ static struct dentry *afs_dynroot_lookup(struct inode *dir, struct dentry *dentr
 
 	ASSERTCMP(d_inode(dentry), ==, NULL);
 
+	if (flags & LOOKUP_CREATE)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (dentry->d_name.len >= AFSNAMEMAX) {
 		_leave(" = -ENAMETOOLONG");
 		return ERR_PTR(-ENAMETOOLONG);
-- 
2.20.1



