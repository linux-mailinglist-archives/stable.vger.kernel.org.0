Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66E522BAEE
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 02:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgGXAV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 20:21:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54329 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728278AbgGXAV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 20:21:26 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200724002123epoutp0442fcbe496f08d781c88fda56ce3abdef~kiFkF3KJG1269512695epoutp04b
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 00:21:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200724002123epoutp0442fcbe496f08d781c88fda56ce3abdef~kiFkF3KJG1269512695epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595550083;
        bh=eVuqzI7RiNW85AjNnm4UCOUnnSVtC1K5DOQxKb/CO9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3cHn6rbJzFTtIY0JRLsyGHukfp3aJbxXAoYR1O2scPppbLJBZQjeRXq7HypaiEix
         gwFW1/3Y1pxQ9m5JMxWLiY/dfKjAfGnrGnbeqGE3ijl74eyjsuTqmKaJ/zX7LDLUmQ
         zJ+a+GMkFEi0mtI3yWK2SvssQlTQL1oYGK+KqE7Y=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200724002123epcas1p1761639ada0bf894ef312fb9112ad176d~kiFj02qs_0290802908epcas1p1O;
        Fri, 24 Jul 2020 00:21:23 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.164]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BCVHQ4PqQzMqYkp; Fri, 24 Jul
        2020 00:21:22 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.92.29173.2892A1F5; Fri, 24 Jul 2020 09:21:22 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200724002122epcas1p3611340519231e6d365a603bcec134e39~kiFilY9rk3073230732epcas1p33;
        Fri, 24 Jul 2020 00:21:22 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724002122epsmtrp25597209608f104d023b467814737e3d2~kiFik110t3166431664epsmtrp2M;
        Fri, 24 Jul 2020 00:21:22 +0000 (GMT)
X-AuditID: b6c32a37-9cdff700000071f5-28-5f1a2982d131
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.88.08382.2892A1F5; Fri, 24 Jul 2020 09:21:22 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002122epsmtip2c3be1aa9668fb1f547552be0e0618870~kiFibVuaO0522305223epsmtip2r;
        Fri, 24 Jul 2020 00:21:22 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 2/4] exfat: fix wrong hint_stat initialization in
 exfat_find_dir_entry()
Date:   Fri, 24 Jul 2020 09:15:42 +0900
Message-Id: <20200724001544.30862-3-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724001544.30862-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmnm6TplS8waJbyhbNi9ezWfyYXm+x
        ac01NosFGx8xOrB4bFrVyeaxf+4ado++LasYPT5vkgtgicqxyUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMDQo0CtOzC0uzUvXS87PtTI0MDAyBapMyMnYOv0MW8FZ9orvf/YwNTAuZ+ti
        5OSQEDCRmPPlCUsXIxeHkMAORonbj05AOZ8YJVZtuMEM4XxjlFh+4zdQhh2s5RUbRHgvo0TL
        +cfMIJPAGjq+1nUxcnCwCWhL/NkiChIWETCUuPH5GgtImFnAUWLHPT6QsLBAgsSuGZvZQWwW
        AVWJdZ/fMoGU8ArYSGxodIc4TV5i9YYDYMM5BWwllv89CnaZhMAqdokbc2+zQBS5SLz/tYoV
        whaWeHV8CzuELSXx+d1eNpCZEgLVEh/3M0OEOxglXny3hbCNJW6u38AKcZmmxPpd+hBhRYmd
        v+cygtjMAnwS7772sEJM4ZXoaBOCKFGV6Lt0mAnClpboav8AtdRDYmn7HGjYTAAGx7IDrBMY
        5WYhbFjAyLiKUSy1oDg3PbXYsMAYOa42MYITk5b5DsZpbz/oHWJk4mA8xCjBwawkwqvDKB4v
        xJuSWFmVWpQfX1Sak1p8iNEUGHQTmaVEk/OBqTGvJN7Q1MjY2NjCxMzczNRYSZz331n2eCGB
        9MSS1OzU1ILUIpg+Jg5OqQamQzZBQndmC2SqHb14Wc/y0049IWOZMNVjjjvk967sbNV9d2Dh
        342etzvUHCfO4N6z3G79nNXTndY/2PJRMeyLyJ1KH97OPZZvLa7G2DZEO61x/9xadqz20+Tr
        gWt6vfQ4k9dsydz38k+J9/fzP1W+WGhHeH6N2ta02lmeiy8k3OSFiKjiytxzImdmlNs82VDE
        M2Pdzytb3x9NZluzYlLJ22RzuaMWe5K3bF7TYqKZ8PvlpJ2Cqlf2Gv02ObQ2UjFYvSPa2D2V
        sbBrccOsyoXpttcF9+cfF/3MumLv/Ad3Tj1afsmu1qb9Jv9jNybza/t48qNnPrgasGBCYuvz
        F1PZuQODzKbtcFJfHqXNMEE3QYmlOCPRUIu5qDgRAKuW8dHVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsWy7bCSvG6TplS8weomAYvmxevZLH5Mr7fY
        tOYam8WCjY8YHVg8Nq3qZPPYP3cNu0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBlbJ1+hq3g
        LHvF9z97mBoYl7N1MbJzSAiYSLwCsrg4hAR2M0pcnT6XuYuREygsLXHsxBkgmwPIFpY4fLgY
        JCwk8IFRovEuJ0iYTUBb4s8WURBTRMBYov1rGYjJLOAs8X6FGEixsECcxM0t21lAbBYBVYl1
        n98ygZTwCthIbGh0h1gjL7F6wwGwlZwCthLL/x5lgdhjIzHz+07GCYx8CxgZVjFKphYU56bn
        FhsWGOallusVJ+YWl+al6yXn525iBAePluYOxu2rPugdYmTiYDzEKMHBrCTCq8MoHi/Em5JY
        WZValB9fVJqTWnyIUZqDRUmc90bhwjghgfTEktTs1NSC1CKYLBMHp1QDU+Km23EBBnF1uvca
        dl5XfKR71WHi1jVLJqcoVQd+epgUk2kunzohJLJZQJXZzeKe5ZpFXb1XmVQZbkb2Rh+c4Kax
        6j0n4xbJpxp/fE8lFEleK/0SNfeUmfnnlTcb+Tdf3Dj9uyzD/KZN8qLPpGVKM8yeOhzZOevk
        W+GbM8P1Q6+HZ3tMuZU8++pOnYU/5ir/uVA+cY7w3o9+h289e/pgv/PJl5P/dRiZiU05EFmc
        uPer7erndvMDzNO6gqa8WPjhAntmlY172NyXfrL7rTQvR8ZzTJs17/6lAvGvmu11/DHZX+70
        7hE3akrJi1lZ7uB+/66U7CWPxk2SUQ8uHJI7mvlVn9tkV2ji6vV+QX9eNyuxFGckGmoxFxUn
        AgCxD9tAjQIAAA==
X-CMS-MailID: 20200724002122epcas1p3611340519231e6d365a603bcec134e39
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724002122epcas1p3611340519231e6d365a603bcec134e39
References: <20200724001544.30862-1-namjae.jeon@samsung.com>
        <CGME20200724002122epcas1p3611340519231e6d365a603bcec134e39@epcas1p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d2fa0c337d97a5490190b9f3b9c73c8f9f3602a1 ]

We found the wrong hint_stat initialization in exfat_find_dir_entry().
It should be initialized when cluster is EXFAT_EOF_CLUSTER.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org # v5.7
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 6db302d76d4c..0c244eb706bd 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -1160,7 +1160,7 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 			ret = exfat_get_next_cluster(sb, &clu.dir);
 		}
 
-		if (ret || clu.dir != EXFAT_EOF_CLUSTER) {
+		if (ret || clu.dir == EXFAT_EOF_CLUSTER) {
 			/* just initialized hint_stat */
 			hint_stat->clu = p_dir->dir;
 			hint_stat->eidx = 0;
-- 
2.17.1

