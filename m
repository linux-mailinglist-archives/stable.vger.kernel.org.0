Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A38D3A3901
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 02:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhFKAv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 20:51:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46168 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFKAv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 20:51:57 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210611004958epoutp02e0f254c8aaa6c340fd93be97bb9b2fd0~HYMcKPcRB0475804758epoutp02e
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 00:49:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210611004958epoutp02e0f254c8aaa6c340fd93be97bb9b2fd0~HYMcKPcRB0475804758epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623372598;
        bh=ZV21zXbl07d7cp0KvB+WQtAe5AHBkLEtsV1joA1DbWQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=dZA9cuEUblKFJHorJcONG0KdK4D/epAIhJjI5aA9+X/4ZmNqfVmz2/RNece7q1nsZ
         +14JVSzkP+YOqA2iqCb4bVKQP4dNbJVM/8YxkZ93Htq+2RwI8AgH7XVhZJHObOCYEY
         0ZiO+eNbQVM+8bsYIpuS2+wfXKNjjsI3/yCc7l74=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210611004958epcas1p15b8a8cfc43a0b30b595a62ba4559eebb~HYMbwS0ha1177411774epcas1p1u;
        Fri, 11 Jun 2021 00:49:58 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.161]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G1Mgn0vc9z4x9Q7; Fri, 11 Jun
        2021 00:49:57 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.A0.10258.433B2C06; Fri, 11 Jun 2021 09:49:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210611004956epcas1p262dc7907165782173692d7cf9e571dfe~HYMaTmy4k0189501895epcas1p29;
        Fri, 11 Jun 2021 00:49:56 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210611004956epsmtrp18166ae745678cd1e66c34303c4f0b915~HYMaTAWdk0756907569epsmtrp11;
        Fri, 11 Jun 2021 00:49:56 +0000 (GMT)
X-AuditID: b6c32a38-419ff70000002812-9d-60c2b334c995
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.1D.08163.433B2C06; Fri, 11 Jun 2021 09:49:56 +0900 (KST)
Received: from localhost.localdomain (unknown [10.89.31.219]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210611004956epsmtip1cb09a8fd89adf58c7ae43308b1dc1836~HYMaKgubk0118401184epsmtip1-;
        Fri, 11 Jun 2021 00:49:56 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     flrncrmr@gmail.com, Namjae Jeon <namjae.jeon@samsung.com>,
        stable@vger.kernel.org
Subject: [PATCH] exfat: handle wrong stream entry size in exfat_readdir()
Date:   Fri, 11 Jun 2021 09:40:24 +0900
Message-Id: <20210611004024.2925-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmga7J5kMJBou32Vj0rl3AZrFn70kW
        ix/T6y0WbHzE6MDisXPWXXaPvi2rGD0+b5ILYI7KsclITUxJLVJIzUvOT8nMS7dV8g6Od443
        NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqakUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVK
        LUjJKTA0KNArTswtLs1L10vOz7UyNDAwMgWqTMjJ2P5uC1PBa+GKu//3sjQwbhboYuTkkBAw
        kfjV8JK9i5GLQ0hgB6NEw/FfbBDOJ0aJjv+PoDKfGSWePu9nhmm53beaBSKxi1Fi858nTHAt
        B/f8Y+xi5OBgE9CW+LNFFMQUEVCUuPzeCaSXWSBcYtfzFSwgtrCAp8Sb5lVg1SwCqhILlvmC
        hHkFrCXmz9gJtUpeYvWGA8wg0yUEutklXl88zw6RcJGY0X+IBcIWlnh1fAtUXEriZX8blF0u
        ceLkLyYIu0Ziw7x97CC7JASMJXpelICYzAKaEut36UNUKErs/D2XEeJKPol3X3tYIap5JTra
        hCBKVCX6Lh2GGigt0dX+AWqRh8TphffAjhESiJWYNn01+wRG2VkICxYwMq5iFEstKM5NTy02
        LDBBjqFNjODUo2Wxg3Hu2w96hxiZOBgPMUpwMCuJ8O5ceShBiDclsbIqtSg/vqg0J7X4EKMp
        MLQmMkuJJucDk19eSbyhqZGxsbGFiZm5mamxkjjvTjagJoH0xJLU7NTUgtQimD4mDk6pBqY5
        WnKcnwNWB4Vstjuw5tf0TXGzmRawGhfEh1/i8nyxfdpiN6n3azauE7/588uZ+eetQqy6BZ6t
        VNSaOPv11Osvat/Ux+nHJDawXnjeeiNd68O1U4r2M4ySuXOjFq+w+Bc86/bSliUxb51PPxNT
        fPB8f98VtfRNy6S7l2w/c3r353UXc3I7DQuZ6yUD6oS1Im5/2vKDzeMAz8ej95fccrnz4WT2
        ZOVc9dhtSrvvsnMLCZh2t+6tzPG2VTf2WRAYt/36BhH+a941fQJmj27vWm4/e4NKMvcuprgX
        rlvfHVrVeuvbxAgPhsf+PZvey7Cs/tgiv4fjlJHhrqI2a79dG74XHLLqfnMx661zplhWr+F7
        JZbijERDLeai4kQA/aXDY8YDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsWy7bCSnK7J5kMJBpsvqVr0rl3AZrFn70kW
        ix/T6y0WbHzE6MDisXPWXXaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgytj+bgtTwWvhirv/
        97I0MG4W6GLk5JAQMJG43beapYuRi0NIYAejxNVLXUwQCWmJYyfOMHcxcgDZwhKHDxeDhIUE
        PjBK/N5pCxJmE9CW+LNFFMQUEVCUuPzeCaSCWSBSYtmOi4wgtrCAp8Sb5lWMICUsAqoSC5b5
        goR5Bawl5s/YyQyxR15i9YYDzBMYeRYwMqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/d
        xAgOBC2tHYx7Vn3QO8TIxMF4iFGCg1lJhHfnykMJQrwpiZVVqUX58UWlOanFhxilOViUxHkv
        dJ2MFxJITyxJzU5NLUgtgskycXBKNTCVW1r3BFUXXpVjeti+R9ht5TIjJ9tPzrWJ4te1Srlu
        veF/3R8jtCDhWEyu8d35/2xKDQq1/wRJmOaeUO6befuW0VJ709uzLSSiFG3lPVcc3Klb9NpO
        76PowjtruL/2m0a4XzsYnpxnHncysD/heLVXaVZXUOjtX+LP2CZ4OES+1Lq7b+6FiXOl/0/b
        OOXL64iAhoKtMWJxJz2fZ0Wu+fdj6+HvXfzrm2c8Xqx1T9jw7n/HwyI/A7Z0e8qx8tbfXOeR
        0PD5c6xUw1s2DUeut3uOyP79sEnT8cK+2sIEfp79llsyDOJaDlx9dqRqq+q3vZuUG7bsn9LQ
        71Bu9ahjt7Uzi3moQvbpjPXHLxUW8yqxFGckGmoxFxUnAgBk6l6FcwIAAA==
X-CMS-MailID: 20210611004956epcas1p262dc7907165782173692d7cf9e571dfe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210611004956epcas1p262dc7907165782173692d7cf9e571dfe
References: <CGME20210611004956epcas1p262dc7907165782173692d7cf9e571dfe@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The compatibility issue between linux exfat and exfat of some camera
company was reported from Florian. In their exfat, if the number of files
exceeds any limit, the DataLength in stream entry of the directory is
no longer updated. So some files created from camera does not show in
linux exfat. because linux exfat doesn't allow that cpos becomes larger
than DataLength of stream entry. This patch check DataLength in stream
entry only if the type is ALLOC_NO_FAT_CHAIN and add the check ensure
that dentry offset does not exceed max dentries size(256 MB) to avoid
the circular FAT chain issue.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org # v5.9
Reported-by: Florian Cramer <flrncrmr@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/dir.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index c4523648472a..f4e4d8d9894d 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -63,7 +63,7 @@ static void exfat_get_uniname_from_ext_entry(struct super_block *sb,
 static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_entry *dir_entry)
 {
 	int i, dentries_per_clu, dentries_per_clu_bits = 0, num_ext;
-	unsigned int type, clu_offset;
+	unsigned int type, clu_offset, max_dentries;
 	sector_t sector;
 	struct exfat_chain dir, clu;
 	struct exfat_uni_name uni_name;
@@ -86,6 +86,8 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 
 	dentries_per_clu = sbi->dentries_per_clu;
 	dentries_per_clu_bits = ilog2(dentries_per_clu);
+	max_dentries = (unsigned int)min_t(u64, MAX_EXFAT_DENTRIES,
+					   (u64)sbi->num_clusters << dentries_per_clu_bits);
 
 	clu_offset = dentry >> dentries_per_clu_bits;
 	exfat_chain_dup(&clu, &dir);
@@ -109,7 +111,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 		}
 	}
 
-	while (clu.dir != EXFAT_EOF_CLUSTER) {
+	while (clu.dir != EXFAT_EOF_CLUSTER && dentry < max_dentries) {
 		i = dentry & (dentries_per_clu - 1);
 
 		for ( ; i < dentries_per_clu; i++, dentry++) {
@@ -245,7 +247,7 @@ static int exfat_iterate(struct file *filp, struct dir_context *ctx)
 	if (err)
 		goto unlock;
 get_new:
-	if (cpos >= i_size_read(inode))
+	if (ei->flags == ALLOC_NO_FAT_CHAIN && cpos >= i_size_read(inode))
 		goto end_of_dir;
 
 	err = exfat_readdir(inode, &cpos, &de);
-- 
2.17.1

