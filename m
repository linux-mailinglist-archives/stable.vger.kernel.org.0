Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB8322BAED
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 02:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgGXAVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 20:21:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48937 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgGXAVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 20:21:25 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200724002122epoutp035b73cdf1740d05776edb8d61428afcdb~kiFi_v3uH0904009040epoutp03y
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 00:21:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200724002122epoutp035b73cdf1740d05776edb8d61428afcdb~kiFi_v3uH0904009040epoutp03y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595550082;
        bh=+1Ri5Cw0jOe5s1C+FvaBuT+551AvtbucY/rkHkfVnSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah9Y0svpfKdxnK2YAFMQL27fFzx+5kUJp+Hhh1JTM5G5qqqVYYvF855ghb3e1OFp9
         4uviU5OH4/V10ccUy08+9T9uHqxtvubAg9dET+X8uoe9Mqh4zhNuzMxUkIdzclK+R8
         gFt+461Y9yka2aFwHIly/hh5WxH3389TWmI3m5BE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200724002122epcas1p3cce438611d7231d8310d3cdd904e5fb2~kiFiqKiI90664006640epcas1p3P;
        Fri, 24 Jul 2020 00:21:22 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.164]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BCVHP3R1JzMqYlh; Fri, 24 Jul
        2020 00:21:21 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.86.19033.1892A1F5; Fri, 24 Jul 2020 09:21:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200724002121epcas1p31a4629c7cf9d3b342d18d8f5faf371e2~kiFhfljMs2749927499epcas1p3N;
        Fri, 24 Jul 2020 00:21:21 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724002121epsmtrp28bb2f89c5af342c03540e86f95f852df~kiFhetqcT3166431664epsmtrp2L;
        Fri, 24 Jul 2020 00:21:21 +0000 (GMT)
X-AuditID: b6c32a36-16fff70000004a59-72-5f1a29815a50
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.30.08303.0892A1F5; Fri, 24 Jul 2020 09:21:21 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002120epsmtip2235b7564198b02123a7a34cd027e4983~kiFhSXa610534305343epsmtip2Y;
        Fri, 24 Jul 2020 00:21:20 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 1/4] exfat: fix overflow issue in
 exfat_cluster_to_sector()
Date:   Fri, 24 Jul 2020 09:15:41 +0900
Message-Id: <20200724001544.30862-2-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724001544.30862-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsWy7bCmrm6jplS8QcsLKYvmxevZLH5Mr7fY
        tOYam8WCjY8YHVg8Nq3qZPPYP3cNu0ffllWMHp83yQWwROXYZKQmpqQWKaTmJeenZOal2yp5
        B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nb2RTll5akKmTk
        F5fYKqUWpOQUGBoU6BUn5haX5qXrJefnWhkaGBiZAlUm5GRsubeEtWAXR8X+y20sDYyz2bsY
        OTgkBEwkJk3R6GLk5BAS2MEocaYjuouRC8j+xCjxcf4RZgjnM6PEqc43jCBVIA2rd++ASuxi
        lFjbvosVrmXrlvesIGPZBLQl/mwRBWkQETCUuPH5GgtImFnAUWLHPT6QsLBAsMSr6SALODlY
        BFQlXrRsZwKxeQVsJCbv+csCsUteYvWGA2A1nAK2Esv/HmUBWSUhsIpd4tPsJywQH7hITH4h
        BVEvLPHq+BZ2CFtK4vO7vWwQJdUSH/czQ4Q7GCVefLeFsI0lbq7fwApxmabE+l36EGFFiZ2/
        54J9yyzAJ/Huaw8rxBReiY42IYgSVYm+S4eZIGxpia72D9DQ9JCY8wEaghMYJdpuXGCcwCg3
        C2HBAkbGVYxiqQXFuempxYYFRshxtYkRnJi0zHYwTnr7Qe8QIxMH4yFGCQ5mJRFeHUbxeCHe
        lMTKqtSi/Pii0pzU4kOMpsCQm8gsJZqcD0yNeSXxhqZGxsbGFiZm5mamxkrivP/OsscLCaQn
        lqRmp6YWpBbB9DFxcEo1MK1MM5vKvX2rRpSr4xE1Pd/6T+rvxP/f64pMlDx1LFK/5tz+dY9n
        CmpsYrZ1KOD4feOe/Ivbk6YYvF/KmVNxcsWikvrKq5JGsjM9n+8xNTxwRLjupYfLLYfQm8GZ
        i9O3FM6Y+V3Sv4PPKkBA4+mbBF3Olewm0m/ztjC/7FEw3nY0Uq4oqjs+zzN3r/tS7dPT2Fj/
        hwvlL+fTEzjlMm3Zh227UqVfH1j38vf0DobnKVvrg8/5p9x7FMF5btKXmCfP407fuP+/+9gy
        yyuVfxa4Bzw61ip9TEhOiqE4SbKA8cCP0/OucZ4J/dV1XNwjTZa9usez/H99aDD3istpp9SZ
        HZa+td/Z9mGnyru+osJ5UkosxRmJhlrMRcWJACdnYvrVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsWy7bCSvG6jplS8wdStTBbNi9ezWfyYXm+x
        ac01NosFGx8xOrB4bFrVyeaxf+4ado++LasYPT5vkgtgieKySUnNySxLLdK3S+DK2HJvCWvB
        Lo6K/ZfbWBoYZ7N3MXJySAiYSKzevYMZxBYS2MEoMWepNERcWuLYiTNAcQ4gW1ji8OHiLkYu
        oJIPjBLtU1aygcTZBLQl/mwRBTFFBIwl2r+WgZjMAs4S71eIgQwRFgiU2LbuLthwFgFViRct
        25lAbF4BG4nJe/6yQCySl1i94QBYDaeArcTyv0dZII6xkZj5fSfjBEa+BYwMqxglUwuKc9Nz
        iw0LjPJSy/WKE3OLS/PS9ZLzczcxgkNIS2sH455VH/QOMTJxMB5ilOBgVhLh1WEUjxfiTUms
        rEotyo8vKs1JLT7EKM3BoiTO+3XWwjghgfTEktTs1NSC1CKYLBMHp1QDk/NRCZH38Urftmqf
        O2O2Xf/f/rvyR3J/qanYbJu8WUHy3a2TnTsv+P1+fevwrwP6NTLlSzc5MeR8UWqbaBz57dQn
        2wfVbm/ktN6KThH65xm6aL9GEsvJs/+eWbyf6HR//fxjlruiDF43rTE+/Ot9mcLuUskXCbp6
        i1rPnH59grtdt3ei5s4+X//lGnUOChZSCisecX1S8tnbYeLZNvu/nsXDX08rGPf0zj40fYVV
        iHjj4ybdY5nbeldsf5Sf+VZXv+TCInPOiomRPm45Eew+23hnKRje+qK900RN7v5h3WPeJ/xM
        lls+v85TwHn/kvJlL9sz/25u67u8q5Ip9I7GlunL/zmWeu5Jf+xjkGPy940SS3FGoqEWc1Fx
        IgCsNk/RkAIAAA==
X-CMS-MailID: 20200724002121epcas1p31a4629c7cf9d3b342d18d8f5faf371e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724002121epcas1p31a4629c7cf9d3b342d18d8f5faf371e2
References: <20200724001544.30862-1-namjae.jeon@samsung.com>
        <CGME20200724002121epcas1p31a4629c7cf9d3b342d18d8f5faf371e2@epcas1p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 43946b70494beefe40ec1b2ba4744c0f294d7736 ]

An overflow issue can occur while calculating sector in
exfat_cluster_to_sector(). It needs to cast clus's type to sector_t
before left shifting.

Fixes: 1acf1a564b60 ("exfat: add in-memory and on-disk structures and headers")
Cc: stable@vger.kernel.org # v5.7
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/exfat_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index d865050fa6cd..99e9baf2d31d 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -375,7 +375,7 @@ static inline bool exfat_is_last_sector_in_cluster(struct exfat_sb_info *sbi,
 static inline sector_t exfat_cluster_to_sector(struct exfat_sb_info *sbi,
 		unsigned int clus)
 {
-	return ((clus - EXFAT_RESERVED_CLUSTERS) << sbi->sect_per_clus_bits) +
+	return ((sector_t)(clus - EXFAT_RESERVED_CLUSTERS) << sbi->sect_per_clus_bits) +
 		sbi->data_start_sector;
 }
 
-- 
2.17.1

