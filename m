Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FB56DEF2C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbjDLIsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjDLIsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:48:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D401F7A9F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:48:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90B216311F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CAFC433EF;
        Wed, 12 Apr 2023 08:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289229;
        bh=8U48gKTLAtvzZr3KsZAGXhT8ouZ2sFVl7DENiYl3hFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UI+pN4mvWvNCmED9Z2n+sGV2Mx9kugFN0LRW/g65gTtPlgQu6c6r/Sz8pGPrugG8m
         bZJUGLX27xy9pqD1B8EpEmzxNr+2vz7p8ucHi0dfs709lbhbLDyUPAANwG6LsTuPWW
         AiwF6vlXY6HCNiDq6YKk3Mw52RrLuvNBnYQxgpzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 002/173] dm integrity: Remove bi_sector thats only used by commented debug code
Date:   Wed, 12 Apr 2023 10:32:08 +0200
Message-Id: <20230412082838.236042652@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 5cd6d1d53a1f74222e73d8b42ab7ecf28ee2f34f ]

drivers/md/dm-integrity.c:1738:13: warning: variable 'bi_sector' set but not used.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3895
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: f7b58a69fad9 ("dm: fix improper splitting for abnormal bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1388ee35571e0..c62c21aadf329 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1735,7 +1735,6 @@ static void integrity_metadata(struct work_struct *w)
 		}
 
 		if (unlikely(dio->op == REQ_OP_DISCARD)) {
-			sector_t bi_sector = dio->bio_details.bi_iter.bi_sector;
 			unsigned bi_size = dio->bio_details.bi_iter.bi_size;
 			unsigned max_size = likely(checksums != checksums_onstack) ? PAGE_SIZE : HASH_MAX_DIGESTSIZE;
 			unsigned max_blocks = max_size / ic->tag_size;
@@ -1752,13 +1751,7 @@ static void integrity_metadata(struct work_struct *w)
 					goto error;
 				}
 
-				/*if (bi_size < this_step_blocks << (SECTOR_SHIFT + ic->sb->log2_sectors_per_block)) {
-					printk("BUGG: bi_sector: %llx, bi_size: %u\n", bi_sector, bi_size);
-					printk("BUGG: this_step_blocks: %u\n", this_step_blocks);
-					BUG();
-				}*/
 				bi_size -= this_step_blocks << (SECTOR_SHIFT + ic->sb->log2_sectors_per_block);
-				bi_sector += this_step_blocks << ic->sb->log2_sectors_per_block;
 			}
 
 			if (likely(checksums != checksums_onstack))
-- 
2.39.2



