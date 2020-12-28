Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D516A2E6505
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389304AbgL1NfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:35:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389295AbgL1NfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:35:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B69205CB;
        Mon, 28 Dec 2020 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162473;
        bh=DmmkrcitPC7QTS2tPwHnuEaW7XBeQ9vxE83FylVSuew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBKJvHbG9kncm8cUfPKZ4meWGEeWNHF5G2UPXPkf1ofMX//YkAcWAYmyRKzBlfWMj
         5CFn6QKN9XNvDoDDS+I/AyutBKVwDFyt7MFKGL6rL5lAWKHOSfQNFP1WQurlMX1+oY
         7Ziu7YsfRytV65jlZqVRnrhm3iqYIzeIiO/h+uQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH 4.19 313/346] jfs: Fix array index bounds check in dbAdjTree
Date:   Mon, 28 Dec 2020 13:50:32 +0100
Message-Id: <20201228124934.928641332@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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


