Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BAEE66E8
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbfJ0VQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730810AbfJ0VQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:21 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26D7121783;
        Sun, 27 Oct 2019 21:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210980;
        bh=19DK42xMFXFJqJtl0anLycud8kNLzCwwMFq8BCP7JqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGEgiuvJtDYm/o8wMB7SWXWEjYeyFv+PW06uYKsEgNJVX6gfpthJC0PLiXFdwf3A6
         QEDJKKList3yhWIpZfZ2jwNQLyxVCUSWBZSOXsjBYApE6bJmYCSBsbs2P/55Mo0QCW
         NhrQYUClyX0GGYQo5jW8HeTPi9Eg8yZjf15s5yqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 85/93] Btrfs: add missing extents release on file extent cluster relocation error
Date:   Sun, 27 Oct 2019 22:01:37 +0100
Message-Id: <20191027203314.601523054@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 44db1216efe37bf670f8d1019cdc41658d84baf5 upstream.

If we error out when finding a page at relocate_file_extent_cluster(), we
need to release the outstanding extents counter on the relocation inode,
set by the previous call to btrfs_delalloc_reserve_metadata(), otherwise
the inode's block reserve size can never decrease to zero and metadata
space is leaked. Therefore add a call to btrfs_delalloc_release_extents()
in case we can't find the target page.

Fixes: 8b62f87bad9c ("Btrfs: rework outstanding_extents")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3187,6 +3187,8 @@ static int relocate_file_extent_cluster(
 			if (!page) {
 				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							PAGE_SIZE, true);
+				btrfs_delalloc_release_extents(BTRFS_I(inode),
+							PAGE_SIZE, true);
 				ret = -ENOMEM;
 				goto out;
 			}


