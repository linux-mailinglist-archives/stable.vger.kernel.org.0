Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B49455786
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 09:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244876AbhKRJBm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:01:42 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:51867 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244892AbhKRJBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637225914; x=1668761914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E2JkQrCaOvVejULm/4ROclZwcEoidXyYpOrhDUep9+o=;
  b=YDB7ubmg5vmt9u8KM96NP6slo1aFt5ha2rRC1tK2VR8XvZQ1k/11LGKM
   utZlxWyfcONhbKTOcLN6pv/0/w0Zm1WMQSiK+67qkmksAeIoiD0EIW4TA
   2olP6VcOqRaHlYxI9Dvece2ANM1LJakhO1pPla0GE137PB8fKHWdMq4SF
   5DlSY4MAER8EJIsxyx9CYHGALbrZ4uRZ8yxQiy2v1oYik0IReV/LPcMVM
   pvRfTjqayYrZb7IIE1VqTedyowJvsy3o4Z7FXWMtv749jxl/8w6CamCxl
   U2CknljhIbZZhdrL50UMIMk6pPlgSo6tVl9ZQqaGdu7R/thwpsBwOsN0i
   w==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="289876573"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 16:58:32 +0800
IronPort-SDR: 4G3kPnXoi6I6fhYSVVEiFoH5mOguSKmxXNX87/CxCw9leSffmIz4VHjc3l5iTttKYsjFVxl9Zk
 UOD9pO2+bD7VZkHvYL8wRsi/x//+NQETKJ65JzD4kPUcoetCSPmWj7/yUzkteVvVFhwV7jSseM
 9bIDYuNtJtjJG67MaixteTu0PX5c1EQNVEK9UKwsJeBWiiUgqD7KPLA8tGmfnPOckIhT/89VX/
 Vw8QWfFqcLUYx+5Zkz7EoEZyfROLGuuG79kQnXEmaQSAl+xXwcT/xB+jOGST3SEzEKzv3MiuSn
 YexkkGKcXmPXq9GoQhLGEbL5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 00:33:33 -0800
IronPort-SDR: L7UwQ1fS4zq4scqfSxrx8+Mz4mYl3RVYEcfBLBe1beFJpACVIXhIayJaCgDmSSpcRWszhPhazM
 v7v/KWfDDM/ouh0UjBAqLhXM14LbaUF56X0CNCd5oEk6YXvnQIbUk2HJr7Xrx981FiwQ3qtNRC
 VzeI+8R+K8ZHcZ5OzDR6LWeev/4UG2OyNhJN9NAnxlT1GUmp62awjFms/QBeOUiSAc0fr+JDuY
 8gipubVjAe9XgV6uDu14G0Rbn8rjt94r69azkugkHFtZ7PEyzA39FZuSql4SRQkQPcGJiluMxp
 RFY=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 18 Nov 2021 00:58:31 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH for-5.15.x 5/6] btrfs: check for relocation inodes on zoned btrfs in should_nocow
Date:   Thu, 18 Nov 2021 17:58:17 +0900
Message-Id: <2b57613ad55081ae305f66db17dec297f84c04ca.1637225333.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1637225333.git.johannes.thumshirn@wdc.com>
References: <cover.1637225333.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2adada886b26e998b5a624e72f0834ebfdc54cc7 upstream

Prepare for allowing preallocation for relocation inodes.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/btrfs/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85663bccde8a..61b4651f008d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1945,7 +1945,15 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 	const bool zoned = btrfs_is_zoned(inode->root->fs_info);
 
 	if (should_nocow(inode, start, end)) {
-		ASSERT(!zoned);
+		/*
+		 * Normally on a zoned device we're only doing COW writes, but
+		 * in case of relocation on a zoned filesystem we have taken
+		 * precaution, that we're only writing sequentially. It's safe
+		 * to use run_delalloc_nocow() here, like for  regular
+		 * preallocated inodes.
+		 */
+		ASSERT(!zoned ||
+		       (zoned && btrfs_is_data_reloc_root(inode->root)));
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, nr_written);
 	} else if (!inode_can_compress(inode) ||
-- 
2.32.0

