Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7404A3A003A
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhFHSkz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235224AbhFHSjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA9961073;
        Tue,  8 Jun 2021 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177235;
        bh=lO3mVJln+IxH/bAsYlmlKebgQtj7tEKiC9rSVb3jzVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKyCtZjtVoBzumd7B1ytXpgRo6/V2zIUFpIBuZ7etQDt3BaHXKNbtuLYMHKKYRSif
         /fTTU3iUYxJrosOlSRetXkjmGA/X3X9WxF4U/i5Tz6EZgKpa8tXG6+wYJJkJyc5fJ7
         CDRGMKTvtjT2poscKwpcl/YximRGeW0zF50r6Xus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 35/58] btrfs: mark ordered extent and inode with error if we fail to finish
Date:   Tue,  8 Jun 2021 20:27:16 +0200
Message-Id: <20210608175933.432227186@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
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
@@ -3162,6 +3162,18 @@ out:
 	if (ret || truncated) {
 		u64 start, end;
 
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
 			start = ordered_extent->file_offset + logical_len;
 		else


