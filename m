Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334FD1B697D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgDWXYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:24:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48326 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728155AbgDWXGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:30 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-0004ai-38; Fri, 24 Apr 2020 00:06:26 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvJ-00E6hF-2G; Fri, 24 Apr 2020 00:06:25 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David Sterba" <dsterba@suse.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ben Hutchings" <ben.hutchings@codethink.co.uk>,
        "Nikolay Borisov" <nborisov@suse.com>,
        "Qu Wenruo" <quwenruo.btrfs@gmx.com>
Date:   Fri, 24 Apr 2020 00:04:26 +0100
Message-ID: <lsq.1587683028.78638430@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 039/245] btrfs: Check if item pointer overlaps with
 the item itself
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

From: Qu Wenruo <quwenruo.btrfs@gmx.com>

commit 7f43d4affb2a254d421ab20b0cf65ac2569909fb upstream.

Function check_leaf() checks if any item pointer points outside of the
leaf, but it doesn't check if the pointer overlaps with the item itself.

Normally only the last item may be the victim, but adding such check is
never a bad idea anyway.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/disk-io.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -606,6 +606,13 @@ static noinline int check_leaf(struct bt
 			return -EUCLEAN;
 		}
 
+		/* Also check if the item pointer overlaps with btrfs item. */
+		if (btrfs_item_nr_offset(slot) + sizeof(struct btrfs_item) >
+		    btrfs_item_ptr_offset(leaf, slot)) {
+			CORRUPT("slot overlap with its data", leaf, root, slot);
+			return -EUCLEAN;
+		}
+
 		prev_key.objectid = key.objectid;
 		prev_key.type = key.type;
 		prev_key.offset = key.offset;

