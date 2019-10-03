Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773E3CA91E
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404613AbfJCQhf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404598AbfJCQhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B785222D1;
        Thu,  3 Oct 2019 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120653;
        bh=gYWn98+W0iMOhxY6UExOkZpfeZsrH6d61rogCQgFSzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYefEM7B1H9/R64N8p07u8Pci4h6GyrWbyqg9tF+MYWxLtWHf1yqr32gmOYrZbQQa
         bQsQYEjokRohdJtbiXd152RVG874mvomtOx+wu6qsV+5Mj2R5f6dVPEKc5LgRwN1dQ
         wDeRLtIP1+MNvRbaHgSUy9LNdqYxZ2YxK5ezGnP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@kernel.org>,
        Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.2 285/313] btrfs: adjust dirty_metadata_bytes after writeback failure of extent buffer
Date:   Thu,  3 Oct 2019 17:54:23 +0200
Message-Id: <20191003154601.153892981@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dennis Zhou <dennis@kernel.org>

commit eb5b64f142504a597d67e2109d603055ff765e52 upstream.

Before, if a eb failed to write out, we would end up triggering a
BUG_ON(). As of f4340622e0226 ("btrfs: extent_io: Move the BUG_ON() in
flush_write_bio() one level up"), we no longer BUG_ON(), so we should
make life consistent and add back the unwritten bytes to
dirty_metadata_bytes.

Fixes: f4340622e022 ("btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up")
CC: stable@vger.kernel.org # 5.2+
Reviewed-by: Filipe Manana <fdmanana@kernel.org>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3708,12 +3708,21 @@ err_unlock:
 static void set_btree_ioerr(struct page *page)
 {
 	struct extent_buffer *eb = (struct extent_buffer *)page->private;
+	struct btrfs_fs_info *fs_info;
 
 	SetPageError(page);
 	if (test_and_set_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags))
 		return;
 
 	/*
+	 * If we error out, we should add back the dirty_metadata_bytes
+	 * to make it consistent.
+	 */
+	fs_info = eb->fs_info;
+	percpu_counter_add_batch(&fs_info->dirty_metadata_bytes,
+				 eb->len, fs_info->dirty_metadata_batch);
+
+	/*
 	 * If writeback for a btree extent that doesn't belong to a log tree
 	 * failed, increment the counter transaction->eb_write_errors.
 	 * We do this because while the transaction is running and before it's


