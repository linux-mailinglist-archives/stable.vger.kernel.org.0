Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF661FC785
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 09:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgFQHfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 03:35:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33500 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgFQHfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 03:35:09 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200617073506epoutp02c6b54f130d3118325b005d34f1bb1058~ZRIrIKEbr2617826178epoutp02S
        for <stable@vger.kernel.org>; Wed, 17 Jun 2020 07:35:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200617073506epoutp02c6b54f130d3118325b005d34f1bb1058~ZRIrIKEbr2617826178epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592379306;
        bh=HEobwd96ZYMrqYboJ3eyoTj3cwltQNyjyGdgFD8m7Xo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=WYc0lpAlnJYwyil6uXNOs7BdWOaFlUj6FMxGarMnayKAGQvFo2zW+4L36aaEa/xrO
         EkKA9QOpEe7QIgL5+mlEWrJhqHWaO6uRLYvt2qRR6a6E7N4BD0v2KCkiIVsiluGkar
         aBXfr7+gh5eMK+GnyUY/dyv6YlH9dNcLla7na6Ds=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200617073505epcas1p29f1c05df6b14f21834afda7b3f537534~ZRIqyhYvZ0074200742epcas1p2Q;
        Wed, 17 Jun 2020 07:35:05 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.161]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49mxfw5d6MzMqYlp; Wed, 17 Jun
        2020 07:35:04 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FB.9C.28581.7A7C9EE5; Wed, 17 Jun 2020 16:35:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200617073503epcas1p3db5d4c13b5add4952fbd93be79644782~ZRIoYxzDc2844528445epcas1p3p;
        Wed, 17 Jun 2020 07:35:03 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200617073503epsmtrp1f089876fc96e447a536367b7cc005e69~ZRIoXsdTM2104421044epsmtrp16;
        Wed, 17 Jun 2020 07:35:03 +0000 (GMT)
X-AuditID: b6c32a38-2e3ff70000006fa5-01-5ee9c7a75b4a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DC.BC.08303.7A7C9EE5; Wed, 17 Jun 2020 16:35:03 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200617073502epsmtip2e3d469690d8a4018be20cb14ed5c69a8~ZRIoM9oRg1402814028epsmtip2R;
        Wed, 17 Jun 2020 07:35:02 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     kohada.t2@gmail.com, sj1557.seo@samsung.com,
        stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] exfat: move setting VOL_DIRTY over exfat_remove_entries()
Date:   Wed, 17 Jun 2020 16:30:05 +0900
Message-Id: <20200617073005.2888-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsWy7bCmvu7y4y/jDPr2q1j8mHubxWLP3pMs
        Fj+m11ts+XeE1WLBxkeMDqweO2fdZffo27KK0ePzJrkA5qgcm4zUxJTUIoXUvOT8lMy8dFsl
        7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygjUoKZYk5pUChgMTiYiV9O5ui/NKSVIWM
        /OISW6XUgpScAkODAr3ixNzi0rx0veT8XCtDAwMjU6DKhJyM3Sf2sxT0cVac/LOAsYHxGnsX
        IyeHhICJxKf2ZrYuRi4OIYEdjBJ9W1+wQDifGCV+72hmgnA+M0rsnHYWrqXl/lqoll2MEg/+
        bWSCa+m4uIy5i5GDg01AW+LPFlEQU0RAUeLyeyeQXmaBAonTc7exgdjCAl4S71c/YwaxWQRU
        JY6cuws2n1fAWuLTgjlsELvkJVZvOMAMMl5CoJtd4sulM1BHuEi09ZxggbCFJV4d3wIVl5J4
        2d/GDrJXQqBa4uN+ZohwB6PEi++2ELaxxM31G1hBSpgFNCXW79KHCCtK7Pw9lxHiTD6Jd197
        WCGm8Ep0tAlBlKhK9F06zARhS0t0tX+AWuohcWjSDrCLhQRiJU5Pf8Y2gVF2FsKCBYyMqxjF
        UguKc9NTiw0LTJCjaBMjOA1pWexgnPv2g94hRiYOxkOMEhzMSiK8zr9fxAnxpiRWVqUW5ccX
        leakFh9iNAUG10RmKdHkfGAizCuJNzQ1MjY2tjAxMzczNVYS5z1pdSFOSCA9sSQ1OzW1ILUI
        po+Jg1OqgSnW1fObdtbX2tNrnD+tu1YVk3DHYUb5fU7/t/Er7NSErBNTtv1WUZRliVcSn921
        2ud32DpPHQ39i2HTD/XF/X879TTn80+vc6XaLH/ctDiT21D4IEvtje2ZDb6T5kvu6DnP++Os
        ROLqZVeet/1L4rI4rce0h3MzfwYz796SqYqSmrov5TPOSfj4XL28e6b5EY1jB9b2+gXOrKx0
        lkm9VdKww7w64jZHRljI6emdST3/TrwVMJfijX1+jWtfrFpS4Bk5DXujhKPLvpaaXe7fZMdk
        wG3QKi6WFRuSMf3z4pS/dSu0l0Y8qAwXStokLKi24ETk8eXuNdnT61usl01k7Zu7L8xl3are
        V7p7r67TVGIpzkg01GIuKk4EABDpsuXMAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsWy7bCSvO7y4y/jDDauYbX4Mfc2i8WevSdZ
        LH5Mr7fY8u8Iq8WCjY8YHVg9ds66y+7Rt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGbtP7Gcp
        6OOsOPlnAWMD4zX2LkZODgkBE4mW+2vZuhi5OIQEdjBKrD35hRkiIS1x7MQZIJsDyBaWOHy4
        GKLmA6PE9LYfjCBxNgFtiT9bREFMEQFFicvvnUA6mQVKJCad/cQEYgsLeEm8X/0MbCKLgKrE
        kXN3wdbyClhLfFowhw1ik7zE6g0HmCcw8ixgZFjFKJlaUJybnltsWGCUl1quV5yYW1yal66X
        nJ+7iREcFlpaOxj3rPqgd4iRiYPxEKMEB7OSCK/z7xdxQrwpiZVVqUX58UWlOanFhxilOViU
        xHm/zloYJySQnliSmp2aWpBaBJNl4uCUamBK4j3z71vdFduj/qW1nl1OxpGmJy8KfJw559cx
        44dSwu5Gppuyj254O5VDpITzUe0djtt7Z+vnh0rrnT21c7/3wgKx0g+evk7/JKvVpSOviJ12
        st6o9q1zS/CelbbdZoc6lSs8d+/sfD/j3aStyXFJ96xVX1n+jmjeYC16YN2cIBmj06b2yTyP
        rqnJzPKvbT2sE/CTP0Evjn8Zd+FapudfSlNj2S8IzXKv3dCrVa9g/Vwnckrl6oef26SEz3ns
        2+GR/Tpj/stvubI9O2ckTy080GMf+n1X9kWBfgXGB4W3U8M/PZvJ/rYkSEKgpSGrj32J9LZZ
        7qH75FzPOpwTqe26XVZ+6ObpbRIJu8R9u5RYijMSDbWYi4oTATdgVnF6AgAA
X-CMS-MailID: 20200617073503epcas1p3db5d4c13b5add4952fbd93be79644782
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200617073503epcas1p3db5d4c13b5add4952fbd93be79644782
References: <CGME20200617073503epcas1p3db5d4c13b5add4952fbd93be79644782@epcas1p3.samsung.com>
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
index edd8023865a0..2b9e21094a96 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -975,7 +975,6 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 		goto unlock;
 	}
 
-	exfat_set_vol_flags(sb, VOL_DIRTY);
 	exfat_chain_set(&clu_to_free, ei->start_clu,
 		EXFAT_B_TO_CLU_ROUND_UP(i_size_read(inode), sbi), ei->flags);
 
@@ -1002,6 +1001,7 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
 	num_entries++;
 	brelse(bh);
 
+	exfat_set_vol_flags(sb, VOL_DIRTY);
 	err = exfat_remove_entries(dir, &cdir, entry, 0, num_entries);
 	if (err) {
 		exfat_err(sb, "failed to exfat_remove_entries : err(%d)", err);
-- 
2.17.1

