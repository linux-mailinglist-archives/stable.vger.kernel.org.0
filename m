Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9380213479
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 08:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGCGr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 02:47:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60477 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgGCGrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 02:47:55 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200703064752epoutp04e917d56b6e2d95819972cb6f8c4a5ff3~eKz--aZjm0408304083epoutp04i
        for <stable@vger.kernel.org>; Fri,  3 Jul 2020 06:47:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200703064752epoutp04e917d56b6e2d95819972cb6f8c4a5ff3~eKz--aZjm0408304083epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593758872;
        bh=jm6O3Uv0Bzvx8p6MvcNZv+0tmou8t7Cj9gm076+ZDlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tpqa4wqkOpHpWrI27eEyvgqz09kg6qnt7bXOG//UlvPR7964aVEUEp04D1fTR69jI
         DLtlaNjw5ZsenhyLRszb5YTJAB2cecTDXdgHRGEBScgGsDjpxJLZFex8K8irsKgAcJ
         htDvtfHHr3cYEEV8DMf+0zRbW5zW8gWLQ3F5akzI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200703064751epcas1p25156dff15c705ee1730e470942fcf7c5~eKz-uD53T0329603296epcas1p2O;
        Fri,  3 Jul 2020 06:47:51 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.162]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49yls253MBzMqYlv; Fri,  3 Jul
        2020 06:47:50 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.A4.29173.694DEFE5; Fri,  3 Jul 2020 15:47:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200703064750epcas1p487820ba4670511e02410c3a9ffbf8f89~eKz_XMrFR0108901089epcas1p4Y;
        Fri,  3 Jul 2020 06:47:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200703064750epsmtrp2d260d2dbf4c713f29047ff45db020cf8~eKz_WbgAs0903609036epsmtrp2r;
        Fri,  3 Jul 2020 06:47:50 +0000 (GMT)
X-AuditID: b6c32a37-9cdff700000071f5-05-5efed49625b1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.45.08303.694DEFE5; Fri,  3 Jul 2020 15:47:50 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703064749epsmtip1cfcf448823c20aaa7a035cec4b15f9e5~eKz_HiGAw0033300333epsmtip1F;
        Fri,  3 Jul 2020 06:47:49 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     sj1557.seo@samsung.com, kohada.t2@gmail.com,
        Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] exfat: fix wrong hint_stat initialization in
 exfat_find_dir_entry()
Date:   Fri,  3 Jul 2020 15:42:37 +0900
Message-Id: <20200703064237.12963-2-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200703064237.12963-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsWy7bCmge60K//iDJadULX4Mfc2i8WevSdZ
        LH5Mr7fY8u8Iq8WCjY8YHVg9ds66y+7Rt2UVo8fnTXIBzFE5NhmpiSmpRQqpecn5KZl56bZK
        3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAG5UUyhJzSoFCAYnFxUr6djZF+aUlqQoZ
        +cUltkqpBSk5BYYGBXrFibnFpXnpesn5uVaGBgZGpkCVCTkZC36cYiroZa941/eItYHxPWsX
        IweHhICJxM8umy5GLg4hgR2MErM2HGaGcD4xSqx9OxXI4QRyPjNK9L5OA7FBGia8+MACUbSL
        UeLBy36EjvZX/WBj2QS0Jf5sEQUxRQQUJS6/dwLpZRYokOg4/pYFxBYWiJI49mkZO0gJi4Cq
        xLHfvCBhXgEbicbTT5ghVslLrN5wAMzmFLCVeHP0HdgmCYFV7BKH951jgyhykVh2q58FwhaW
        eHV8CzuELSXx+d1eNognqyU+7oea2cEo8eK7LYRtLHFz/Qawg5kFNCXW79KHCCtK7Pw9lxHi
        Yj6Jd197oEHFK9HRJgRRoirRd+kwE4QtLdHV/gFqqYfEzc03WSHhMQEYOEsnMk9glJuFsGEB
        I+MqRrHUguLc9NRiwwJj5MjaxAhOTVrmOxinvf2gd4iRiYPxEKMEB7OSCG+C6r84Id6UxMqq
        1KL8+KLSnNTiQ4ymwKCbyCwlmpwPTI55JfGGpkbGxsYWJmbmZqbGSuK8vlYX4oQE0hNLUrNT
        UwtSi2D6mDg4pRqYqo4vn8jjJqhx7vqL1yckllqXZhkzbcmaffWJx0q9i4sM0quvb3w7J9W4
        O3jNt25l5Tsr4jadbvUJTa194n7UoFCL2aHpkljdrau3XypPX7Fc98zRZ2lbLnTu9BHsypT7
        LPrxzKrYxadmCWSb8jx87dt7fu3au9Mdw4xXNTNanZ4QKd70PqhsCuvyNw+2X7ujluq4XGVZ
        9ONf0g/uzUzTPHBq4iYWj2vvSsNyq2e8atjzdE5B7AyLOQxfOxn7/5qcWn/1r3/T+eb2qkPZ
        qRlyTNr72da8nbXM/OjUw7sSk8/z5DLMVmWqTrgS8Fzx+cNtM2YEN/jwujrry+7LKXFMPK6j
        vqR3rXGddrm3eOmDE0osxRmJhlrMRcWJAPY2kQfWAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsWy7bCSnO60K//iDDb2clj8mHubxWLP3pMs
        Fj+m11ts+XeE1WLBxkeMDqweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujAU/TjEV
        9LJXvOt7xNrA+J61i5GTQ0LARGLCiw8sXYxcHEICOxglvi55C5WQljh24gxzFyMHkC0scfhw
        MUTNB0aJK/3PGUHibALaEn+2iIKYIgKKEpffO4F0MguUSMw794IRxBYWiJA4fe4RK0gJi4Cq
        xLHfvCBhXgEbicbTT5ghFslLrN5wAMzmFLCVeHP0HdhSIaCaBceEJjDyLWBkWMUomVpQnJue
        W2xYYJSXWq5XnJhbXJqXrpecn7uJERxCWlo7GPes+qB3iJGJg/EQowQHs5IIb4Lqvzgh3pTE
        yqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MMU1PwzU1zSau5JB
        ernHPxZf2eW+3xLMTT9/PShwZQ/TytbYY/PyTnTPWFr85c6Fgpjtz43m72b/4DZBpuHAJGsp
        132K9R80n35+eL3w5BYZ7fs3nC7/rrx8r6/HUsCq10sprTJDNO7FiZdBq9I5Apm3G6ruvRC2
        jtvZUO3EQ/O8I0xRWyKWLtPsndDgYKto9XYKf1rPf8UZ672eFFQvWTHp5D+xHbIHlORbtvbU
        crJq+mS+vup9Rmjz9qZXb34W9PvnuvtZtNis/7x0acjlOVNvnHp38RZX1T3b1JX+L/95fmJf
        dyd/zn+ZGU3Gbw6rrSzedeVdTu+fvMNabcclf24R4tyz4celXxdyLp1SbLinxFKckWioxVxU
        nAgA8n6U0pACAAA=
X-CMS-MailID: 20200703064750epcas1p487820ba4670511e02410c3a9ffbf8f89
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703064750epcas1p487820ba4670511e02410c3a9ffbf8f89
References: <20200703064237.12963-1-namjae.jeon@samsung.com>
        <CGME20200703064750epcas1p487820ba4670511e02410c3a9ffbf8f89@epcas1p4.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f4cea9a7fd02..573659bfbc55 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -1116,7 +1116,7 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 			ret = exfat_get_next_cluster(sb, &clu.dir);
 		}
 
-		if (ret || clu.dir != EXFAT_EOF_CLUSTER) {
+		if (ret || clu.dir == EXFAT_EOF_CLUSTER) {
 			/* just initialized hint_stat */
 			hint_stat->clu = p_dir->dir;
 			hint_stat->eidx = 0;
-- 
2.17.1

