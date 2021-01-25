Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7473302AF1
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbhAYS4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:42114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731405AbhAYS4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:56:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F188D20758;
        Mon, 25 Jan 2021 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600929;
        bh=OsxG3zidV7xZauo8DwZtqGno+dUJQ2pqPuC8hRvZUNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IFugeehqoALGB1WH9wV6f+QPCqNATrnpUgSP3S7UjFJ+YyGFUDz2HTdwBMXsEMLUg
         T6HCLXRd9okqvHj43+yUDPqzbLpgtrDAjwGOUr+l/zAt3fC0BvDlPtt1DIBoHVq68S
         rPP1Xhqf5GCUbzhEr7jb89ZwdDzwIBBaoS3ZQ0Ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilad Reti <gilad.reti@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.10 195/199] bpf: Local storage helpers should check nullness of owner ptr passed
Date:   Mon, 25 Jan 2021 19:40:17 +0100
Message-Id: <20210125183224.399555836@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KP Singh <kpsingh@kernel.org>

commit 1a9c72ad4c26821e215a396167c14959cf24a7f1 upstream.

The verifier allows ARG_PTR_TO_BTF_ID helper arguments to be NULL, so
helper implementations need to check this before dereferencing them.
This was already fixed for the socket storage helpers but not for task
and inode.

The issue can be reproduced by attaching an LSM program to
inode_rename hook (called when moving files) which tries to get the
inode of the new file without checking for its nullness and then trying
to move an existing file to a new path:

  mv existing_file new_file_does_not_exist

The report including the sample program and the steps for reproducing
the bug:

  https://lore.kernel.org/bpf/CANaYP3HWkH91SN=wTNO9FL_2ztHfqcXKX38SSE-JJ2voh+vssw@mail.gmail.com

Fixes: 4cf1bc1f1045 ("bpf: Implement task local storage")
Fixes: 8ea636848aca ("bpf: Implement bpf_local_storage for inodes")
Reported-by: Gilad Reti <gilad.reti@gmail.com>
Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210112075525.256820-3-kpsingh@kernel.org
[ just take 1/2 of this patch for 5.10.y - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/bpf_inode_storage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -176,7 +176,7 @@ BPF_CALL_4(bpf_inode_storage_get, struct
 	 * bpf_local_storage_update expects the owner to have a
 	 * valid storage pointer.
 	 */
-	if (!inode_storage_ptr(inode))
+	if (!inode || !inode_storage_ptr(inode))
 		return (unsigned long)NULL;
 
 	sdata = inode_storage_lookup(inode, map, true);
@@ -200,6 +200,9 @@ BPF_CALL_4(bpf_inode_storage_get, struct
 BPF_CALL_2(bpf_inode_storage_delete,
 	   struct bpf_map *, map, struct inode *, inode)
 {
+	if (!inode)
+		return -EINVAL;
+
 	/* This helper must only called from where the inode is gurranteed
 	 * to have a refcount and cannot be freed.
 	 */


