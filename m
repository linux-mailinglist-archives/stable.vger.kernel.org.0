Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2736DEF9E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbjDLIwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjDLIwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9E1976F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B296262B5B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C341EC433D2;
        Wed, 12 Apr 2023 08:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289491;
        bh=IufBslprs5QYgX5T1NkQp1UqzpC4c2eoCB4rbWTwAWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OEHLgiDTsuP5uh7OUiBSQCV8apQiZl4Mw5oiGgmNnu+CI8zc09tOUbsIOs4AACgoU
         7zYhYD6QyAGvbE/ji302TB8R/ZmGvCd4sDGhV8EquSkbSDRE+O+HnncpQKOYKwSVud
         MoTM58zA2N+s5S2/t935EvSegEIgje0OLIBZX35Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Darrick J. Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.2 090/173] fsdax: force clear dirty mark if CoW
Date:   Wed, 12 Apr 2023 10:33:36 +0200
Message-Id: <20230412082841.690213106@linuxfoundation.org>
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

From: Shiyang Ruan <ruansy.fnst@fujitsu.com>

commit f76b3a32879de215ced3f8c754c4077b0c2f79e3 upstream.

XFS allows CoW on non-shared extents to combat fragmentation[1].  The old
non-shared extent could be mwrited before, its dax entry is marked dirty.

This results in a WARNing:

[   28.512349] ------------[ cut here ]------------
[   28.512622] WARNING: CPU: 2 PID: 5255 at fs/dax.c:390 dax_insert_entry+0x342/0x390
[   28.513050] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4 nfs lockd grace fscache netfs nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables
[   28.515462] CPU: 2 PID: 5255 Comm: fsstress Kdump: loaded Not tainted 6.3.0-rc1-00001-g85e1481e19c1-dirty #117
[   28.515902] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS Arch Linux 1.16.1-1-1 04/01/2014
[   28.516307] RIP: 0010:dax_insert_entry+0x342/0x390
[   28.516536] Code: 30 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 8b 45 20 48 83 c0 01 e9 e2 fe ff ff 48 8b 45 20 48 83 c0 01 e9 cd fe ff ff <0f> 0b e9 53 ff ff ff 48 8b 7c 24 08 31 f6 e8 1b 61 a1 00 eb 8c 48
[   28.517417] RSP: 0000:ffffc9000845fb18 EFLAGS: 00010086
[   28.517721] RAX: 0000000000000053 RBX: 0000000000000155 RCX: 000000000018824b
[   28.518113] RDX: 0000000000000000 RSI: ffffffff827525a6 RDI: 00000000ffffffff
[   28.518515] RBP: ffffea00062092c0 R08: 0000000000000000 R09: ffffc9000845f9c8
[   28.518905] R10: 0000000000000003 R11: ffffffff82ddb7e8 R12: 0000000000000155
[   28.519301] R13: 0000000000000000 R14: 000000000018824b R15: ffff88810cfa76b8
[   28.519703] FS:  00007f14a0c94740(0000) GS:ffff88817bd00000(0000) knlGS:0000000000000000
[   28.520148] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   28.520472] CR2: 00007f14a0c8d000 CR3: 000000010321c004 CR4: 0000000000770ee0
[   28.520863] PKRU: 55555554
[   28.521043] Call Trace:
[   28.521219]  <TASK>
[   28.521368]  dax_fault_iter+0x196/0x390
[   28.521595]  dax_iomap_pte_fault+0x19b/0x3d0
[   28.521852]  __xfs_filemap_fault+0x234/0x2b0
[   28.522116]  __do_fault+0x30/0x130
[   28.522334]  do_fault+0x193/0x340
[   28.522586]  __handle_mm_fault+0x2d3/0x690
[   28.522975]  handle_mm_fault+0xe6/0x2c0
[   28.523259]  do_user_addr_fault+0x1bc/0x6f0
[   28.523521]  exc_page_fault+0x60/0x140
[   28.523763]  asm_exc_page_fault+0x22/0x30
[   28.524001] RIP: 0033:0x7f14a0b589ca
[   28.524225] Code: c5 fe 7f 07 c5 fe 7f 47 20 c5 fe 7f 47 40 c5 fe 7f 47 60 c5 f8 77 c3 66 0f 1f 84 00 00 00 00 00 40 0f b6 c6 48 89 d1 48 89 fa <f3> aa 48 89 d0 c5 f8 77 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
[   28.525198] RSP: 002b:00007fff1dea1c98 EFLAGS: 00010202
[   28.525505] RAX: 000000000000001e RBX: 000000000014a000 RCX: 0000000000006046
[   28.525895] RDX: 00007f14a0c82000 RSI: 000000000000001e RDI: 00007f14a0c8d000
[   28.526290] RBP: 000000000000006f R08: 0000000000000004 R09: 000000000014a000
[   28.526681] R10: 0000000000000008 R11: 0000000000000246 R12: 028f5c28f5c28f5c
[   28.527067] R13: 8f5c28f5c28f5c29 R14: 0000000000011046 R15: 00007f14a0c946c0
[   28.527449]  </TASK>
[   28.527600] ---[ end trace 0000000000000000 ]---


To be able to delete this entry, clear its dirty mark before
invalidate_inode_pages2_range().

[1] https://lore.kernel.org/linux-xfs/20230321151339.GA11376@frogsfrogsfrogs/

Link: https://lkml.kernel.org/r/1679653680-2-1-git-send-email-ruansy.fnst@fujitsu.com
Fixes: f80e1668888f3 ("fsdax: invalidate pages when CoW")
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dax.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 5d2e9b10030e..2ababb89918d 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -781,6 +781,33 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	return ret;
 }
 
+static int __dax_clear_dirty_range(struct address_space *mapping,
+		pgoff_t start, pgoff_t end)
+{
+	XA_STATE(xas, &mapping->i_pages, start);
+	unsigned int scanned = 0;
+	void *entry;
+
+	xas_lock_irq(&xas);
+	xas_for_each(&xas, entry, end) {
+		entry = get_unlocked_entry(&xas, 0);
+		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
+		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
+		put_unlocked_entry(&xas, entry, WAKE_NEXT);
+
+		if (++scanned % XA_CHECK_SCHED)
+			continue;
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		cond_resched();
+		xas_lock_irq(&xas);
+	}
+	xas_unlock_irq(&xas);
+
+	return 0;
+}
+
 /*
  * Delete DAX entry at @index from @mapping.  Wait for it
  * to be unlocked before deleting it.
@@ -1440,6 +1467,16 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
 	 * written by write(2) is visible in mmap.
 	 */
 	if (iomap->flags & IOMAP_F_NEW || cow) {
+		/*
+		 * Filesystem allows CoW on non-shared extents. The src extents
+		 * may have been mmapped with dirty mark before. To be able to
+		 * invalidate its dax entries, we need to clear the dirty mark
+		 * in advance.
+		 */
+		if (cow)
+			__dax_clear_dirty_range(iomi->inode->i_mapping,
+						pos >> PAGE_SHIFT,
+						(end - 1) >> PAGE_SHIFT);
 		invalidate_inode_pages2_range(iomi->inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
-- 
2.40.0



