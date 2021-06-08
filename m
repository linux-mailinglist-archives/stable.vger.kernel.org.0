Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192503A026D
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237018AbhFHTDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236597AbhFHTBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30882613C8;
        Tue,  8 Jun 2021 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177904;
        bh=k2qPFHPcTVZs+b5lRB1KvkgH8O3c6bJ1k/hJ3bM2atc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5QkWU3WcE6i2637ErpXj52IiNCC0Bwl7256kgq2y6WC4zVBimIGDYvFXgxHvN/F3
         kVT4agPrpWopBCiDS14DbBY8XO46M4lenpCfbDwbuz4VR6wlRYzpLfWrIgtqB946Ia
         tlCx1zPphXt/lh8WGRt1SCOxAPxw2DyCM1dsThRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 119/137] btrfs: mark ordered extent and inode with error if we fail to finish
Date:   Tue,  8 Jun 2021 20:27:39 +0200
Message-Id: <20210608175946.395967993@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit d61bec08b904cf171835db98168f82bc338e92e4 upstream.

While doing error injection testing I saw that sometimes we'd get an
abort that wouldn't stop the current transaction commit from completing.
This abort was coming from finish ordered IO, but at this point in the
transaction commit we should have gotten an error and stopped.

It turns out the abort came from finish ordered io while trying to write
out the free space cache.  It occurred to me that any failure inside of
finish_ordered_io isn't actually raised to the person doing the writing,
so we could have any number of failures in this path and think the
ordered extent completed successfully and the inode was fine.

Fix this by marking the ordered extent with BTRFS_ORDERED_IOERR, and
marking the mapping of the inode with mapping_set_error, so any callers
that simply call fdatawait will also get the error.

With this we're seeing the IO error on the free space inode when we fail
to do the finish_ordered_io.

CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2760,6 +2760,18 @@ out:
 	if (ret || truncated) {
 		u64 unwritten_start = start;
 
+		/*
+		 * If we failed to finish this ordered extent for any reason we
+		 * need to make sure BTRFS_ORDERED_IOERR is set on the ordered
+		 * extent, and mark the inode with the error if it wasn't
+		 * already set.  Any error during writeback would have already
+		 * set the mapping error, so we need to set it if we're the ones
+		 * marking this ordered extent as failed.
+		 */
+		if (ret && !test_and_set_bit(BTRFS_ORDERED_IOERR,
+					     &ordered_extent->flags))
+			mapping_set_error(ordered_extent->inode->i_mapping, -EIO);
+
 		if (truncated)
 			unwritten_start += logical_len;
 		clear_extent_uptodate(io_tree, unwritten_start, end, NULL);


