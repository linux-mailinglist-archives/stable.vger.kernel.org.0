Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F3BE6979
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfJ0VGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727465AbfJ0VGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:06:12 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2970E20B7C;
        Sun, 27 Oct 2019 21:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210371;
        bh=V3L3ajqgIIvjGrqd9v+vqSVseo6kV+2bOOOWCgjVJ4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT01JIz00BSbqvIFLZuJ1EqlJj8lvY63q0F1MOhNVIC2+3N4voMdoI3EwmQSum6jm
         OUWqY4Xptu4dER5a3UYX4jJbDgAZZLwWE4IE3XaCKMEYQ4oZkVw1uuqT3zgmlJW/Vn
         npdFqWHIXgrGZEoHqgbnIrtO5qSFqagehhbi6g3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 43/49] btrfs: block-group: Fix a memory leak due to missing btrfs_put_block_group()
Date:   Sun, 27 Oct 2019 22:01:21 +0100
Message-Id: <20191027203201.084029289@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203119.468466356@linuxfoundation.org>
References: <20191027203119.468466356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 4b654acdae850f48b8250b9a578a4eaa518c7a6f upstream.

In btrfs_read_block_groups(), if we have an invalid block group which
has mixed type (DATA|METADATA) while the fs doesn't have MIXED_GROUPS
feature, we error out without freeing the block group cache.

This patch will add the missing btrfs_put_block_group() to prevent
memory leak.

Note for stable backports: the file to patch in versions <= 5.3 is
fs/btrfs/extent-tree.c

Fixes: 49303381f19a ("Btrfs: bail out if block group has different mixed flag")
CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent-tree.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10325,6 +10325,7 @@ int btrfs_read_block_groups(struct btrfs
 			btrfs_err(info,
 "bg %llu is a mixed block group but filesystem hasn't enabled mixed block groups",
 				  cache->key.objectid);
+			btrfs_put_block_group(cache);
 			ret = -EINVAL;
 			goto error;
 		}


