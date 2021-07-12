Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2293C5084
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243261AbhGLHd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344378AbhGLHbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D67860C40;
        Mon, 12 Jul 2021 07:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074942;
        bh=f0X9FEfT34snHlp2xIL0UeMYaSH+3yWQu0XgDNWT6UU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/aDJONjM0V/PyzsUQqRSbfMBTUzKqwNaeMN31MrilCrnfadIpHWfY+cfeDC83IN0
         qhUNtxtriGPLr1RLP+Z7r97RJ1/HdcBuYWnnwX/tzoshhqxs4KGa42hkaDH96w1s4R
         cmmFUzSJoMys0DkRPdc/4lUm3sQv4+urSt+N6qJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 051/800] btrfs: clear defrag status of a root if starting transaction fails
Date:   Mon, 12 Jul 2021 08:01:14 +0200
Message-Id: <20210712060920.614910827@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -1406,8 +1406,10 @@ int btrfs_defrag_root(struct btrfs_root
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		ret = btrfs_defrag_leaves(trans, root);
 


