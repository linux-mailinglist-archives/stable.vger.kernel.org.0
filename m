Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C476261CF6
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgIHT26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731054AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5152024673;
        Tue,  8 Sep 2020 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579567;
        bh=MekHGvyuxks7mRtjZXsW9zksaxfXWlJYGDwuV95H3xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Az1TgRO9oEYJTNKB1Ij0p5Ni3JrMYe7W8Ar9hy+S9hB2ho1DZmlGSz335UewkUgt6
         niUa9IXu9rkL2LH1oGrUWxMtyGdDtdvuBGt4I+xnRjp0d5hn20NMSFHCkM7wZUIHi6
         9Tu6+IrVMFP3DdLdZGbcJpJ0V6sLBhxn3ziYQ9hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Richmond <t.d.richmond@gmail.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 131/186] btrfs: tree-checker: fix the error message for transid error
Date:   Tue,  8 Sep 2020 17:24:33 +0200
Message-Id: <20200908152247.989688426@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit f96d6960abbc52e26ad124e69e6815283d3e1674 upstream.

The error message for inode transid is the same as for inode generation,
which makes us unable to detect the real problem.

Reported-by: Tyler Richmond <t.d.richmond@gmail.com>
Fixes: 496245cac57e ("btrfs: tree-checker: Verify inode item")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -984,7 +984,7 @@ static int check_inode_item(struct exten
 	/* Note for ROOT_TREE_DIR_ITEM, mkfs could set its transid 0 */
 	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
 		inode_item_err(leaf, slot,
-			"invalid inode generation: has %llu expect [0, %llu]",
+			"invalid inode transid: has %llu expect [0, %llu]",
 			       btrfs_inode_transid(leaf, iitem), super_gen + 1);
 		return -EUCLEAN;
 	}


