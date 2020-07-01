Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA252116A0
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgGAXZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:25:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39448 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbgGAXZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 19:25:43 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200701232541epoutp03846e9c80fd94ca5622f4cca1b026cad3~dxIo4dbdR1698916989epoutp03s
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:25:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200701232541epoutp03846e9c80fd94ca5622f4cca1b026cad3~dxIo4dbdR1698916989epoutp03s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593645941;
        bh=g8leJMPGlyebLqo38dOH+g6HIGb9Iw/k3OTSYjC+6x4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFfIae4Jt7r+se++s9HyQpS51tbxNs8PRxTHGwgJZkvbbcwnj2mwT53NscbgcoGh0
         3GCQBLj/dAlUZEc/MODvQqcSZRPBgZWWcTgrsqtvZpWQ2LY7V1OvNQ9eBo/PGCAdzT
         9As0BenBWtXnvqlPOoxCdzMAqAiXIaKMEPsInQ3E=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200701232540epcas1p290531fa0803c7d9c32e0861aae1d2234~dxIoiPSZf1693016930epcas1p2b;
        Wed,  1 Jul 2020 23:25:40 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.166]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49xy5H4jMxzMqYkh; Wed,  1 Jul
        2020 23:25:39 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.1B.19033.37B1DFE5; Thu,  2 Jul 2020 08:25:39 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200701232538epcas1p1219929c259f41782831936a2afeeafdf~dxImy7Om81844818448epcas1p1P;
        Wed,  1 Jul 2020 23:25:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200701232538epsmtrp22eda4037d4cb830adc90d83c7c864ea2~dxImyNx7W1851918519epsmtrp26;
        Wed,  1 Jul 2020 23:25:38 +0000 (GMT)
X-AuditID: b6c32a36-159ff70000004a59-77-5efd1b73eb61
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.AE.08303.27B1DFE5; Thu,  2 Jul 2020 08:25:38 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200701232538epsmtip268bbfa7188593f9f9346a4a0cc8f13ea~dxImm4CUv2699026990epsmtip2h;
        Wed,  1 Jul 2020 23:25:38 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 4/5] exfat: move setting VOL_DIRTY over
 exfat_remove_entries()
Date:   Thu,  2 Jul 2020 08:20:23 +0900
Message-Id: <20200701232024.2083-5-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701232024.2083-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmnm6x9N84gwcnlS2aF69ns7i8aw6b
        xY/p9Rab1lxjs1iw8RGjA6vHplWdbB77565h9+jbsorR4/MmuQCWqBybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCQ4MCveLE3OLSvHS95PxcK0MDAyNToMqEnIxLh9uYC55xVPxZ2svY
        wLiZvYuRk0NCwERiWvMnli5GLg4hgR2MEj93/IZyPjFKXG/azAjhfGaU2Dt3PVxLz75nUIld
        jBLTzt5nhmt5sPA4UBUHB5uAtsSfLaIgDSIChhI3Pl9jAQkzCyRKnN/rChIWFgiT6H92DKya
        RUBV4vphfpAwr4C1xMWNMKvkJVZvOMAMYnMK2EisO/efESK+jl1i3p4wCNtF4sGbM2wQtrDE
        q+NboHqlJD6/28sGMl5CoFri435miHAHo8SL77YQtrHEzfUbWCEO05RYv0sfIqwosfP3XLBN
        zAJ8Eu++9rBCTOGV6GgTgihRlei7dJgJwpaW6Gr/ALXUQ2LmxTcsILaQQD+jxN8GtQmMcrMQ
        FixgZFzFKJZaUJybnlpsWGCEHFmbGMFJSstsB+Oktx/0DjEycTAeYpTgYFYS4T1t8CtOiDcl
        sbIqtSg/vqg0J7X4EKMpMOAmMkuJJucD02ReSbyhqZGxsbGFiZm5mamxkjivmsyFOCGB9MSS
        1OzU1ILUIpg+Jg5OqQYmjtjUV1av/BYKPXra0KWgwHjhf/LRCQefaHFYTTr30K1TiT0malHn
        zCURnRt622SeWdz+Gpm9J+yOwX/765v+HD+2OdDkww+93MNdfX5fGioUfmWl2H3/eWmu1glH
        5gs/Nv10yo+ccub1xyW/J2gyf6yR2BDxJG655heRDo2213vjrxuZ+7ySPvK/2yWv8mKDscWE
        tG1mK5KbZxRrlXubLNZ8JsTPz3H01O7o1OOd/zez8zBzf81N3SrAeURM/bh6+NKe5ifJFhUh
        D2cohF8/vN3kkWpYUYx7ytSvry++0KxIuSt1lu/o17krTdb9DEsTezudL99jvv0eHqlMq9XV
        vXPDOj//0m6yXS5wx2iJEktxRqKhFnNRcSIAZFGgH9sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42LZdlhJXrdI+m+cwY2F+hbNi9ezWVzeNYfN
        4sf0eotNa66xWSzY+IjRgdVj06pONo/9c9ewe/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
        pcNtzAXPOCr+LO1lbGDczN7FyMkhIWAi0bPvGWMXIxeHkMAORol3t1YxQSSkJY6dOMPcxcgB
        ZAtLHD5cDFHzgVGidfNmNpA4m4C2xJ8toiCmiICxRPvXMhCTWSBZYv9eC5AhwgIhEjcOrgYb
        wiKgKnH9MD9ImFfAWuLixvVQB8hLrN5wgBnE5hSwkVh37j8jiC0EVLPxykuWCYx8CxgZVjFK
        phYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBAeTltYOxj2rPugdYmTiYDzEKMHBrCTCe9rg
        V5wQb0piZVVqUX58UWlOavEhRmkOFiVx3q+zFsYJCaQnlqRmp6YWpBbBZJk4OKUamFx8pwpt
        cZcKijPfs9PTJEXQ4GbVNuvTzo8+3Fj3JeXHwsaX2XeNmUvmdrw5cuF6HMdX5ge9/p1+8XsU
        kn32JPg2eQgnHQz6/6nQOWrZFK4TtyVLGVM3qFh7GQk6Hbj2dH+e1pvgmX+ueB3cXeXDfXvN
        cxXzi83bNlZ7yqxVMY075Pb5cvFpXQYV3oWT7d4K1PIIiOyfX7Zou9W9y2FntnxzDPvK/k20
        4pDstZwNN6r9i8/6Wlg6cd1kXrv50HJ+n6yoG0pT/sfYntLoLHG7WDJD7XaAiNCT3JWrayru
        PpVtyM6Runyv/KBmdG6U2zv7XYVrDs7iuLSyYHFQppU028eiYsZtnncWz2aVaODfo8RSnJFo
        qMVcVJwIABBkqN6VAgAA
X-CMS-MailID: 20200701232538epcas1p1219929c259f41782831936a2afeeafdf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200701232538epcas1p1219929c259f41782831936a2afeeafdf
References: <20200701232024.2083-1-namjae.jeon@samsung.com>
        <CGME20200701232538epcas1p1219929c259f41782831936a2afeeafdf@epcas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Move setting VOL_DIRTY over exfat_remove_entries() to avoid unneeded
leaving VOL_DIRTY on -ENOTEMPTY.

Fixes: 5f2aa075070c ("exfat: add inode operations")
Cc: stable@vger.kernel.org # v5.7
Reported-by: Tetsuhiro Kohada <kohada.t2@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 3bf1dbadab69..2c9c78317721 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -984,7 +984,6 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 		goto unlock;
 	}
 
-	exfat_set_vol_flags(sb, VOL_DIRTY);
 	exfat_chain_set(&clu_to_free, ei->start_clu,
 		EXFAT_B_TO_CLU_ROUND_UP(i_size_read(inode), sbi), ei->flags);
 
@@ -1012,6 +1011,7 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 	num_entries++;
 	brelse(bh);
 
+	exfat_set_vol_flags(sb, VOL_DIRTY);
 	err = exfat_remove_entries(dir, &cdir, entry, 0, num_entries);
 	if (err) {
 		exfat_msg(sb, KERN_ERR,
-- 
2.17.1

