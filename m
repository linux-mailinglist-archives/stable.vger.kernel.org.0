Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F4821AFE5
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 09:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgGJHMM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 03:12:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37128 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgGJHMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 03:12:12 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200710071209epoutp041ed18a712b653437eeaf6372b9434bde~gUqNv5L611141311413epoutp04b
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 07:12:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200710071209epoutp041ed18a712b653437eeaf6372b9434bde~gUqNv5L611141311413epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594365130;
        bh=/t3GOhd3EujC86HBkGwp/MyxxttlluRp2O1d8XhoX4c=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ENSl+aJFuNV8/llOHJ5qCd1b+k3diEsXP6SFhSSF3falqHLTKwjAUNzhQoiPu4LNy
         swGvjmwgDEQEX4DWTJllnXuq98Ed7YOMhaZ8zlE0E8Zxa3Wacg6k6udF3mb3JF487O
         EKoCixLKFtFq9rlnEXcuWgS85qqojrUIiBA0NrCU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200710071209epcas1p1e22cd134d7e1aeceabf5718bdd7a8cf7~gUqNXMqae2509625096epcas1p1j;
        Fri, 10 Jul 2020 07:12:09 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.166]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B343r3yt0zMqYkn; Fri, 10 Jul
        2020 07:12:08 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.DD.28578.8C4180F5; Fri, 10 Jul 2020 16:12:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200710071207epcas1p2bbcd1f5c96f6aba7e3f67cbedbe85a19~gUqL2xCbX0143001430epcas1p2j;
        Fri, 10 Jul 2020 07:12:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200710071207epsmtrp202b7032d125c2b43ce843a551954940e~gUqL2GsaO0421104211epsmtrp2L;
        Fri, 10 Jul 2020 07:12:07 +0000 (GMT)
X-AuditID: b6c32a39-8dfff70000006fa2-aa-5f0814c858b2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.77.08382.7C4180F5; Fri, 10 Jul 2020 16:12:07 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200710071207epsmtip211d9a43c1d5acdd09b877149f77f1af4~gUqLnd1lQ1117611176epsmtip2u;
        Fri, 10 Jul 2020 07:12:07 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Ilya Ponetayev <i.ponetaev@ndmsystems.com>, stable@vger.kernel.org,
        Chen Minqiang <ptpt52@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] exfat: fix name_hash computation on big endian systems
Date:   Fri, 10 Jul 2020 16:06:30 +0900
Message-Id: <20200710070630.32684-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmvu4JEY54g20/pS1W//rEbrFn70kW
        ix/T6y32f//MaLFg4yNGB1aPnbPusnus7pzK6NG3ZRWjx+dNcgEsUTk2GamJKalFCql5yfkp
        mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFhgYFesWJucWleel6yfm5VoYGBkamQJUJORnTjm9nLWjkqni/9R5j
        A+Myji5GTg4JAROJQ+dbmboYuTiEBHYwSnyf3gflfGKU2PDjGiOE841Rovl3CxNMy58Hc6ES
        exkl7k++xwrXMvlKL3sXIwcHm4C2xJ8toiCmiICixOX3TiAlzAITGSXezbjDCDJIWMBd4vaB
        hSwgNouAqsTKVW1gcV4BG4n/n+axQCyTl1i94QAzhD2dXeJ9QxaE7SJx/vYJqLiwxKvjW9gh
        bCmJz+/2soHslRColvi4H6qkg1HixXdbCNtY4ub6DawgJcwCmhLrd+lDhBUldv6eC3YBswCf
        xLuvPawQU3glOtqEIEpUJfouHYaGgrREV/sHqKUeEgcbl4LFhQRiJQ6cP8s+gVF2FsKCBYyM
        qxjFUguKc9NTiw0LTJGjaBMjOCFpWe5gnP72g94hRiYOxkOMEhzMSiK8Boqs8UK8KYmVValF
        +fFFpTmpxYcYTYGhNZFZSjQ5H5gS80riDU2NjI2NLUzMzM1MjZXEef+dZY8XEkhPLEnNTk0t
        SC2C6WPi4JRqYNqdWrK0IbiO+5eNdUcd997rLw7NO6/E/C45TYBTZa12v3bt8Tt+j/Ollip+
        ++p57V5Q2zVtLp/30gFsVelmF8/oqz//c7122q6/2hNLbS5tEG17vykkSkl+sx1f4sxLn3Q2
        6B5aWXV31i79yLpdfRq+FQ3isWb/vh7UmnZ0sbZx10nWRturV7eFNbz5mLK3VsdoRsOh2RyP
        ldK3blylIh4QdP1exiczVb3ulCXsywWvSftYiVnFrTipqPJ9js/+RyEb5xZJrs3sfLStrLpc
        yL1gR6mfnvGPbk65qK8z3zTbHzt6vMZsi9HyskXLb2yd7d6jyOjZ+PpK29ozs/8xaG468LvF
        2+GiTEWSxxP3BCWW4oxEQy3mouJEAKPHfurRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLJMWRmVeSWpSXmKPExsWy7bCSvO5xEY54g8tTjC1W//rEbrFn70kW
        ix/T6y32f//MaLFg4yNGB1aPnbPusnus7pzK6NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
        045vZy1o5Kp4v/UeYwPjMo4uRk4OCQETiT8P5jJ2MXJxCAnsZpR4vPAuE0RCWuLYiTPMXYwc
        QLawxOHDxRA1HxglJuzdxgoSZxPQlvizRRTEFBFQlLj83gmkhFlgKqPE/P41YGOEBdwlbh9Y
        yAJiswioSqxc1cYIYvMK2Ej8/zSPBWKVvMTqDQeYJzDyLGBkWMUomVpQnJueW2xYYJiXWq5X
        nJhbXJqXrpecn7uJERwiWpo7GLev+qB3iJGJg/EQowQHs5IIr4Eia7wQb0piZVVqUX58UWlO
        avEhRmkOFiVx3huFC+OEBNITS1KzU1MLUotgskwcnFINTNNOF4gEG0lZ2ipcteC4MW/Wv8ly
        c3rubbs3OaRHmjWmJrjh1mHz24eOV3uUnFPT2iOeUGRha9E3R/3Dkpkaf9Ynef9uXhu8cnFx
        mpiU0rvLi/fExC15ajBjhXZPd9rMUNu2GSG/+B47ZkfWJqtq923YI26oPHMHm9DfgiiZuOi1
        rkErJJc1Wd0WZd53k8fuvErWytsaDuZ9Ep9btmRXbPmr0jyPU1rL4ffRU2UmAVqV6mLTbjqZ
        zFhibrX2+M5np1MfV8832azinnPlZ2zh5HeLvF/WKL3RF3OtSb/5pUXnRc4SzvOcEdeX65s0
        d5S8/jgx/e43lt+eLtUJh3u5usKSgmdvVpM9HvfXZp2jEktxRqKhFnNRcSIAqhZzTYACAAA=
X-CMS-MailID: 20200710071207epcas1p2bbcd1f5c96f6aba7e3f67cbedbe85a19
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200710071207epcas1p2bbcd1f5c96f6aba7e3f67cbedbe85a19
References: <CGME20200710071207epcas1p2bbcd1f5c96f6aba7e3f67cbedbe85a19@epcas1p2.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>

On-disk format for name_hash field is LE, so it must be explicitly transformed
on BE system for proper result.

Fixes: 370e812b3ec1 ("exfat: add nls operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Chen Minqiang <ptpt52@gmail.com>
Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/nls.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 57b5a7a4d1f7..c286a5c2e323 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -519,7 +519,7 @@ static int exfat_utf8_to_utf16(struct super_block *sb,
 		    exfat_wstrchr(bad_uni_chars, *uniname))
 			lossy |= NLS_NAME_LOSSY;
 
-		upname[i] = exfat_toupper(sb, *uniname);
+		upname[i] = cpu_to_le16(exfat_toupper(sb, *uniname));
 		uniname++;
 	}
 
@@ -611,7 +611,7 @@ static int exfat_nls_to_ucs2(struct super_block *sb,
 		    exfat_wstrchr(bad_uni_chars, *uniname))
 			lossy |= NLS_NAME_LOSSY;
 
-		upname[unilen] = exfat_toupper(sb, *uniname);
+		upname[unilen] = cpu_to_le16(exfat_toupper(sb, *uniname));
 		uniname++;
 		unilen++;
 	}
-- 
2.17.1

