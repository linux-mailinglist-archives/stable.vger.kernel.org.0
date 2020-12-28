Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E8F2E67C9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbgL1Q2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730745AbgL1NHR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:07:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3A562242A;
        Mon, 28 Dec 2020 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160822;
        bh=DmmkrcitPC7QTS2tPwHnuEaW7XBeQ9vxE83FylVSuew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNsgvUF7HB5Y0Z9ir69JfCzBgyMjdxfxJWDeShS8U1L3ZbKcIY6nZpqg3s5K+FVIa
         jLGAmDUC9cNRQPmgZNg8/XLyNe3lGHydalB0fREkACw5NDCS08h2LU0ptY1yYRe4Bk
         etL9Xt+JT8bPbzRpE+zr5otPrGyi5SwK6iCrjm7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH 4.9 160/175] jfs: Fix array index bounds check in dbAdjTree
Date:   Mon, 28 Dec 2020 13:50:13 +0100
Message-Id: <20201228124900.995141218@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit c61b3e4839007668360ed8b87d7da96d2e59fc6c upstream.

Bounds checking tools can flag a bug in dbAdjTree() for an array index
out of bounds in dmt_stree. Since dmt_stree can refer to the stree in
both structures dmaptree and dmapctl, use the larger array to eliminate
the false positive.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jfs/jfs_dmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/jfs_dmap.h
+++ b/fs/jfs/jfs_dmap.h
@@ -196,7 +196,7 @@ typedef union dmtree {
 #define	dmt_leafidx	t1.leafidx
 #define	dmt_height	t1.height
 #define	dmt_budmin	t1.budmin
-#define	dmt_stree	t1.stree
+#define	dmt_stree	t2.stree
 
 /*
  *	on-disk aggregate disk allocation map descriptor.


