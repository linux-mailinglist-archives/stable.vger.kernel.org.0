Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1C6579A91
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbiGSMPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239676AbiGSMOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:14:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D85453D24;
        Tue, 19 Jul 2022 05:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 435FECE1BE5;
        Tue, 19 Jul 2022 12:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B218C341C6;
        Tue, 19 Jul 2022 12:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232342;
        bh=kPEkXdJG6toWpLYoJEYZmYyKfOgzuHoZaGUd+sZWypk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7Mum2+6tYaM0l3LFjc8UM5rh/s1bibntKmiOR7q9e3WXfk4XnrNZ+/6NfxKiznXA
         GildjW1UoALNH3bTUsaq3xYCah1/U2ysratjglbRatyfo6BA+HNjrz9CFwmtSLejXk
         ozrbN/hSAXzmUA06VAPIhKqlhZu4tcmpknV/fFEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique MARTINET <dominique.martinet@atmark-techno.com>,
        Christoph Hellwig <hch@lst.de>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 017/112] btrfs: return -EAGAIN for NOWAIT dio reads/writes on compressed and inline extents
Date:   Tue, 19 Jul 2022 13:53:10 +0200
Message-Id: <20220719114627.652374367@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit a4527e1853f8ff6e0b7c2dadad6268bd38427a31 upstream.

When doing a direct IO read or write, we always return -ENOTBLK when we
find a compressed extent (or an inline extent) so that we fallback to
buffered IO. This however is not ideal in case we are in a NOWAIT context
(io_uring for example), because buffered IO can block and we currently
have no support for NOWAIT semantics for buffered IO, so if we need to
fallback to buffered IO we should first signal the caller that we may
need to block by returning -EAGAIN instead.

This behaviour can also result in short reads being returned to user
space, which although it's not incorrect and user space should be able
to deal with partial reads, it's somewhat surprising and even some popular
applications like QEMU (Link tag #1) and MariaDB (Link tag #2) don't
deal with short reads properly (or at all).

The short read case happens when we try to read from a range that has a
non-compressed and non-inline extent followed by a compressed extent.
After having read the first extent, when we find the compressed extent we
return -ENOTBLK from btrfs_dio_iomap_begin(), which results in iomap to
treat the request as a short read, returning 0 (success) and waiting for
previously submitted bios to complete (this happens at
fs/iomap/direct-io.c:__iomap_dio_rw()). After that, and while at
btrfs_file_read_iter(), we call filemap_read() to use buffered IO to
read the remaining data, and pass it the number of bytes we were able to
read with direct IO. Than at filemap_read() if we get a page fault error
when accessing the read buffer, we return a partial read instead of an
-EFAULT error, because the number of bytes previously read is greater
than zero.

So fix this by returning -EAGAIN for NOWAIT direct IO when we find a
compressed or an inline extent.

Reported-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
Link: https://lore.kernel.org/linux-btrfs/YrrFGO4A1jS0GI0G@atmark-techno.com/
Link: https://jira.mariadb.org/browse/MDEV-27900?focusedCommentId=216582&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-216582
Tested-by: Dominique MARTINET <dominique.martinet@atmark-techno.com>
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7480,7 +7480,19 @@ static int btrfs_dio_iomap_begin(struct
 	if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
 	    em->block_start == EXTENT_MAP_INLINE) {
 		free_extent_map(em);
-		ret = -ENOTBLK;
+		/*
+		 * If we are in a NOWAIT context, return -EAGAIN in order to
+		 * fallback to buffered IO. This is not only because we can
+		 * block with buffered IO (no support for NOWAIT semantics at
+		 * the moment) but also to avoid returning short reads to user
+		 * space - this happens if we were able to read some data from
+		 * previous non-compressed extents and then when we fallback to
+		 * buffered IO, at btrfs_file_read_iter() by calling
+		 * filemap_read(), we fail to fault in pages for the read buffer,
+		 * in which case filemap_read() returns a short read (the number
+		 * of bytes previously read is > 0, so it does not return -EFAULT).
+		 */
+		ret = (flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOTBLK;
 		goto unlock_err;
 	}
 


