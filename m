Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BCD2013B7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392891AbgFSQC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391293AbgFSPL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:11:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03259206FA;
        Fri, 19 Jun 2020 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579515;
        bh=tpqTBR22NuBLOVppNdw3lVPmj8gh6mVdDPt1DD3rdc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un05N9AQ9qw5HEoMNvX088PROxrn2fsEbb+BAMARBIitTXdq6PRnZHqmISaZsTvQu
         ZkN6Bihbh3NsnPeS03gkd+EvcQhn6Jp52+K87IvtHzUOVsUe6TKSt7MRYOcyOjgQ2J
         p+gedQlmgKgaqZor5DDqT63tPeBHeDRqHy324Fdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 165/261] btrfs: fix wrong file range cleanup after an error filling dealloc range
Date:   Fri, 19 Jun 2020 16:32:56 +0200
Message-Id: <20200619141657.809417840@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit e2c8e92d1140754073ad3799eb6620c76bab2078 upstream.

If an error happens while running dellaloc in COW mode for a range, we can
end up calling extent_clear_unlock_delalloc() for a range that goes beyond
our range's end offset by 1 byte, which affects 1 extra page. This results
in clearing bits and doing page operations (such as a page unlock) outside
our target range.

Fix that by calling extent_clear_unlock_delalloc() with an inclusive end
offset, instead of an exclusive end offset, at cow_file_range().

Fixes: a315e68f6e8b30 ("Btrfs: fix invalid attempt to free reserved space on failure to cow range")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1132,7 +1132,7 @@ out_unlock:
 	 */
 	if (extent_reserved) {
 		extent_clear_unlock_delalloc(inode, start,
-					     start + cur_alloc_size,
+					     start + cur_alloc_size - 1,
 					     locked_page,
 					     clear_bits,
 					     page_ops);


