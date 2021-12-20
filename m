Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A991147AD5C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhLTOv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41788 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237837AbhLTOtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66F9E6118D;
        Mon, 20 Dec 2021 14:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5331FC36AE7;
        Mon, 20 Dec 2021 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011794;
        bh=q1TFdYdXeDZmbA18JLsxx/ila1y1uzXHoXJg7nRJ6yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lD+70ZFQiADYVixoBlIRvn/SF7bIXKXqrdNQaKGLnodc0o1eYcocA0wJRgYoSk0x2
         foSD1gV44DV73jYImvjzMtVkA5jH5KKtdG6GiptgWgH65ddAOa2Brv1Ma5sZci83i9
         0RkAQyLtCWtAOIjhpoVDUN6P1+ixlC2oHhmGu0Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 76/99] btrfs: fix double free of anon_dev after failure to create subvolume
Date:   Mon, 20 Dec 2021 15:34:49 +0100
Message-Id: <20211220143031.951042776@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 33fab972497ae66822c0b6846d4f9382938575b6 upstream.

When creating a subvolume, at create_subvol(), we allocate an anonymous
device and later call btrfs_get_new_fs_root(), which in turn just calls
btrfs_get_root_ref(). There we call btrfs_init_fs_root() which assigns
the anonymous device to the root, but if after that call there's an error,
when we jump to 'fail' label, we call btrfs_put_root(), which frees the
anonymous device and then returns an error that is propagated back to
create_subvol(). Than create_subvol() frees the anonymous device again.

When this happens, if the anonymous device was not reallocated after
the first time it was freed with btrfs_put_root(), we get a kernel
message like the following:

  (...)
  [13950.282466] BTRFS: error (device dm-0) in create_subvol:663: errno=-5 IO failure
  [13950.283027] ida_free called for id=65 which is not allocated.
  [13950.285974] BTRFS info (device dm-0): forced readonly
  (...)

If the anonymous device gets reallocated by another btrfs filesystem
or any other kernel subsystem, then bad things can happen.

So fix this by setting the root's anonymous device to 0 at
btrfs_get_root_ref(), before we call btrfs_put_root(), if an error
happened.

Fixes: 2dfb1e43f57dd3 ("btrfs: preallocate anon block device at first phase of snapshot creation")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1603,6 +1603,14 @@ again:
 	}
 	return root;
 fail:
+	/*
+	 * If our caller provided us an anonymous device, then it's his
+	 * responsability to free it in case we fail. So we have to set our
+	 * root's anon_dev to 0 to avoid a double free, once by btrfs_put_root()
+	 * and once again by our caller.
+	 */
+	if (anon_dev)
+		root->anon_dev = 0;
 	btrfs_put_root(root);
 	return ERR_PTR(ret);
 }


