Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9357213477
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 08:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgGCGrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 02:47:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11151 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgGCGry (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 02:47:54 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200703064752epoutp01fabce331cad181e6662233af7920a600~eK0ANuNNR2109621096epoutp01U
        for <stable@vger.kernel.org>; Fri,  3 Jul 2020 06:47:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200703064752epoutp01fabce331cad181e6662233af7920a600~eK0ANuNNR2109621096epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593758872;
        bh=l+vPx0QETbwwMm5Uc0hmIJO3kNYKOZFj7CLABNrviDk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=jKijWvVlQ4ZnksPNZHOR8BYpg2LXeX97IZRCqxomb1pNLFchbzWgoldodXALMyGA9
         VsXkc/bitYfHZpeoycttAZ+NKxie0dY0qXXRVzJyKg3PC2FfIFWHjIGibwi5RQu06s
         yfzRLXdeBLGHb2tJO8pH2yNCTf3zM7JLQ2GwtEas=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200703064751epcas1p1122c3904fcee1fc9fd83a47c5b4c011a~eKz-6JU553214832148epcas1p1s;
        Fri,  3 Jul 2020 06:47:51 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.161]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49yls268ptzMqYm8; Fri,  3 Jul
        2020 06:47:50 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.37.18978.594DEFE5; Fri,  3 Jul 2020 15:47:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200703064749epcas1p142abf1759a90450434ff7d7fbc7dd116~eKz9nYzam0665306653epcas1p1E;
        Fri,  3 Jul 2020 06:47:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200703064749epsmtrp1399bec082d12053d066592cd962a95bf~eKz9htWvx0874908749epsmtrp1t;
        Fri,  3 Jul 2020 06:47:49 +0000 (GMT)
X-AuditID: b6c32a35-603ff70000004a22-99-5efed49522ee
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A0.61.08382.594DEFE5; Fri,  3 Jul 2020 15:47:49 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200703064749epsmtip15dd5f81583e4e46e196aa1bc004dfa86~eKz9Vt65z0033000330epsmtip1H;
        Fri,  3 Jul 2020 06:47:49 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     sj1557.seo@samsung.com, kohada.t2@gmail.com,
        Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] exfat: fix overflow issue in exfat_cluster_to_sector()
Date:   Fri,  3 Jul 2020 15:42:36 +0900
Message-Id: <20200703064237.12963-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsWy7bCmru7UK//iDK6s0LH4Mfc2i8WevSdZ
        LH5Mr7fY8u8Iq8WCjY8YHVg9ds66y+7Rt2UVo8fnTXIBzFE5NhmpiSmpRQqpecn5KZl56bZK
        3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAG5UUyhJzSoFCAYnFxUr6djZF+aUlqQoZ
        +cUltkqpBSk5BYYGBXrFibnFpXnpesn5uVaGBgZGpkCVCTkZi3s+MRb8Yq/YMt+tgfExWxcj
        J4eEgInE5S2rGUFsIYEdjBJHHpdB2J8YJZqvRXYxcgHZ3xglVtxfzwjTcKd3NStEYi+jxObu
        KewQDlDHjEvrmbsYOTjYBLQl/mwRBTFFBBQlLr93AullFiiQ6Dj+lgXEFhbwljj/cD4TiM0i
        oCrx68x5MJtXwEbi6Y1mdohd8hKrNxxgBhkvIdDNLrG/dT9UwkXi06NOKFtY4tXxLVC2lMTL
        /jZ2kL0SAtUSH/czQ4Q7GCVefLeFsI0lbq7fwApSwiygKbF+lz5EWFFi5++5jBBn8km8+9rD
        CjGFV6KjTQiiRFWi79JhJghbWqKr/QPUUg+JyzemQ4MwVuLfzOUsExhlZyEsWMDIuIpRLLWg
        ODc9tdiwwBA5fjYxghOQlukOxolvP+gdYmTiYDzEKMHBrCTCm6D6L06INyWxsiq1KD++qDQn
        tfgQoykwuCYyS4km5wNTYF5JvKGpkbGxsYWJmbmZqbGSOK+4zIU4IYH0xJLU7NTUgtQimD4m
        Dk6pBibfZZpLppxY5lh9KtRoxqPlMZYzNvXOZ5zXfdPvXraxZoaCq5Sd/Q6PnQyfdOfbKsR9
        a9BpWHEt+wF/52mzZzefvtNTnhDsnSSfvv+l775MT9ZP/r+fyfJtTdg5t3TK6g4v9ivpnfV1
        WioVr262BtbUMf4/W9q0UUXUuGFrAmuvdaCa6ZquyROTeg7HHLkjvqllFr/BQn+ds3KXkpVO
        iyp37/x0yj1x6m7RUl0jFRdFhmJbq00vkm7EzNBh0rXetKtR0nbty66EosOswSdbfNPlchWt
        LdMvyR2dfe/3caFV3Gzaf8puqSzIbto1VbF7UfcmrfaLZjZTX4SwtJSeaLS1l17a8sqlw+AS
        4+qJSizFGYmGWsxFxYkAkZrhyskDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsWy7bCSnO7UK//iDK5uErT4Mfc2i8WevSdZ
        LH5Mr7fY8u8Iq8WCjY8YHVg9ds66y+7Rt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGYt7PjEW
        /GKv2DLfrYHxMVsXIyeHhICJxJ3e1axdjFwcQgK7GSX+HuxjhUhISxw7cYa5i5EDyBaWOHy4
        GKLmA6PE1Jdz2EDibALaEn+2iIKYIgKKEpffO4F0MguUSMw794IRxBYW8JY4/3A+E4jNIqAq
        8evMeTCbV8BG4umNZnaITfISqzccYJ7AyLOAkWEVo2RqQXFuem6xYYFhXmq5XnFibnFpXrpe
        cn7uJkZwUGhp7mDcvuqD3iFGJg7GQ4wSHMxKIrwJqv/ihHhTEiurUovy44tKc1KLDzFKc7Ao
        ifPeKFwYJySQnliSmp2aWpBaBJNl4uCUamCa8zttsYpy9TnnvwHH57NdkF1Up7c+s0JpUw1j
        7iHhPQXv8oqqPnx7NL9x6dMCkfDN4YJTz7Fu1TdJ+Xx9K0upsHr/T5EW+2RpZcXibOPWNkOe
        L4tYaj5suT23McDyRH7ga6NXfy+97i+POr8jcmnMof3VkyyK1ulZX2etCd2U6VbxTiIrNJ2h
        PzBlWfx/N8b7sxPMnsQKJah2/Zk+67iP/JNJB7X32TDahs4wMZPuayvb9TTzf8f3SwZH2/Vq
        H2+Q+fNapPTQSlWh7Y/Wfrzos3TFN4WnV3Q/KTI1MopIVjyU0zueyRl1w3T9DgtvZkmZmJWy
        zO6iqgwrufZbeZnwC4pcL1taeuu+5Zd125RYijMSDbWYi4oTAcpu2BJ5AgAA
X-CMS-MailID: 20200703064749epcas1p142abf1759a90450434ff7d7fbc7dd116
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703064749epcas1p142abf1759a90450434ff7d7fbc7dd116
References: <CGME20200703064749epcas1p142abf1759a90450434ff7d7fbc7dd116@epcas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 3aed8e22087a..cb51d6e83199 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -368,7 +368,7 @@ static inline bool exfat_is_last_sector_in_cluster(struct exfat_sb_info *sbi,
 static inline sector_t exfat_cluster_to_sector(struct exfat_sb_info *sbi,
 		unsigned int clus)
 {
-	return ((clus - EXFAT_RESERVED_CLUSTERS) << sbi->sect_per_clus_bits) +
+	return ((sector_t)(clus - EXFAT_RESERVED_CLUSTERS) << sbi->sect_per_clus_bits) +
 		sbi->data_start_sector;
 }
 
-- 
2.17.1

