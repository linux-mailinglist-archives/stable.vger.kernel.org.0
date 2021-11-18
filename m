Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71125455784
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbhKRJBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:01:39 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44975 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243644AbhKRJBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637225911; x=1668761911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bbkWWi0qrIYwJrDg5z1r0cP32UMmMABKlS7CI2fNsCE=;
  b=bk0+nD9/ocCQRuBb8jCVdWvblWtJp/f+YJJ64VQfr28rfqlxJ+EOWYDm
   PO39K9GkmGT6HqU//gcropDP6pboTc4so3xbmRvXDQqK+Qf85K8O5LeZR
   r4i8LztQ0zFlrCOnpgqdc0gw83AFphXk4WaWTHJq9PlUHOzdWW95wIXky
   V1uDNn9h6YZF9SXyIhryElz17A/JTqogrJ4+2IHhgMGdBKY8B1+Z3ZfHX
   qebKz2l0+2p6f3vQC0tA4FLiPe97sk+dTkj8VRaGV3R+SsjvC7kLZpsYj
   LpqzSdg2zW1gPG+DzrOkom6tM5HnOE9iKDpgCE7KshCdCaMEDu/LR7VuU
   g==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="185939021"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 16:58:30 +0800
IronPort-SDR: 9Xmc9rbSk/ZaU+5fXPE1jjXvwYF+OJZKkQnMqZv9UZa1khO1c2ypYhiXTBSMCcwX73/sO2Y9X9
 yZ0Y0syJZJnEbJ/DkE9ry4FuFmg56D7lQcSUXj/uBl4O0lIIBoqUsmgfEX0ev7kXl17my8ZTcW
 so251CMgSDyNr6xG5b+5Rl8V8B5eq/cdiWBLJDu9JGJbqQPWLoeLw/ZBV+OuA9tmtg22MXj5N7
 StWSNIoLyyzyQYzzhIvynfr7UWMHrwf4bvqPJfa67lChDGzFCy6oaUuwwu5/DIZWETt7wvEhA7
 wNyiVN2zzzYmQDc5jGMaqb6h
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 00:33:32 -0800
IronPort-SDR: lSbRxrVTqC75rOiJeOalKdojepFnFA2bklOfAPFiU0/Zitt0KN6hYpXQR/hQTeGgI1XJOlWmfz
 yHWCXJ/1nLqDiWofvU9aDH3ETTpB8BbvmuqV9P6uJIb2Ydv7h6/Qn3tQS1g19Um75vLriCXN0G
 FHZp8e6bpFONTiAQbwk+BnZCun9/qYraO2Ew0GYHXVYSFVHGT8ar9UdDxmInAL/k3rhVqk6ucL
 EJlEFEU80424iwqFmcKpMIX+tqzpkAGdbCtXf0FRiPU0WJUkMJal00WQN4BsRy2VkjENpMq+cT
 kDk=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Nov 2021 00:58:30 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH for-5.15.x 4/6] btrfs: zoned: use regular writes for relocation
Date:   Thu, 18 Nov 2021 17:58:16 +0900
Message-Id: <a6aa5997187d6e0172652cc29aea76be851c4cf6.1637225333.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1637225333.git.johannes.thumshirn@wdc.com>
References: <cover.1637225333.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e6d261e3b1f777b499ce8f535ed44dd1b69278b7 upstream

Now that we have a dedicated block group for relocation, we can use
REQ_OP_WRITE instead of  REQ_OP_ZONE_APPEND for writing out the data on
relocation.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/zoned.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 18ee85e1c9a2..5672c24a2d58 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1304,6 +1304,17 @@ bool btrfs_use_zone_append(struct btrfs_inode *inode, u64 start)
 	if (!is_data_inode(&inode->vfs_inode))
 		return false;
 
+	/*
+	 * Using REQ_OP_ZONE_APPNED for relocation can break assumptions on the
+	 * extent layout the relocation code has.
+	 * Furthermore we have set aside own block-group from which only the
+	 * relocation "process" can allocate and make sure only one process at a
+	 * time can add pages to an extent that gets relocated, so it's safe to
+	 * use regular REQ_OP_WRITE for this special case.
+	 */
+	if (btrfs_is_data_reloc_root(inode->root))
+		return false;
+
 	cache = btrfs_lookup_block_group(fs_info, start);
 	ASSERT(cache);
 	if (!cache)
-- 
2.32.0

