Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD171C44D3
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgEDSKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731782AbgEDSFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:05:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D53206B8;
        Mon,  4 May 2020 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615514;
        bh=o4bXWZrQJV80Xcf2zwTBo3dnICBBFbRYrxHVjZPcjNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JGLZWsYCjyxp1mZ45OB4Ca/x7IHWCT0C3Q/rq5NRJ826v8kWOpywTUmUFibJBgIV
         oM/b5svi0bcsXIKNYa95+fEitP3iqiRF98B4gOnc9VriB365qNpptD8Am9ce1/RpYN
         SowSKpfn/YchMy5Ux3GPMkc7JY49cluVLBuyN12c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.6 12/73] btrfs: fix transaction leak in btrfs_recover_relocation
Date:   Mon,  4 May 2020 19:57:15 +0200
Message-Id: <20200504165504.238322681@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 1402d17dfd9657be0da8458b2079d03c2d61c86a upstream.

btrfs_recover_relocation() invokes btrfs_join_transaction(), which joins
a btrfs_trans_handle object into transactions and returns a reference of
it with increased refcount to "trans".

When btrfs_recover_relocation() returns, "trans" becomes invalid, so the
refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
btrfs_recover_relocation(). When read_fs_root() failed, the refcnt
increased by btrfs_join_transaction() is not decreased, causing a refcnt
leak.

Fix this issue by calling btrfs_end_transaction() on this error path
when read_fs_root() failed.

Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4614,6 +4614,7 @@ int btrfs_recover_relocation(struct btrf
 		if (IS_ERR(fs_root)) {
 			err = PTR_ERR(fs_root);
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
+			btrfs_end_transaction(trans);
 			goto out_unset;
 		}
 


