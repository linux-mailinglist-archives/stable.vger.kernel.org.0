Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2398721169D
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGAXZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:25:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39436 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbgGAXZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 19:25:42 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200701232539epoutp0387ad86ea06c56ab9431e7eb395d27ee6~dxInDw1pS1698916989epoutp03r
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:25:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200701232539epoutp0387ad86ea06c56ab9431e7eb395d27ee6~dxInDw1pS1698916989epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593645939;
        bh=yfHDBcOmyAol/fSQsoMxp1SdcyuyxlkiT9HWPeKM3qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rukcll5wxyHoGI2uB0uLI54VjIaWqRhQG+O9lYJi8L0p+yAwmWel2KQciMuNVMiOr
         F2eMiwsjCFMO+xqJNoWMOaRWEI0wWMfP+0DhqlsAact+tL6cICt2IxEprCifFjH2A7
         B9lHAMyiLrYbh9WzTBo6aohSLCLvGG4STfUQ1ys0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200701232538epcas1p195b2f3dc8dfe3c6cf0248fcc4480c92a~dxImx8x3l1843118431epcas1p1h;
        Wed,  1 Jul 2020 23:25:38 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.164]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49xy5F6LSCzMqYly; Wed,  1 Jul
        2020 23:25:37 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.4B.28581.17B1DFE5; Thu,  2 Jul 2020 08:25:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200701232537epcas1p37fafe2525f4164dc814b02ec9b18df2d~dxIlQ8z9S0140501405epcas1p35;
        Wed,  1 Jul 2020 23:25:37 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200701232537epsmtrp112fd8df96fd4ab855a176397395dc917~dxIlQTUwz1712317123epsmtrp1C;
        Wed,  1 Jul 2020 23:25:37 +0000 (GMT)
X-AuditID: b6c32a38-2e3ff70000006fa5-b7-5efd1b71feba
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.0C.08382.17B1DFE5; Thu,  2 Jul 2020 08:25:37 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200701232537epsmtip2abeb62e60fc35606b41cfeb6a6944008~dxIlIghLa2775727757epsmtip2W;
        Wed,  1 Jul 2020 23:25:37 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 2/5] exfat: add missing brelse() calls on error paths
Date:   Thu,  2 Jul 2020 08:20:21 +0900
Message-Id: <20200701232024.2083-3-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701232024.2083-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmnm6h9N84g+2LjC1e/5vOYtG8eD2b
        xeVdc9gsfkyvt9i05hqbxYKNjxgd2Dw2repk89g/dw27x8ent1g8+rasYvT4vEkugDUqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhQYFecWJucWleul5yfq6VoYGBkSlQZUJOxvOT
        KQUfeSp2TmphaWDcz9XFyMEhIWAiMeNdSRcjF4eQwA5GiT83HrNAOJ8YJb49vszexcgJ5Hxj
        lHixLRTEBmnYNesCG0TRXkaJVQdWsMJ1PPg8hQlkLJuAtsSfLaIgDSIChhI3Pl8Dm8os0M0o
        cfXOanaQGmEBb4mHM2RBalgEVCX6Ft1lBbF5BawlZk89ywqxTF5i9YYDzCA2p4CNxLpz/xlB
        5kgIHGKX6P59kQniBReJa2fMIOqFJV4d38IOYUtJvOxvY4coqZb4uJ8ZItwB9Mt3WwjbWOLm
        +g2sICXMApoS63fpQ4QVJXb+nssIYjML8Em8+9rDCjGFV6KjTQiiBOjgS4eZIGxpia72D1BL
        PSQe/5zPDAmQfkagojfMExjlZiFsWMDIuIpRLLWgODc9tdiwwAQ5sjYxghOXlsUOxrlvP+gd
        YmTiYDzEKMHBrCTCe9rgV5wQb0piZVVqUX58UWlOavEhRlNg0E1klhJNzgemzrySeENTI2Nj
        YwsTM3MzU2Mlcd6TVhfihATSE0tSs1NTC1KLYPqYODilGpjiZ2nuDZplIr9ifb+lufgeq+l3
        pZ01tyepLDNeNeO0qWmWVu3p4nOJi9WtPCf+nb5B+bf24tJ0P8ar++OTzi15bJngI1P9rznu
        yOyLk5rro0M/ZbLvZxM62n9cxCbboYzTwPoeq2m+dc2Tf/eZ1S+ZWXvZzzhr4p/5yODHOx7t
        tawSwWk3/XYYJcZGb61/82RTztxABS+usCvzgr8/v2UQ8b/8nZiQ8ddbAWZi/raJRyLL1r7Y
        ICJ212N+fUT+3J+HHG+9sHlZJha8KSP17DUpNYZpVV90Za4fPvF/2ZTiIOYzWSvuX+uf+/D2
        kWkGHTa+XvmmLJG8/Oz3/rja3BYPyDnkt/RTbDzjUmf500osxRmJhlrMRcWJAG5NWT/lAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42LZdlhJXrdQ+m+cQecGTovX/6azWDQvXs9m
        cXnXHDaLH9PrLTatucZmsWDjI0YHNo9NqzrZPPbPXcPu8fHpLRaPvi2rGD0+b5ILYI3isklJ
        zcksSy3St0vgynh+MqXgI0/FzkktLA2M+7m6GDk5JARMJHbNusDWxcjFISSwm1Hi+KNjbBAJ
        aYljJ84wdzFyANnCEocPF0PUfGCUWLljPStInE1AW+LPFlEQU0TAWKL9axlICbNAP6PEnUnf
        wUqEBbwlHs6QBZnIIqAq0bfoLiuIzStgLTF76llWiE3yEqs3HGAGsTkFbCTWnfvPCGILAdVs
        vPKSZQIj3wJGhlWMkqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMEhpqW5g3H7qg96hxiZ
        OBgPMUpwMCuJ8J42+BUnxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdG4cI4IYH0xJLU7NTUgtQi
        mCwTB6dUA1PXhWVh39QXvN30Ysax41f1j674dPTdyXun+vfzMpw89Uul7u0UvVtecx2FF+WZ
        OM+uM9z2UXKN9Z6fax89fW128aXo/lvM1fo3V/pzcCeL/vqkdntTxrv188RuKlsxp64sShWz
        XK8y0/f1EYXv7FddIjK50g++bK64vMnNQcM4e3uG35n2JMV/6it/T85jdTlWw6T6ZM/lfRcr
        5PZ9VG4UvMLbcPr9MjGvRocGw8aVa352bFrn+X1pdvPX+/cLPqZ48bzj8pHXVjiQ7B4ieW5d
        FWPf/RubruQ9D9leJLGfRfrygSuP/vRc3M0y7V2EucnxUm6Ro9vvvNS92ScYnbYrZFdxzCuJ
        2HwBhfLLM9PqlViKMxINtZiLihMBE0NpcKACAAA=
X-CMS-MailID: 20200701232537epcas1p37fafe2525f4164dc814b02ec9b18df2d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200701232537epcas1p37fafe2525f4164dc814b02ec9b18df2d
References: <20200701232024.2083-1-namjae.jeon@samsung.com>
        <CGME20200701232537epcas1p37fafe2525f4164dc814b02ec9b18df2d@epcas1p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

If the second exfat_get_dentry() call fails then we need to release
"old_bh" before returning.  There is a similar bug in exfat_move_file().

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7
Reported-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/namei.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index a2659a8a68a1..3bf1dbadab69 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1089,10 +1089,14 @@ static int exfat_rename_file(struct inode *inode, struct exfat_chain *p_dir,
 
 		epold = exfat_get_dentry(sb, p_dir, oldentry + 1, &old_bh,
 			&sector_old);
+		if (!epold)
+			return -EIO;
 		epnew = exfat_get_dentry(sb, p_dir, newentry + 1, &new_bh,
 			&sector_new);
-		if (!epold || !epnew)
+		if (!epnew) {
+			brelse(old_bh);
 			return -EIO;
+		}
 
 		memcpy(epnew, epold, DENTRY_SIZE);
 		exfat_update_bh(sb, new_bh, sync);
@@ -1173,10 +1177,14 @@ static int exfat_move_file(struct inode *inode, struct exfat_chain *p_olddir,
 
 	epmov = exfat_get_dentry(sb, p_olddir, oldentry + 1, &mov_bh,
 		&sector_mov);
+	if (!epmov)
+		return -EIO;
 	epnew = exfat_get_dentry(sb, p_newdir, newentry + 1, &new_bh,
 		&sector_new);
-	if (!epmov || !epnew)
+	if (!epnew) {
+		brelse(mov_bh);
 		return -EIO;
+	}
 
 	memcpy(epnew, epmov, DENTRY_SIZE);
 	exfat_update_bh(sb, new_bh, IS_DIRSYNC(inode));
-- 
2.17.1

