Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DE51B687B
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgDWXPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:15:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49724 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728423AbgDWXGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:47 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-0004hn-CS; Fri, 24 Apr 2020 00:06:34 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvQ-00E6oK-9g; Fri, 24 Apr 2020 00:06:32 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Johannes Thumshirn" <jthumshirn@suse.de>,
        "Filipe Manana" <fdmanana@suse.com>,
        "Josef Bacik" <josef@toxicpanda.com>
Date:   Fri, 24 Apr 2020 00:05:43 +0100
Message-ID: <lsq.1587683028.968684714@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 116/245] btrfs: handle ENOENT in btrfs_uuid_tree_iterate
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 714cd3e8cba6841220dce9063a7388a81de03825 upstream.

If we get an -ENOENT back from btrfs_uuid_iter_rem when iterating the
uuid tree we'll just continue and do btrfs_next_item().  However we've
done a btrfs_release_path() at this point and no longer have a valid
path.  So increment the key and go back and do a normal search.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/uuid-tree.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -333,6 +333,8 @@ again_search_slot:
 				}
 				if (ret < 0 && ret != -ENOENT)
 					goto out;
+				key.offset++;
+				goto again_search_slot;
 			}
 			item_size -= sizeof(subid_le);
 			offset += sizeof(subid_le);

