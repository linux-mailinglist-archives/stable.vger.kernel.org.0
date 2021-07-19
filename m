Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E209C3CD8E1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242925AbhGSOZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:36934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243802AbhGSOYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:24:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ED0A60FDC;
        Mon, 19 Jul 2021 15:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707047;
        bh=hORQOAzlkDXrcapcdCZ3EVs7d3Y8WAfK2ElV6moD+Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zel/qDzgkWUm2VOLvDJ/ruaoaw81NDgC5rRecPNV5ta/sJqzB3O2+Gms+umHzplaf
         A0rkMn2aEjBwqnk9ZJB9fqbf0SKfB9fBY4fiC8e+rh2Gb/kzFwoWi8WSaJ4Spi80Qw
         BwPI8rIbOKRDqHKyWIJ1nKNu2Ep6v+8Uf0bNEXAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 011/245] btrfs: clear defrag status of a root if starting transaction fails
Date:   Mon, 19 Jul 2021 16:49:13 +0200
Message-Id: <20210719144940.752704207@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 6819703f5a365c95488b07066a8744841bf14231 upstream.

The defrag loop processes leaves in batches and starting transaction for
each. The whole defragmentation on a given root is protected by a bit
but in case the transaction fails, the bit is not cleared

In case the transaction fails the bit would prevent starting
defragmentation again, so make sure it's cleared.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1287,8 +1287,10 @@ int btrfs_defrag_root(struct btrfs_root
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		ret = btrfs_defrag_leaves(trans, root);
 


