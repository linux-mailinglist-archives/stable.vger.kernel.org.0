Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA1A432C7B
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 05:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhJSEBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 00:01:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25445 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhJSEBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 00:01:16 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20211019035902epoutp02bf13bc1271fbc604db4c2d6e510473ad~vUooAQFPf0361903619epoutp02u
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 03:59:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20211019035902epoutp02bf13bc1271fbc604db4c2d6e510473ad~vUooAQFPf0361903619epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634615942;
        bh=6Stezxv3+1g4VVikXbO6Xe+Y7JYlfPcCl4cIOXflBUw=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fDDHBDnJpvfrkgedzGxr+ZodUmLPJ0Uy/d7HiRhSrRq5u6UrQZZU5PZcJhY/IRI1e
         2ibSGPQXXXbGEIVNEPVr0PPWAPa27MLwO095GHSxj8tWw3O0PR/QkRjJnAKehwQXZE
         9tb+RCcdM1VmzeEAYnWkKE7CZRfx51T9iLBOMQ2A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20211019035902epcas1p492c29fc746e50366e8afd6506d6cb1ea~vUonpWS6T1917719177epcas1p4C;
        Tue, 19 Oct 2021 03:59:02 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.38.243]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HYKjw03r7z4x9QH; Tue, 19 Oct
        2021 03:59:00 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.D5.09592.3824E616; Tue, 19 Oct 2021 12:58:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20211019035859epcas1p2159196db5ecc5d171adc340e527dedb7~vUolByfCr0447604476epcas1p2u;
        Tue, 19 Oct 2021 03:58:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211019035859epsmtrp16b0e10a0cfea264614b390cfc3cbddb8~vUolBF3rB3273732737epsmtrp14;
        Tue, 19 Oct 2021 03:58:59 +0000 (GMT)
X-AuditID: b6c32a37-2a5ff70000002578-8f-616e428315d8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.BD.08902.3824E616; Tue, 19 Oct 2021 12:58:59 +0900 (KST)
Received: from U14PB1-0870.tn.corp.samsungelectronics.net (unknown
        [10.253.235.196]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211019035859epsmtip23b362459e1467924e5d81d07bca60570~vUok1jSv22381023810epsmtip2y;
        Tue, 19 Oct 2021 03:58:59 +0000 (GMT)
From:   Sungjong Seo <sj1557.seo@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linkinjeon@kernel.org, stable@vger.kernel.org,
        sj1557.seo@samsung.com
Subject: [PATCH] exfat: fix incorrect loading of i_blocks for large files
Date:   Tue, 19 Oct 2021 12:58:30 +0900
Message-Id: <20211019035830.27784-1-sj1557.seo@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7bCmgW6zU16iwa5+JYuJ05YyW+zZe5LF
        Ysu/I6wWCzY+YnRg8di0qpPNo2/LKkaPz5vkApijsm0yUhNTUosUUvOS81My89JtlbyD453j
        Tc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgLYpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yV
        UgtScgrMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzVp12L1jEUdHQf5uxgfEXWxcjJ4eEgInE
        7pMbmLoYuTiEBHYwSkw4O48FwvnEKHHl3Q4o5xujxIFZIBmIlsdb/zNCJPYCtZzvZINwOpkk
        /u7+AVbFJqAtsbxpGXMXIweHiICixOX3TiBhZgFPiTlL5zOC2MJA9tLrd8BsFgFVifbe20wg
        Nq+AtUTX1VZWiGXyEqs3HGAGmS8h0M4u0f31ITtEwkViy48LjBC2sMSr41ug4lISL/vboOx6
        if/z17JDNLcwSjz8tI0J5CAJAXuJ95csQExmAU2J9bv0IcoVJXb+nssIcSefxLuvPawQ1bwS
        HW1CECUqEt8/7GSB2XTlx1UmCNtD4sScp2BxIYFYifubFjFOYJSdhbBgASPjKkax1ILi3PTU
        YsMCY3gcJefnbmIEpx8t8x2M095+0DvEyMTBeIhRgoNZSYQ3yTU3UYg3JbGyKrUoP76oNCe1
        +BCjKTC8JjJLiSbnAxNgXkm8oYmlgYmZkYmFsaWxmZI4r6RodqKQQHpiSWp2ampBahFMHxMH
        p1QDk335g0SGnMyJmz3LXCSaD8281hvR1574dW/o9AeHf7J2fYx0nsp/PoJtqod4ZIK7jPaj
        D2e37v4ro5a3dsoXJj69k4wZk/lPLG3jXKvx+05g/d9WPe+1eX0Sm3hyT+1Ys3pK6IeptR+Y
        2ROdji953rdo/oRHm3L5q52y2DaU6OxJ+jf7yY7b9kfytx6MlFjf+mzN34020w0nPTyvGXz8
        3PtCfdkXKw3PPX+2wdFFQ+XeZVdN2/LaDf4SWR3Tv099oWty5cGUxJOJy1rmHdKRCQqdJOgs
        +LV64oP2uSma7tNFmi6HiN5te5moGnWjzurMzOAd7nuMKh58WNhdPL/KbzqL2LMc7nXyzwLl
        OmL+hymxFGckGmoxFxUnAgCNOYt6yAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsWy7bCSvG6zU16iwc1lHBYTpy1lttiz9ySL
        xZZ/R1gtFmx8xOjA4rFpVSebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGWsOu1esIijoqH/
        NmMD4y+2LkZODgkBE4nHW/8zdjFycQgJ7GaUOHRqAWsXIwdQQkri4D5NCFNY4vDhYoiSdiaJ
        /q/dLCC9bALaEsubljGD1IgIKEpcfu8EYjIL+EosXl8FUiEs4Cmx9PodRhCbRUBVor33NhOI
        zStgLdF1tZUV4gJ5idUbDjBPYORZwMiwilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMj
        OBS0NHcwbl/1Qe8QIxMH4yFGCQ5mJRHeJNfcRCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pO
        xgsJpCeWpGanphakFsFkmTg4pRqY1vc6Bh3dZaG1Tuqg47sJ3SE/wlYlepjf6lN3VbG2+yJy
        kcFyf2xd5ofOqN2lv1Zy8/2sXsipFaFk9qWrYEve/bplLTNY87JyGlas0ewQ+dEvVHX60JfS
        yEVP3RO03U+0/Dq96uaimUKBb/Kktv58yN+ppf3RUOmH7add0fzKdh/OO9Z2ShS/TdrrcXe6
        YEJw9WPZNY5tijy3ph+qm3S17OjDjp9bC9a5CJU9PbxZcYJ53W2ORUc2zrM28fmy9t2hk2It
        r4/cXN286pXGdYW/fffmrH7C5baxbt9/l4B3p3Lmq4eJldh+Ovzj5xz2k4kfVreoclRa2RWm
        LHkplCv789P+378StPUtvewUvP8/VWIpzkg01GIuKk4EALdqr+l0AgAA
X-CMS-MailID: 20211019035859epcas1p2159196db5ecc5d171adc340e527dedb7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211019035859epcas1p2159196db5ecc5d171adc340e527dedb7
References: <CGME20211019035859epcas1p2159196db5ecc5d171adc340e527dedb7@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When calculating i_blocks, there was a mistake that was masked with a 32-bit
variable. So i_blocks for files larger than 4 GiB had incorrect values.
Mask with a 64-bit variable instead of 32-bit one.

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Ganapathi Kamath <hgkamath@hotmail.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
---
 fs/exfat/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index ca37d4344361..1c7aa1ea4724 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -604,7 +604,7 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 	exfat_save_attr(inode, info->attr);
 
 	inode->i_blocks = ((i_size_read(inode) + (sbi->cluster_size - 1)) &
-		~(sbi->cluster_size - 1)) >> inode->i_blkbits;
+		~((loff_t)sbi->cluster_size - 1)) >> inode->i_blkbits;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
-- 
2.17.1

