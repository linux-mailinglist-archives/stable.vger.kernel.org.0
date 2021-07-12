Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738E93C4453
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 08:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhGLGS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhGLGSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 419BF610CC;
        Mon, 12 Jul 2021 06:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070534;
        bh=RKCksdDGwLymVcBFshtnBeAAX8F3JVsR9nUuhNJcYC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JnZa/OInq7313WaSPd1bESULDFe5TQheVGTzcjfDiB3rkkzu29z8neGu4NdpPmR1D
         VePhi9zSXEuY4ZE+S0qp2krToAk3LTmwpi0x2TnoDRIJ6GbCuUr8+mwNmonF2fkWjv
         wKdL5N7jhf1vk2+pGNPlgJbk+xbXJCit0DYW9clM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 024/348] btrfs: clear defrag status of a root if starting transaction fails
Date:   Mon, 12 Jul 2021 08:06:48 +0200
Message-Id: <20210712060703.537239582@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
@@ -1274,8 +1274,10 @@ int btrfs_defrag_root(struct btrfs_root
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		ret = btrfs_defrag_leaves(trans, root);
 


