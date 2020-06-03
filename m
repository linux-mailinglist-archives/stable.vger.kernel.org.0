Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3241ED961
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgFCXdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 19:33:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54972 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgFCXdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 19:33:07 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200603233300epoutp01b8fb9afd1c85c4fc6b55467fea6fee5d~VLLC_X6qT0365503655epoutp01X
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 23:33:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200603233300epoutp01b8fb9afd1c85c4fc6b55467fea6fee5d~VLLC_X6qT0365503655epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591227181;
        bh=dGDVCvjLxDpBE/A7r7Do5LBsJtM5zh/1GdFe9TJZj28=;
        h=From:To:Cc:Subject:Date:References:From;
        b=qGzEB7INXH/P/NttKRAo/DGU7OFP07NsPyTtnHAXOA0WLV6pQMNs4vDGZ3brm/q8Q
         YUWA0a0oW2SKzT9GPnAJxiTS4I6R/GqzAykanPwYyDwxAWclLvxqHlfSJwzhNJGMnF
         1TcAKaCeTBxUgltHsJpF5qYwMEW8YsBlxvbjILPs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200603233300epcas1p1a2674e256a3bedc1fffdbb6b7b9e0181~VLLCj1id12965129651epcas1p1_;
        Wed,  3 Jun 2020 23:33:00 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49clZg3Ks4zMqYkV; Wed,  3 Jun
        2020 23:32:59 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        09.53.28581.B2338DE5; Thu,  4 Jun 2020 08:32:59 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200603233258epcas1p3b17bdc6c4f8df1089693eebaf1124d0a~VLLA0YkM_1446414464epcas1p3D;
        Wed,  3 Jun 2020 23:32:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200603233258epsmtrp1dbd5d4e18c4e439b4b94af78dde8a481~VLLAzvAMk0951309513epsmtrp1d;
        Wed,  3 Jun 2020 23:32:58 +0000 (GMT)
X-AuditID: b6c32a38-2e3ff70000006fa5-bc-5ed8332bac40
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.64.08382.A2338DE5; Thu,  4 Jun 2020 08:32:58 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200603233258epsmtip2d835859cbd8f885418c2488a23af86b0~VLLAkKJMs2159721597epsmtip2K;
        Wed,  3 Jun 2020 23:32:58 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sj1557.seo@samsung.com,
        Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] exfat: fix incorrect update of stream entry in
 __exfat_truncate()
Date:   Thu,  4 Jun 2020 08:28:08 +0900
Message-Id: <20200603232808.2397-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsWy7bCmga628Y04g8kzRSz27D3JYnF51xw2
        ix/T6y22/DvCarFg4yNGB1aPvi2rGD0+b5ILYIrKsclITUxJLVJIzUvOT8nMS7dV8g6Od443
        NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqakUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVK
        LUjJKTA0KNArTswtLs1L10vOz7UyNDAwMgWqTMjJOHymm6XgFmfF9tVP2BoYf7F3MXJySAiY
        SBz7f4uxi5GLQ0hgB6PEhPWPwBJCAp8YJU5tSIVIfGOUmHj7HwtMx6PPr6E69jJKvFo0gwnC
        AeqYu3weUIaDg01AW+LPFlEQU0RAUeLyeyeQXmaBSonD1/ezgtjCAiESH55NZwSxWQRUJZZv
        ewi2mFfAWuLW2yY2iF3yEqs3HGAGGS8h0M4usbJpIdQRLhJTp7czQdjCEq+Ob4F6R0riZX8b
        O8heCYFqiY/7mSHCHYwSL77bQtjGEjfXb2AFKWEW0JRYv0sfIqwosfP3XEaIM/kk3n3tYYWY
        wivR0SYEUaIq0XfpMNRSaYmu9g9QSz0kLn99Bw22WIljV+ezTWCUnYWwYAEj4ypGsdSC4tz0
        1GLDAhPkGNrECE49WhY7GOe+/aB3iJGJg/EQowQHs5IIr5XstTgh3pTEyqrUovz4otKc1OJD
        jKbA4JrILCWanA9Mfnkl8YamRsbGxhYmZuZmpsZK4rwnrS7ECQmkJ5akZqemFqQWwfQxcXBK
        NTAlPnIuVT1wTIVBqfztab2zAVeLZsxjUm1pKtYw/NLEvoB7olkEf6KkwGrL2VpyDALJahX/
        byqEil1U7de4+Tw/Z2bj/wuZ8Q5mh0s9Ahg3rLD+8v9co2nzlDQOQcbkKYF8Rf88Lc7vY9Dz
        Cdi57nxcr2TAu3l33G7UsH5rffzBtHvbUw3ldYxX+sNnW7m+Tw831Uy8nH/sQvVHH8lVHZuP
        6F5S/87wanETy+ngFm5T7vK2xo64hWIhb5dXVXUuP5epGrm2uJrfeu/sbw6bWnWKIx1uPF9W
        H2v8/dIqluqaBUzRKu53Dl3wl5i22/PNvk/hqYZ7p19lkQw8uHOdb+HGmDkuZ/XuVYUt9j33
        X4mlOCPRUIu5qDgRAD5DZRrGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsWy7bCSvK6W8Y04g5tv5Cz27D3JYnF51xw2
        ix/T6y22/DvCarFg4yNGB1aPvi2rGD0+b5ILYIrisklJzcksSy3St0vgyjh8ppul4BZnxfbV
        T9gaGH+xdzFyckgImEg8+vyasYuRi0NIYDejRF/XPCaIhLTEsRNnmLsYOYBsYYnDh4shaj4w
        SmzsucUKEmcT0Jb4s0UUxBQRUJS4/N4JxGQWqJVYclAOZIiwQJBE+6pvYJtYBFQllm97CGbz
        ClhL3HrbxAaxSF5i9YYDzBMYeRYwMqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgO
        BS3NHYzbV33QO8TIxMF4iFGCg1lJhNdK9lqcEG9KYmVValF+fFFpTmrxIUZpDhYlcd4bhQvj
        hATSE0tSs1NTC1KLYLJMHJxSDUwz5Ngvn/I1OGQgLvjAQovvWsSs2zNt932aftNjFQNTL4+0
        V8zedfsTVl1z+VlZ48yWtMGw9f+uNpuoOzea0v4ejzDR/VXLr5r36ISAU5BN0Jkl86rKl4XH
        ll5cZff5QpLcvZONeVNrHu6+a+unNO0Re9k+b5eFv5rnNitYTf6lu6lIzSrv+NU0Udn+/VnM
        NwKn9Pb07otV/3ngRlJCZg5zmwv/zMhFAeyi31befztzzhrxvOq1ZiFpzzZl3GSU63xjJ3hv
        nZLYhvVrAzL/lgj1tIgd21jPpPTjhtnvws6PPWycs7RXHL+wUyrdSWLKcZsfT185v+rfs2C3
        rXvpVckzH61b3YUFdF2Ul7tdl1JiKc5INNRiLipOBACk8RijdAIAAA==
X-CMS-MailID: 20200603233258epcas1p3b17bdc6c4f8df1089693eebaf1124d0a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200603233258epcas1p3b17bdc6c4f8df1089693eebaf1124d0a
References: <CGME20200603233258epcas1p3b17bdc6c4f8df1089693eebaf1124d0a@epcas1p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

At truncate, there is a problem of incorrect updating in the file entry
pointer instead of stream entry. This will cause the problem of
overwriting the time field of the file entry to new_size. Fix it to
update stream entry.

Fixes: 98d917047e8b ("exfat: add file operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 8e3f0eef45d7..fce03f318787 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -171,11 +171,11 @@ int __exfat_truncate(struct inode *inode, loff_t new_size)
 
 		/* File size should be zero if there is no cluster allocated */
 		if (ei->start_clu == EXFAT_EOF_CLUSTER) {
-			ep->dentry.stream.valid_size = 0;
-			ep->dentry.stream.size = 0;
+			ep2->dentry.stream.valid_size = 0;
+			ep2->dentry.stream.size = 0;
 		} else {
-			ep->dentry.stream.valid_size = cpu_to_le64(new_size);
-			ep->dentry.stream.size = ep->dentry.stream.valid_size;
+			ep2->dentry.stream.valid_size = cpu_to_le64(new_size);
+			ep2->dentry.stream.size = ep->dentry.stream.valid_size;
 		}
 
 		if (new_size == 0) {
-- 
2.17.1

