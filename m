Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75961664A38
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbjAJSb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbjAJSae (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:30:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAFD8CBCF
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:25:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FEC0B81901
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77FDC433D2;
        Tue, 10 Jan 2023 18:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375116;
        bh=05C+XQcVlhtnEptzUnDXxtWOZ0G2HPKZYyKqJG56lXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S1GbgnyPxS9ainXm86TMaaB1A8VPie3Jucua8Xa9tpJ+nrQ/ABeo2/m19ssUC7LDc
         SnqL2XOpYTh7qpDUx+BI35lgs1kClAmzh+EuwwLLOV1cJ41lPhalVI99u2uK2bMZym
         ZP1lq82ylkYSKPYW4E46giKbM1GRSH0zwcQh8GhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 083/290] dm thin: Use last transactions pmd->root when commit failed
Date:   Tue, 10 Jan 2023 19:02:55 +0100
Message-Id: <20230110180034.466607900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 7991dbff6849f67e823b7cc0c15e5a90b0549b9f upstream.

Recently we found a softlock up problem in dm thin pool btree lookup
code due to corrupted metadata:

 Kernel panic - not syncing: softlockup: hung tasks
 CPU: 7 PID: 2669225 Comm: kworker/u16:3
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 Workqueue: dm-thin do_worker [dm_thin_pool]
 Call Trace:
   <IRQ>
   dump_stack+0x9c/0xd3
   panic+0x35d/0x6b9
   watchdog_timer_fn.cold+0x16/0x25
   __run_hrtimer+0xa2/0x2d0
   </IRQ>
   RIP: 0010:__relink_lru+0x102/0x220 [dm_bufio]
   __bufio_new+0x11f/0x4f0 [dm_bufio]
   new_read+0xa3/0x1e0 [dm_bufio]
   dm_bm_read_lock+0x33/0xd0 [dm_persistent_data]
   ro_step+0x63/0x100 [dm_persistent_data]
   btree_lookup_raw.constprop.0+0x44/0x220 [dm_persistent_data]
   dm_btree_lookup+0x16f/0x210 [dm_persistent_data]
   dm_thin_find_block+0x12c/0x210 [dm_thin_pool]
   __process_bio_read_only+0xc5/0x400 [dm_thin_pool]
   process_thin_deferred_bios+0x1a4/0x4a0 [dm_thin_pool]
   process_one_work+0x3c5/0x730

Following process may generate a broken btree mixed with fresh and
stale btree nodes, which could get dm thin trapped in an infinite loop
while looking up data block:
 Transaction 1: pmd->root = A, A->B->C   // One path in btree
                pmd->root = X, X->Y->Z   // Copy-up
 Transaction 2: X,Z is updated on disk, Y write failed.
                // Commit failed, dm thin becomes read-only.
                process_bio_read_only
		 dm_thin_find_block
		  __find_block
		   dm_btree_lookup(pmd->root)
The pmd->root points to a broken btree, Y may contain stale node
pointing to any block, for example X, which gets dm thin trapped into
a dead loop while looking up Z.

Fix this by setting pmd->root in __open_metadata(), so that dm thin
will use the last transaction's pmd->root if commit failed.

Fetch a reproducer in [Link].

Linke: https://bugzilla.kernel.org/show_bug.cgi?id=216790
Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -724,6 +724,15 @@ static int __open_metadata(struct dm_poo
 		goto bad_cleanup_data_sm;
 	}
 
+	/*
+	 * For pool metadata opening process, root setting is redundant
+	 * because it will be set again in __begin_transaction(). But dm
+	 * pool aborting process really needs to get last transaction's
+	 * root to avoid accessing broken btree.
+	 */
+	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
+	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
 


