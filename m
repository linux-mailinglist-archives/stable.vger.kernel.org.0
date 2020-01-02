Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066BC12EF18
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgABWng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgABWe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:34:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E267A20866;
        Thu,  2 Jan 2020 22:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004468;
        bh=POlYgQfhkJv2yEf8YsXysIuUDdLsDpL3K68G9T0j/Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz4/z29AgB7zU3eLBC59uv/+K4K8hxgVueJ2VX9hIgYBD+Y8tVj0iq6c0nMJALwqJ
         /WzgwupAIaSW1roC5DpXuXYfbQ3/VFhneTmABNDZkuKDCc4+B6B1MWt5En75cFXvh5
         hpNBPz7SsWbdcC223wG4NXLuZKvrbqJHzb37XnV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.4 002/137] btrfs: handle ENOENT in btrfs_uuid_tree_iterate
Date:   Thu,  2 Jan 2020 23:06:15 +0100
Message-Id: <20200102220546.931969543@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.618583146@linuxfoundation.org>
References: <20200102220546.618583146@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 714cd3e8cba6841220dce9063a7388a81de03825 upstream.

If we get an -ENOENT back from btrfs_uuid_iter_rem when iterating the
uuid tree we'll just continue and do btrfs_next_item().  However we've
done a btrfs_release_path() at this point and no longer have a valid
path.  So increment the key and go back and do a normal search.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/uuid-tree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -332,6 +332,8 @@ again_search_slot:
 				}
 				if (ret < 0 && ret != -ENOENT)
 					goto out;
+				key.offset++;
+				goto again_search_slot;
 			}
 			item_size -= sizeof(subid_le);
 			offset += sizeof(subid_le);


