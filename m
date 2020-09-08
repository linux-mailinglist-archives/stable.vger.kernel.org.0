Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC308261E7B
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730882AbgIHTwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730722AbgIHPtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5C4924858;
        Tue,  8 Sep 2020 15:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579915;
        bh=pktw6c1CUBLPWEzsCjqwNvU46iLYhUlQd+syHKcIKAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ywn27CRiMCsSaO+im22FSJjGXz2GQOeTptJUfSuvNl4G1E3PtV6BPs3QjorjrCBj
         Z5qnIkDOIGqNBiBwYVZHh3KwN3O9DIz0B0LLMBw9pq+MUmVXCi07sUjElFQmHK2KkT
         nXeM+LJYR0H8eIJVuAHVb6L3c7EblI4xpsLjhyZc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyler Richmond <t.d.richmond@gmail.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 085/129] btrfs: tree-checker: fix the error message for transid error
Date:   Tue,  8 Sep 2020 17:25:26 +0200
Message-Id: <20200908152233.949756641@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
@@ -772,7 +772,7 @@ static int check_inode_item(struct exten
 	/* Here we use super block generation + 1 to handle log tree */
 	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
 		inode_item_err(fs_info, leaf, slot,
-			"invalid inode generation: has %llu expect (0, %llu]",
+			"invalid inode transid: has %llu expect [0, %llu]",
 			       btrfs_inode_generation(leaf, iitem),
 			       super_gen + 1);
 		return -EUCLEAN;


