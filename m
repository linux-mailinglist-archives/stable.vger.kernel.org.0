Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68342B6420
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732806AbgKQNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732520AbgKQNkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:40:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51F0A2467A;
        Tue, 17 Nov 2020 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620400;
        bh=cHpWfbAbQ72oM0pQxMZWYlf/KXEYkp4q+MpMXZG25nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9NpzNaSFUCrrD+tPZ+Ojdhv+8lv/jN83ZOWshFq18DElOegxp6vHHOyRBlWjT00Y
         GWjbJFNr5GuGhoJo/w/N6vOG2G16+EW6aTB4q/tLZlEbReasNVYvGJbJHlycSWueeE
         heaLakby2+tTklDlfhqQxyJIuWidSIZ9ZUcgNL80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 188/255] btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod
Date:   Tue, 17 Nov 2020 14:05:28 +0100
Message-Id: <20201117122148.074833097@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit 468600c6ec28613b756193c5f780aac062f1acdf upstream.

There is one error handling path that does not free ref, which may cause
a minor memory leak.

CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ref-verify.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -860,6 +860,7 @@ int btrfs_ref_tree_mod(struct btrfs_fs_i
 "dropping a ref for a root that doesn't have a ref on the block");
 			dump_block_entry(fs_info, be);
 			dump_ref_action(fs_info, ra);
+			kfree(ref);
 			kfree(ra);
 			goto out_unlock;
 		}


