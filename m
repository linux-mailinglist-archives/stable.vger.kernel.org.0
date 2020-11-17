Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643CC2B6572
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgKQNUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730497AbgKQNUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:20:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E001241A6;
        Tue, 17 Nov 2020 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619213;
        bh=Mvj3gVzoj/k0E8gkhN7B6i6pAWOOJtOxpd7fhYJfhuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQo1rxRb/lKPbsehardJ/vfMZ+sJjI3diGu5dBaK0G6RVxK7/8ctNjZn3zgG59w+e
         ctMQuxsu63CsEI4R2l/WSd0QmlXLuuWykvqtu9anVBefXvc+DbQ77JUoYicwxoWyjc
         XOrIY7nAmzQviYSUidSK9gZVXF3kbVqMBS/ehnfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 065/101] btrfs: ref-verify: fix memory leak in btrfs_ref_tree_mod
Date:   Tue, 17 Nov 2020 14:05:32 +0100
Message-Id: <20201117122116.274364522@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
@@ -854,6 +854,7 @@ int btrfs_ref_tree_mod(struct btrfs_root
 "dropping a ref for a root that doesn't have a ref on the block");
 			dump_block_entry(fs_info, be);
 			dump_ref_action(fs_info, ra);
+			kfree(ref);
 			kfree(ra);
 			goto out_unlock;
 		}


