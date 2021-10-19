Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B9D432DF5
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 08:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhJSGRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 02:17:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33138 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhJSGRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 02:17:07 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211019061453epoutp046187f7ccafadc65db49093212ca02afc~vWfPPkiNB3215132151epoutp04s
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 06:14:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211019061453epoutp046187f7ccafadc65db49093212ca02afc~vWfPPkiNB3215132151epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634624093;
        bh=CXDwDJ2iAuEoy33TXgOJHbWwG+MzTYTRk+KVciM3jW0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=gnalOqzyZ2Fc67De3NS00k1d6bXrhY0IFca3a54HwrmiyAw5VkghNGRtIARt08epk
         Q2og8l3AHylV/dItxurTMvx8BR6q87GSAO33M8++7ViLs6MpEDdnIs06328a3zjr8Q
         qNtpBVHHhepiFw9J+JgPUagNsY9sBjBvAVGY3A0g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211019061453epcas1p2a09e725753f96baff8fbe9817d123741~vWfO_LU5P2515425154epcas1p23;
        Tue, 19 Oct 2021 06:14:53 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.247]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HYNkf65qNz4x9QB; Tue, 19 Oct
        2021 06:14:50 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.FD.09592.8526E616; Tue, 19 Oct 2021 15:14:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211019061448epcas1p1c6951207ef0ba73f1ef17862bb4495ff~vWfKMwB5r2206422064epcas1p16;
        Tue, 19 Oct 2021 06:14:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211019061447epsmtrp124f93e1a3a5a1bbcff4c4fa1be6c2c33~vWfKGj9uo2090420904epsmtrp1f;
        Tue, 19 Oct 2021 06:14:47 +0000 (GMT)
X-AuditID: b6c32a39-3bdff70000002578-b2-616e62582e7c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        10.8E.08738.7526E616; Tue, 19 Oct 2021 15:14:47 +0900 (KST)
Received: from U14PB1-0870.tn.corp.samsungelectronics.net (unknown
        [10.253.235.196]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211019061447epsmtip199fc694776b38d56369da51fd0106a73~vWfJ7xoHU0336903369epsmtip1b;
        Tue, 19 Oct 2021 06:14:47 +0000 (GMT)
From:   Sungjong Seo <sj1557.seo@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     stable@vger.kernel.org, linkinjeon@kernel.org,
        sj1557.seo@samsung.com
Subject: [PATCH v2] exfat: fix incorrect loading of i_blocks for large files
Date:   Tue, 19 Oct 2021 15:14:21 +0900
Message-Id: <20211019061421.23706-1-sj1557.seo@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7bCmrm5EUl6iwaa94hYTpy1lttiz9ySL
        xZZ/R1gtFmx8xOjA4rFpVSebR9+WVYwenzfJBTBHZdtkpCampBYppOYl56dk5qXbKnkHxzvH
        m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gq
        pRak5BSYFegVJ+YWl+al6+WlllgZGhgYmQIVJmRn3GtfwFjwmKNi9uZrjA2Ma9m7GDk5JARM
        JGZN6WfrYuTiEBLYwSjR1PaDCcL5xCjx6c97RgjnM6NE44N1TDAtGz88hErsYpSY9+4oO4TT
        ySQx7fRSsMFsAtoSy5uWMXcxcnCICChKXH7vBBJmFvCUuHO6hRnEFhbwkWjfMokRxGYRUJW4
        N3E1WJxXwFriwtR/UPfJS6zecIAZZL6EQDu7xKcpLVBXuEj0HZjBCmELS7w6vgWqQUriZX8b
        lF0v8X/+WnaI5hZGiYeftjGBHCQhYC/x/pIFiMksoCmxfpc+RLmixM7fcxkh7uSTePe1hxWi
        mleio00IokRF4vuHnSwwm678uAp1jYfEpzcb2UDKhQRiJdb8lZzAKDsLYf4CRsZVjGKpBcW5
        6anFhgWm8DhKzs/dxAhOP1qWOxinv/2gd4iRiYPxEKMEB7OSCG+Sa26iEG9KYmVValF+fFFp
        TmrxIUZTYHBNZJYSTc4HJsC8knhDE0sDEzMjEwtjS2MzJXFeSdHsRCGB9MSS1OzU1ILUIpg+
        Jg5OqQamNDsHjq8hc95qGNtd5ty6X8bmLscWVzXhs2c7OQSu/dn4Q5bvqqXb1OIyoXebrthk
        xe879OOMQcMr43/qv9545TjVuh58W9isc3Sm0sIVGnmXpxtNietxlPy0nCXBTyE66M/zSu+i
        ToXtxmFqXtOmZ3tN/sZgZxMwm+/JGrNV78NkowPfm9lKZbptqjCM8u7rOPn3dsWTbGMmU/7d
        /r+KM3I22R1rOn+kPTGQ6/+/QMeOyQYK3it43s7Z1mr3e4qA8xHvyR7Tvcw6303ZY3AijN2o
        06i4gMnn/kxb5sJath2/Zm3zLI0T8zFYqfon7Or2KdkXeJb3G2gY/DlyeLcFyz3jx6E/l62t
        6jy3Z5sSS3FGoqEWc1FxIgAXdKP1yAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsWy7bCSnG54Ul6iwdwuU4uJ05YyW+zZe5LF
        Ysu/I6wWCzY+YnRg8di0qpPNo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDLutS9gLHjMUTF7
        8zXGBsa17F2MnBwSAiYSGz88ZOxi5OIQEtjBKNHzYD9LFyMHUEJK4uA+TQhTWOLw4WKIknYm
        iRvbHrKB9LIJaEssb1rGDFIjIqAocfm9E0iYWcBXYtHuz4wgtrCAj0T7lklgNouAqsS9iauZ
        QWxeAWuJC1P/QZ0gL7F6wwHmCYw8CxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525i
        BIeDltYOxj2rPugdYmTiYDzEKMHBrCTCm+SamyjEm5JYWZValB9fVJqTWnyIUZqDRUmc90LX
        yXghgfTEktTs1NSC1CKYLBMHp1QDU9JklzUaG6awTJt35qD4tmNXrp8IX3J13i/z+vIDQq9i
        DbbvveK4PeXOzl0BXw0+bK46fOtLa1C1K6+d4OmX/FflpYzUppj5LlPWtHPmXVmQIPJNTyLo
        ZNS3FdKix5bWO3vrZSmK/uC6y3snS8Hm1f7pMto+p+QeTDKMNggvNzgUWqj9u+fFHMG2D8us
        bEUVlXt9f9yP5/4QdO72A+5rfYwXvhpbmK2M+da6+PF+l+tK6nFGq7YZv3t3ujVktqLt0nWX
        Jyl1mbx3EjgkbFf/XUG25XPSUQVjT1a9Vwur8rfOuSwwS3jPxeV8Pfp33Gd4i+r29r+ebr2L
        zbD7oNufOVKTa44vWHFc4aOb4BSmbiWW4oxEQy3mouJEAEl1tbp2AgAA
X-CMS-MailID: 20211019061448epcas1p1c6951207ef0ba73f1ef17862bb4495ff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211019061448epcas1p1c6951207ef0ba73f1ef17862bb4495ff
References: <CGME20211019061448epcas1p1c6951207ef0ba73f1ef17862bb4495ff@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When calculating i_blocks, there was a mistake that was masked with a
32-bit variable. So i_blocks for files larger than 4 GiB had incorrect
values. Mask with a 64-bit variable instead of 32-bit one.

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7+
Reported-by: Ganapathi Kamath <hgkamath@hotmail.com>
Signed-off-by: Sungjong Seo <sj1557.seo@samsung.com>
---
v2:
 - Fix maximum 75 characters warning from checkpatch.pl.

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

