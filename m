Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED32D656EEE
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiL0UgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiL0UeO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:34:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7BED10E;
        Tue, 27 Dec 2022 12:33:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EE87B811F8;
        Tue, 27 Dec 2022 20:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6CFC43392;
        Tue, 27 Dec 2022 20:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173227;
        bh=KAt6EnUcnTGHRWClgXKe+Jj0DU2VlSiFGrq1ovX+Pkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVE9YJ6jKObaoKAXzi2H5NRW58wMU3W2rMVYIPd7GX9j0bGKfd/Dq+i4TQpWNmuT/
         h4RqHjyCOVztL0GUC2usDojAa3hNKF0iushhXAYI7quUN++aR00OTxlK2HwkexilAN
         Uj1Pz7zhCQKSE9WhYLHAkJwnZG8w3tNuH5LtwdMxfX6pzBaC7cFujAxCbE+ZGBO6pi
         WkiuuIiomvVlnGVGdXWTRW2fHZF8mAQQ385f4gHe+qV56ixNR7DZJtNcaQh1rFs+Gw
         g/r4O027Mok76JdQTAQSpdBU8aG+WU7mEJES/j2axOkkCwvd4/gy8pht57B8Wcjzf3
         jD2ZHETLeYYWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Edward Lo <edward.lo@ambergroup.io>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Sasha Levin <sashal@kernel.org>, ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 03/27] fs/ntfs3: Validate data run offset
Date:   Tue, 27 Dec 2022 15:33:18 -0500
Message-Id: <20221227203342.1213918-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203342.1213918-1-sashal@kernel.org>
References: <20221227203342.1213918-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Lo <edward.lo@ambergroup.io>

[ Upstream commit 6db620863f8528ed9a9aa5ad323b26554a17881d ]

This adds sanity checks for data run offset. We should make sure data
run offset is legit before trying to unpack them, otherwise we may
encounter use-after-free or some unexpected memory access behaviors.

[   82.940342] BUG: KASAN: use-after-free in run_unpack+0x2e3/0x570
[   82.941180] Read of size 1 at addr ffff888008a8487f by task mount/240
[   82.941670]
[   82.942069] CPU: 0 PID: 240 Comm: mount Not tainted 5.19.0+ #15
[   82.942482] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[   82.943720] Call Trace:
[   82.944204]  <TASK>
[   82.944471]  dump_stack_lvl+0x49/0x63
[   82.944908]  print_report.cold+0xf5/0x67b
[   82.945141]  ? __wait_on_bit+0x106/0x120
[   82.945750]  ? run_unpack+0x2e3/0x570
[   82.946626]  kasan_report+0xa7/0x120
[   82.947046]  ? run_unpack+0x2e3/0x570
[   82.947280]  __asan_load1+0x51/0x60
[   82.947483]  run_unpack+0x2e3/0x570
[   82.947709]  ? memcpy+0x4e/0x70
[   82.947927]  ? run_pack+0x7a0/0x7a0
[   82.948158]  run_unpack_ex+0xad/0x3f0
[   82.948399]  ? mi_enum_attr+0x14a/0x200
[   82.948717]  ? run_unpack+0x570/0x570
[   82.949072]  ? ni_enum_attr_ex+0x1b2/0x1c0
[   82.949332]  ? ni_fname_type.part.0+0xd0/0xd0
[   82.949611]  ? mi_read+0x262/0x2c0
[   82.949970]  ? ntfs_cmp_names_cpu+0x125/0x180
[   82.950249]  ntfs_iget5+0x632/0x1870
[   82.950621]  ? ntfs_get_block_bmap+0x70/0x70
[   82.951192]  ? evict+0x223/0x280
[   82.951525]  ? iput.part.0+0x286/0x320
[   82.951969]  ntfs_fill_super+0x1321/0x1e20
[   82.952436]  ? put_ntfs+0x1d0/0x1d0
[   82.952822]  ? vsprintf+0x20/0x20
[   82.953188]  ? mutex_unlock+0x81/0xd0
[   82.953379]  ? set_blocksize+0x95/0x150
[   82.954001]  get_tree_bdev+0x232/0x370
[   82.954438]  ? put_ntfs+0x1d0/0x1d0
[   82.954700]  ntfs_fs_get_tree+0x15/0x20
[   82.955049]  vfs_get_tree+0x4c/0x130
[   82.955292]  path_mount+0x645/0xfd0
[   82.955615]  ? putname+0x80/0xa0
[   82.955955]  ? finish_automount+0x2e0/0x2e0
[   82.956310]  ? kmem_cache_free+0x110/0x390
[   82.956723]  ? putname+0x80/0xa0
[   82.957023]  do_mount+0xd6/0xf0
[   82.957411]  ? path_mount+0xfd0/0xfd0
[   82.957638]  ? __kasan_check_write+0x14/0x20
[   82.957948]  __x64_sys_mount+0xca/0x110
[   82.958310]  do_syscall_64+0x3b/0x90
[   82.958719]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   82.959341] RIP: 0033:0x7fd0d1ce948a
[   82.960193] Code: 48 8b 0d 11 fa 2a 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 008
[   82.961532] RSP: 002b:00007ffe59ff69a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[   82.962527] RAX: ffffffffffffffda RBX: 0000564dcc107060 RCX: 00007fd0d1ce948a
[   82.963266] RDX: 0000564dcc107260 RSI: 0000564dcc1072e0 RDI: 0000564dcc10fce0
[   82.963686] RBP: 0000000000000000 R08: 0000564dcc107280 R09: 0000000000000020
[   82.964272] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000564dcc10fce0
[   82.964785] R13: 0000564dcc107260 R14: 0000000000000000 R15: 00000000ffffffff

Signed-off-by: Edward Lo <edward.lo@ambergroup.io>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c   | 13 +++++++++++++
 fs/ntfs3/attrlist.c |  5 +++++
 fs/ntfs3/frecord.c  | 14 ++++++++++++++
 fs/ntfs3/fslog.c    |  9 +++++++++
 fs/ntfs3/inode.c    |  5 +++++
 5 files changed, 46 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 71f870d497ae..0d354560d323 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -101,6 +101,10 @@ static int attr_load_runs(struct ATTRIB *attr, struct ntfs_inode *ni,
 
 	asize = le32_to_cpu(attr->size);
 	run_off = le16_to_cpu(attr->nres.run_off);
+
+	if (run_off > asize)
+		return -EINVAL;
+
 	err = run_unpack_ex(run, ni->mi.sbi, ni->mi.rno, svcn, evcn,
 			    vcn ? *vcn : svcn, Add2Ptr(attr, run_off),
 			    asize - run_off);
@@ -1232,6 +1236,10 @@ int attr_load_runs_vcn(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	}
 
 	ro = le16_to_cpu(attr->nres.run_off);
+
+	if (ro > le32_to_cpu(attr->size))
+		return -EINVAL;
+
 	err = run_unpack_ex(run, ni->mi.sbi, ni->mi.rno, svcn, evcn, svcn,
 			    Add2Ptr(attr, ro), le32_to_cpu(attr->size) - ro);
 	if (err < 0)
@@ -1901,6 +1909,11 @@ int attr_collapse_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 			u16 le_sz;
 			u16 roff = le16_to_cpu(attr->nres.run_off);
 
+			if (roff > le32_to_cpu(attr->size)) {
+				err = -EINVAL;
+				goto out;
+			}
+
 			run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn,
 				      evcn1 - 1, svcn, Add2Ptr(attr, roff),
 				      le32_to_cpu(attr->size) - roff);
diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index bad6d8a849a2..c0c6bcbc8c05 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -68,6 +68,11 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 
 		run_init(&ni->attr_list.run);
 
+		if (run_off > le32_to_cpu(attr->size)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		err = run_unpack_ex(&ni->attr_list.run, ni->mi.sbi, ni->mi.rno,
 				    0, le64_to_cpu(attr->nres.evcn), 0,
 				    Add2Ptr(attr, run_off),
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 381a38a06ec2..b1b476fb7229 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -568,6 +568,12 @@ static int ni_repack(struct ntfs_inode *ni)
 		}
 
 		roff = le16_to_cpu(attr->nres.run_off);
+
+		if (roff > le32_to_cpu(attr->size)) {
+			err = -EINVAL;
+			break;
+		}
+
 		err = run_unpack(&run, sbi, ni->mi.rno, svcn, evcn, svcn,
 				 Add2Ptr(attr, roff),
 				 le32_to_cpu(attr->size) - roff);
@@ -1589,6 +1595,9 @@ int ni_delete_all(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
+		if (roff > asize)
+			return -EINVAL;
+
 		/* run==1 means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
 			      Add2Ptr(attr, roff), asize - roff);
@@ -2291,6 +2300,11 @@ int ni_decompress_file(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
+		if (roff > asize) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		/*run==1  Means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
 			      Add2Ptr(attr, roff), asize - roff);
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index e7c494005122..138050b1aa93 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -2727,6 +2727,9 @@ static inline bool check_attr(const struct MFT_REC *rec,
 			return false;
 		}
 
+		if (run_off > asize)
+			return false;
+
 		if (run_unpack(NULL, sbi, 0, svcn, evcn, svcn,
 			       Add2Ptr(attr, run_off), asize - run_off) < 0) {
 			return false;
@@ -4771,6 +4774,12 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 		u16 roff = le16_to_cpu(attr->nres.run_off);
 		CLST svcn = le64_to_cpu(attr->nres.svcn);
 
+		if (roff > t32) {
+			kfree(oa->attr);
+			oa->attr = NULL;
+			goto fake_attr;
+		}
+
 		err = run_unpack(&oa->run0, sbi, inode->i_ino, svcn,
 				 le64_to_cpu(attr->nres.evcn), svcn,
 				 Add2Ptr(attr, roff), t32 - roff);
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 26a76ebfe58f..3f5e3ca099c7 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -364,6 +364,11 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 attr_unpack_run:
 	roff = le16_to_cpu(attr->nres.run_off);
 
+	if (roff > asize) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	t64 = le64_to_cpu(attr->nres.svcn);
 	err = run_unpack_ex(run, sbi, ino, t64, le64_to_cpu(attr->nres.evcn),
 			    t64, Add2Ptr(attr, roff), asize - roff);
-- 
2.35.1

