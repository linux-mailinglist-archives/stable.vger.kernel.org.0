Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B48330E49
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhCHMgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhCHMgD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41669651FF;
        Mon,  8 Mar 2021 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206962;
        bh=0w3KaZuufbY1Kuqbfftw2i6MVnuo9/nwUbmQOMoraAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0yOJzyhNP0DPkSUm+x0pT+YKWIhWYVrW36w9iXy8e45GBzlIyzUjTlpUi19cuvI3
         LIcPzgiGig6qoY3Z06meua51jS+f0yYOfSIPKfiakwzoSzGnbEtrAc72W4HvQ08hcf
         CJ9AVA9cOod5OmngKwHQUxuxvOEdQKUf6L+bGvO8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 16/44] btrfs: free correct amount of space in btrfs_delayed_inode_reserve_metadata
Date:   Mon,  8 Mar 2021 13:34:54 +0100
Message-Id: <20210308122719.378012853@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Nikolay Borisov <nborisov@suse.com>

commit 0f9c03d824f6f522d3bc43629635c9765546ebc5 upstream.

Following commit f218ea6c4792 ("btrfs: delayed-inode: Remove wrong
qgroup meta reservation calls") this function now reserves num_bytes,
rather than the fixed amount of nodesize. As such this requires the
same amount to be freed in case of failure. Fix this by adjusting
the amount we are freeing.

Fixes: f218ea6c4792 ("btrfs: delayed-inode: Remove wrong qgroup meta reservation calls")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/delayed-inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -649,7 +649,7 @@ static int btrfs_delayed_inode_reserve_m
 						      btrfs_ino(inode),
 						      num_bytes, 1);
 		} else {
-			btrfs_qgroup_free_meta_prealloc(root, fs_info->nodesize);
+			btrfs_qgroup_free_meta_prealloc(root, num_bytes);
 		}
 		return ret;
 	}


