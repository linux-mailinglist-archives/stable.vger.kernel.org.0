Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BED27BB45
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 05:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgI2DGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 23:06:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54210 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbgI2DGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 23:06:17 -0400
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 23:06:16 EDT
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200929025715epoutp0445f7ed685f3e4c8f5e3249163e429b3e~5IbxnYv3t2836228362epoutp044
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 02:57:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200929025715epoutp0445f7ed685f3e4c8f5e3249163e429b3e~5IbxnYv3t2836228362epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601348235;
        bh=RFF/AUA1tonFt7bhsKJ+aqteROnuxL6A+SEx1vq3I58=;
        h=From:To:Cc:Subject:Date:References:From;
        b=j/n5Iegp8O4D9HaUX+6iSLDXKX/Dtkv7E5Lcq6mQlcVSkkeGo38ZCjP8ewYXPyHG9
         GPjSN3QDQuhV2f4CEcS/js74JpvqlFtfxOfKjRBCngoWmilwTD4ZkO4vxz7fh1TXXs
         Tpk2CPdCBHiv2Zdtz1YudhEAxfoVo+gVscFf4Goc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20200929025715epcas1p4ce232b9c9e55546b07426d1cae7a9b73~5IbxYPaWl1684816848epcas1p4X;
        Tue, 29 Sep 2020 02:57:15 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.161]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4C0kZL1lBHzMqYkX; Tue, 29 Sep
        2020 02:57:14 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.FA.09918.882A27F5; Tue, 29 Sep 2020 11:57:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200929025712epcas1p2a065ed9773f9933a08faf05240a5a1ec~5IbuwvYDD0742007420epcas1p2O;
        Tue, 29 Sep 2020 02:57:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200929025712epsmtrp15073afee7e347e1eb8389bdb6e4af3a6~5IbuwH_fH1019410194epsmtrp1b;
        Tue, 29 Sep 2020 02:57:12 +0000 (GMT)
X-AuditID: b6c32a36-729ff700000026be-36-5f72a2883142
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.C3.08604.882A27F5; Tue, 29 Sep 2020 11:57:12 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200929025712epsmtip1f426b99cc62c267288fd95e05f510c7e~5Ibul2Izn0830308303epsmtip1H;
        Tue, 29 Sep 2020 02:57:12 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     sj1557.seo@samsung.com,
        kohada.tetsuhiro@dc.mitsubishielectric.co.jp, kohada.t2@gmail.com,
        stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] exfat: fix use of uninitialized spinlock on error path
Date:   Tue, 29 Sep 2020 11:51:05 +0900
Message-Id: <20200929025105.14341-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsWy7bCmgW7HoqJ4g0czTC1+zL3NYvHm5FQW
        iz17T7JY/Jheb7Hl3xFWiwUbHzE6sHk0H1vJ5rFz1l12j74tqxg9Pm+SC2CJyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIFqkzIyehd+IGp4J1i
        xf8lC1kbGLtkuxg5OSQETCQW9D1mBLGFBHYwSpy+U9DFyAVkf2KUeL37FzuE841R4uD3e+ww
        HWvmfWGESOxllLj4ZwcTXEvz211sXYwcHGwC2hJ/toiCmCICihKX3zuBlDALLGCUWPb/KjPI
        IGEBd4nFX5eBrWYRUJU4/Pk4K4jNK2AjcaDnKSvEMnmJ1RsOMIM0SwgsYpc43vsX6goXiZNz
        X0IVCUu8Or4FKi4l8bK/jR1ksYRAtcTH/cwQ4Q5GiRffbSFsY4mb6zewgpQwC2hKrN+lDxFW
        lNj5ey7YOcwCfBLvvvawQkzhlehoE4IoUZXou3SYCcKWluhq/wC11ENi67+7LJBAjJX4MnUG
        ywRG2VkICxYwMq5iFEstKM5NTy02LDBCjqJNjODUpGW2g3HS2w96hxiZOBgPMUpwMCuJ8Prm
        FMQL8aYkVlalFuXHF5XmpBYfYjQFBtdEZinR5HxgcswriTc0NTI2NrYwMTM3MzVWEud9eEsh
        XkggPbEkNTs1tSC1CKaPiYNTqoHJ5lc158GHU69GlXuKNE6esLNwbvytLburtzjbO9lEMjHt
        /7XY53fCn0nT//zm7/h4X0B7v3pqyrbnf/QTy5nfqWs8aBONkb4tYSstN7P/LcvVALcEnXKH
        N+cCV77+ODP7wrykdH0dn6KNGtXmuwN8wi8Z732kcv747Elaz1s8Zzd//ZlY9HyhbKfa4pQ1
        089nL9hqqvL62eSszZlM187rq3y7oJ58Zs224M+9ylc2B7FoJ7+oYQ1Rq91b23h0v2Vv7u1V
        AhUXPm1TLTm149WMrX+ksnhzV67LEa5MerF0kqFidl2NteFH/isrM7ra5h7fOq1u3s5KsRVX
        BdfZMLE/Kao6u1JsW7R5yqO+BdL7lViKMxINtZiLihMBxfCzatYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEJMWRmVeSWpSXmKPExsWy7bCSnG7HoqJ4gxm9UhY/5t5msXhzciqL
        xZ69J1ksfkyvt9jy7wirxYKNjxgd2Dyaj61k89g56y67R9+WVYwenzfJBbBEcdmkpOZklqUW
        6dslcGX0LvzAVPBOseL/koWsDYxdsl2MnBwSAiYSa+Z9Yexi5OIQEtjNKPHr0UxWiIS0xLET
        Z5i7GDmAbGGJw4eLIWo+MEq035zBChJnE9CW+LNFFMQUEVCUuPzeCaSEWWAJo8SCWcfYQMYI
        C7hLLP66jBHEZhFQlTj8+TjYeF4BG4kDPU+hVslLrN5wgHkCI88CRoZVjJKpBcW56bnFhgWG
        eanlesWJucWleel6yfm5mxjBwaKluYNx+6oPeocYmTgYDzFKcDArifD65hTEC/GmJFZWpRbl
        xxeV5qQWH2KU5mBREue9UbgwTkggPbEkNTs1tSC1CCbLxMEp1cA06Xmcg8eDtDf9u5/a/k+6
        cjO0rGTV9iurfG30otQnW/uc+pVULrT3sITo36PfnixZxZj/I+Gau0DvZfN2FYfgXJv4uoVL
        LZ/FuUk63Er037UmWed42fqjcvvE579X8oyumKHd+5XXV3eLV/nthmXqRk/fX3rLJRJ9qq9Y
        hXWL8yVTjbAFnj+1Vk3kv2C+duuX1z96J+nu2Heo+U7ZzEIJkdCzUw+z3Tt/6fElsy8an37d
        WvpapiwiYefx2Ss39h66qtjOrBLMrJRVLNp14OStrGvb/Fz3eif+ObYhMvWnkfcXp32nMq/o
        1WyUcrHsCl1zrejkJdMjn749+B20RfXt5K2Rj0QK+h9vF1j+bUYkjxJLcUaioRZzUXEiAGdp
        wDKFAgAA
X-CMS-MailID: 20200929025712epcas1p2a065ed9773f9933a08faf05240a5a1ec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200929025712epcas1p2a065ed9773f9933a08faf05240a5a1ec
References: <CGME20200929025712epcas1p2a065ed9773f9933a08faf05240a5a1ec@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot reported warning message:

Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1d6/0x29e lib/dump_stack.c:118
 register_lock_class+0xf06/0x1520 kernel/locking/lockdep.c:893
 __lock_acquire+0xfd/0x2ae0 kernel/locking/lockdep.c:4320
 lock_acquire+0x148/0x720 kernel/locking/lockdep.c:5029
 __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
 _raw_spin_lock+0x2a/0x40 kernel/locking/spinlock.c:151
 spin_lock include/linux/spinlock.h:354 [inline]
 exfat_cache_inval_inode+0x30/0x280 fs/exfat/cache.c:226
 exfat_evict_inode+0x124/0x270 fs/exfat/inode.c:660
 evict+0x2bb/0x6d0 fs/inode.c:576
 exfat_fill_super+0x1e07/0x27d0 fs/exfat/super.c:681
 get_tree_bdev+0x3e9/0x5f0 fs/super.c:1342
 vfs_get_tree+0x88/0x270 fs/super.c:1547
 do_new_mount fs/namespace.c:2875 [inline]
 path_mount+0x179d/0x29e0 fs/namespace.c:3192
 do_mount fs/namespace.c:3205 [inline]
 __do_sys_mount fs/namespace.c:3413 [inline]
 __se_sys_mount+0x126/0x180 fs/namespace.c:3390
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

If exfat_read_root() returns an error, spinlock is used in 
exfat_evict_inode() without initialization. This patch combines
exfat_cache_init_inode() with exfat_inode_init_once() to initialize
spinlock by slab constructor.

Fixes: c35b6810c495 ("exfat: add exfat cache")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: syzbot <syzbot+b91107320911a26c9a95@syzkaller.appspotmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/cache.c    | 11 -----------
 fs/exfat/exfat_fs.h |  3 ++-
 fs/exfat/inode.c    |  2 --
 fs/exfat/super.c    |  5 ++++-
 4 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/exfat/cache.c b/fs/exfat/cache.c
index 03d0824fc368..5a2f119b7e8c 100644
--- a/fs/exfat/cache.c
+++ b/fs/exfat/cache.c
@@ -17,7 +17,6 @@
 #include "exfat_raw.h"
 #include "exfat_fs.h"
 
-#define EXFAT_CACHE_VALID	0
 #define EXFAT_MAX_CACHE		16
 
 struct exfat_cache {
@@ -61,16 +60,6 @@ void exfat_cache_shutdown(void)
 	kmem_cache_destroy(exfat_cachep);
 }
 
-void exfat_cache_init_inode(struct inode *inode)
-{
-	struct exfat_inode_info *ei = EXFAT_I(inode);
-
-	spin_lock_init(&ei->cache_lru_lock);
-	ei->nr_caches = 0;
-	ei->cache_valid_id = EXFAT_CACHE_VALID + 1;
-	INIT_LIST_HEAD(&ei->cache_lru);
-}
-
 static inline struct exfat_cache *exfat_cache_alloc(void)
 {
 	return kmem_cache_alloc(exfat_cachep, GFP_NOFS);
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index e586daf5a2e7..b8f0e829ecbd 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -248,6 +248,8 @@ struct exfat_sb_info {
 	struct rcu_head rcu;
 };
 
+#define EXFAT_CACHE_VALID	0
+
 /*
  * EXFAT file system inode in-memory data
  */
@@ -426,7 +428,6 @@ extern const struct dentry_operations exfat_utf8_dentry_ops;
 /* cache.c */
 int exfat_cache_init(void);
 void exfat_cache_shutdown(void);
-void exfat_cache_init_inode(struct inode *inode);
 void exfat_cache_inval_inode(struct inode *inode);
 int exfat_get_cluster(struct inode *inode, unsigned int cluster,
 		unsigned int *fclus, unsigned int *dclus,
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 687f77653187..730373e0965a 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -608,8 +608,6 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 	ei->i_crtime = info->crtime;
 	inode->i_atime = info->atime;
 
-	exfat_cache_init_inode(inode);
-
 	return 0;
 }
 
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index b29935a91b9b..3ffdce5c7384 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -375,7 +375,6 @@ static int exfat_read_root(struct inode *inode)
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
 		current_time(inode);
 	exfat_truncate_atime(&inode->i_atime);
-	exfat_cache_init_inode(inode);
 	return 0;
 }
 
@@ -762,6 +761,10 @@ static void exfat_inode_init_once(void *foo)
 {
 	struct exfat_inode_info *ei = (struct exfat_inode_info *)foo;
 
+	spin_lock_init(&ei->cache_lru_lock);
+	ei->nr_caches = 0;
+	ei->cache_valid_id = EXFAT_CACHE_VALID + 1;
+	INIT_LIST_HEAD(&ei->cache_lru);
 	INIT_HLIST_NODE(&ei->i_hash_fat);
 	inode_init_once(&ei->vfs_inode);
 }
-- 
2.17.1

