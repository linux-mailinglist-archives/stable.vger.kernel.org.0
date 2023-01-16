Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC2066CD2E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbjAPReS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjAPRd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:33:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963822E0D1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:10:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03B5D6108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B24C433EF;
        Mon, 16 Jan 2023 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889003;
        bh=38EAfbkzB3VV+rS/8+C2uqiecC3F86T6jGjAon2tZbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lz2o9pPnJyQVbOmI4RkEsLe4rjgo6Y/UMZ65IYPuX/bcGIzo1RiEqW/NDx5hqAy5+
         n8LLcNpKDQtGtNBTNbIoMzeKiGfPWKFT231oJSXbSqa27N9OmiMNaaSaE+QLBbvySU
         v2+s8A2z5sKMFtwhZXMfeYKEeH0N7Qz+a4qOlXbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ZhangPeng <zhangpeng362@huawei.com>,
        syzbot+e836ff7133ac02be825f@syzkaller.appspotmail.com,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Jeff Layton <jlayton@kernel.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 222/338] hfs: fix OOB Read in __hfs_brec_find
Date:   Mon, 16 Jan 2023 16:51:35 +0100
Message-Id: <20230116154830.710392354@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit 8d824e69d9f3fa3121b2dda25053bae71e2460d2 ]

Syzbot reported a OOB read bug:

==================================================================
BUG: KASAN: slab-out-of-bounds in hfs_strcmp+0x117/0x190
fs/hfs/string.c:84
Read of size 1 at addr ffff88807eb62c4e by task kworker/u4:1/11
CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted
6.1.0-rc6-syzkaller-00308-g644e9524388a #0
Workqueue: writeback wb_workfn (flush-7:0)
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
 print_address_description+0x74/0x340 mm/kasan/report.c:284
 print_report+0x107/0x1f0 mm/kasan/report.c:395
 kasan_report+0xcd/0x100 mm/kasan/report.c:495
 hfs_strcmp+0x117/0x190 fs/hfs/string.c:84
 __hfs_brec_find+0x213/0x5c0 fs/hfs/bfind.c:75
 hfs_brec_find+0x276/0x520 fs/hfs/bfind.c:138
 hfs_write_inode+0x34c/0xb40 fs/hfs/inode.c:462
 write_inode fs/fs-writeback.c:1440 [inline]

If the input inode of hfs_write_inode() is incorrect:
struct inode
  struct hfs_inode_info
    struct hfs_cat_key
      struct hfs_name
        u8 len # len is greater than HFS_NAMELEN(31) which is the
maximum length of an HFS filename

OOB read occurred:
hfs_write_inode()
  hfs_brec_find()
    __hfs_brec_find()
      hfs_cat_keycmp()
        hfs_strcmp() # OOB read occurred due to len is too large

Fix this by adding a Check on len in hfs_write_inode() before calling
hfs_brec_find().

Link: https://lkml.kernel.org/r/20221130065959.2168236-1-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reported-by: <syzbot+e836ff7133ac02be825f@syzkaller.appspotmail.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 350afd67bd69..4e795c8d697d 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -453,6 +453,8 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		/* panic? */
 		return -EIO;
 
+	if (HFS_I(main_inode)->cat_key.CName.len > HFS_NAMELEN)
+		return -EIO;
 	fd.search_key->cat = HFS_I(main_inode)->cat_key;
 	if (hfs_brec_find(&fd))
 		/* panic? */
-- 
2.35.1



