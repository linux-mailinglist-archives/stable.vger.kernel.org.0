Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F765192FA
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbiEDAxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244783AbiEDAxY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:53:24 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A985403DE;
        Tue,  3 May 2022 17:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651625391; x=1683161391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=McS6LOQ+qbCDqY9h9ImN2+sDf7qjg7/obzhcg89zg0o=;
  b=qovhTbmrGmFDiFrcqr5XqHVhBz+VsxJ7HG6mfhvR3r1gBaDCpf0i13ml
   ntBHkXQ0F8+mTBBBM7W9Euxg/1/GDEqvFBcqpzE/ZsJotaE1f/pzhCmvZ
   KN43a56GTExU/QwXZZpmgFEUhZUwOhvmT/tsGUBEoO95hQm1eSx2TefkC
   0xmdiAuEIxpWSOkqI89lcFO+O2kDAMrumDvFzVP0SXn2WKVFKjLyOfbLB
   W7pBI/dzgit39SJfbJNgNGwIBLCXqYGZ5eoVIiRcXOWOWnMQy04E+Ck1H
   ePaghz/zizwov/GIdvlGMkNntOCUXNIjYR1Bl2SE75dbpCasEOZBeqkfT
   A==;
X-IronPort-AV: E=Sophos;i="5.91,196,1647273600"; 
   d="scan'208";a="200341896"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2022 08:49:47 +0800
IronPort-SDR: N0s6hZ7XSu6jf1WmUqdmBBi6Y47coCEvs6I6y91r7rHgF6pVfz2fgleGkY2j8XbC/nLMZI8eCd
 /6J8BY7omU1S99rr40LTWFUjp2VBTg/H4QEMDkBkCzPAS6NEL5stFCUsv616OBdfDUfFi9IhfT
 MdPl04oRSvjU5vC8iYwpDuh9mLXg1kRLUDhIfEHHFLjhxe3aPfr8oY1boWpJKB/fYBm+dMjjrZ
 FpCHwbYIP7CyMoujsicpoyZt3IvEYoNYyFt4QXtCBhxruvfHJNCAaURrYJwFmxagVJtR5gau/0
 BNbvwsVMrQSsgsQ1N57iOPjo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 May 2022 17:19:48 -0700
IronPort-SDR: f/KeC8mR9T8DNqYFNSy7nxiVC6DambtZiVi1S5f6H5nD5WCJbvjFfyYhA9ZfwU6h5c55zXAONf
 BXAojG4V53wOmqDLGxQ04tgyqI5n7vY/k0CUM1oMuF18pMTgBOuUnZRgpwGdKbzkZ6xR+imvv8
 x3X08BVZ1/JlLNVKaAeo4IOGhLSy/tg7vPS3RnOzEHprtBjIWyAEqg3a3FFvN4cgH1X8lyIGoy
 LcXFziy4HzoHlW/siCnLEHOuW/UwVraWeHWBX2SreKs7N4dCM9QkoR2I+F6eot80prwEDX9aV8
 W/g=
WDCIronportException: Internal
Received: from jv0vzd3.ad.shared (HELO naota-x1.wdc.com) ([10.225.48.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 May 2022 17:49:44 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH v2 5/5] btrfs: zoned: zone finish unused block group
Date:   Tue,  3 May 2022 17:48:54 -0700
Message-Id: <39cf96b9872341d88593f293f2211935d7a6bfac.1651624820.git.naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651624820.git.naohiro.aota@wdc.com>
References: <cover.1651624820.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While the active zones within an active block group are reset, and their
active resource is released, the block group itself is kept in the active
block group list and marked as active. As a result, the list will contain
more than max_active_zones block groups. That itself is not fatal for the
device as the zones are properly reset.

However, that inflated list is, of course, strange. Also, a to-appear patch
series, which deactivates an active block group on demand, get confused
with the wrong list.

So, fix the issue by finishing the unused block group once it gets
read-only, so that we can release the active resource in an early stage.

Cc: stable@vger.kernel.org # 5.16+
Fixes: be1a1d7a5d24 ("btrfs: zoned: finish fully written block group")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/block-group.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 9739f3e8230a..ede389f2602d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1385,6 +1385,14 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			goto next;
 		}
 
+		ret = btrfs_zone_finish(block_group);
+		if (ret < 0) {
+			btrfs_dec_block_group_ro(block_group);
+			if (ret == -EAGAIN)
+				ret = 0;
+			goto next;
+		}
+
 		/*
 		 * Want to do this before we do anything else so we can recover
 		 * properly if we fail to join the transaction.
-- 
2.35.1

