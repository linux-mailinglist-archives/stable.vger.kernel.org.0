Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8C94A4499
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiAaLb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377371AbiAaL0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:26:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844AAC08ED7F;
        Mon, 31 Jan 2022 03:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 235ED61214;
        Mon, 31 Jan 2022 11:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B6C340F3;
        Mon, 31 Jan 2022 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627773;
        bh=3eUg+DdVMl/TLSTDuoDqr2fHFPY9qJFtVWk66ey+obU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUY5qjWGcvsyiHX1j+XRMGm2MDpaKRyByoGWHlvlzix/eyiC6vz4DVkfoaAY4tQ7d
         r7qu9TdgCHYmlrtvIhH6UkVysR0mkkJU2l23l95nMmVGSJLGuYIjNYKorKQ/taDRbx
         a7FcGysIdycg8fHmrD3agbxwPFQbcwv1Py8XKjRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 003/200] btrfs: allow defrag to be interruptible
Date:   Mon, 31 Jan 2022 11:54:26 +0100
Message-Id: <20220131105233.675281301@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit b767c2fc787e992daeadfff40d61c05f66c82da0 upstream.

During defrag, at btrfs_defrag_file(), we have this loop that iterates
over a file range in steps no larger than 256K subranges. If the range
is too long, there's no way to interrupt it. So make the loop check in
each iteration if there's signal pending, and if there is, break and
return -AGAIN to userspace.

Before kernel 5.16, we used to allow defrag to be cancelled through a
signal, but that was lost with commit 7b508037d4cac3 ("btrfs: defrag:
use defrag_one_cluster() to implement btrfs_defrag_file()").

This change adds back the possibility to cancel a defrag with a signal
and keeps the same semantics, returning -EAGAIN to user space (and not
the usually more expected -EINTR).

This is also motivated by a recent bug on 5.16 where defragging a 1 byte
file resulted in iterating from file range 0 to (u64)-1, as hitting the
bug triggered a too long loop, basically requiring one to reboot the
machine, as it was not possible to cancel defrag.

Fixes: 7b508037d4cac3 ("btrfs: defrag: use defrag_one_cluster() to implement btrfs_defrag_file()")
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1520,6 +1520,11 @@ int btrfs_defrag_file(struct inode *inod
 		/* The cluster size 256K should always be page aligned */
 		BUILD_BUG_ON(!IS_ALIGNED(CLUSTER_SIZE, PAGE_SIZE));
 
+		if (btrfs_defrag_cancelled(fs_info)) {
+			ret = -EAGAIN;
+			break;
+		}
+
 		/* We want the cluster end at page boundary when possible */
 		cluster_end = (((cur >> PAGE_SHIFT) +
 			       (SZ_256K >> PAGE_SHIFT)) << PAGE_SHIFT) - 1;


