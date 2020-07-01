Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24301211699
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGAXZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:25:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31471 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgGAXZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 19:25:42 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200701232538epoutp0213b8c3677cf49421aa85eecc5c08aad1~dxIm39-vh0992509925epoutp02J
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:25:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200701232538epoutp0213b8c3677cf49421aa85eecc5c08aad1~dxIm39-vh0992509925epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593645938;
        bh=AwryGmeBPsvF8p1weflyNQEdqWqgGlewjxNS+5te05w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBu7CFOIyhIbBA338wo2tJTnj2FEkqJyNC83Eo5uOmWVoUrLRO7VinEp/06S0j7iR
         OTY+HWvNI2BtSKAbKRRaw7glqnh/XXZgxAQQ1kWYxuiWQ7DOmZgmt/ooFJFCPxpiHd
         jqhacl+BIlf7bJPOK8Hh4rqn9Oc+eoz/cThM8n6o=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200701232538epcas1p390437cc959439a9d3b7aafae4d3ab143~dxImRO5_D0140501405epcas1p3D;
        Wed,  1 Jul 2020 23:25:38 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49xy5F1lzXzMqYkW; Wed,  1 Jul
        2020 23:25:37 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.5B.18978.17B1DFE5; Thu,  2 Jul 2020 08:25:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200701232536epcas1p1e0f92c7cc47e06ce490088c2e3cc1a21~dxIktvS4f1844818448epcas1p1N;
        Wed,  1 Jul 2020 23:25:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200701232536epsmtrp28bf9711707d4b279be92689ee8d0982f~dxIksjSla1851918519epsmtrp25;
        Wed,  1 Jul 2020 23:25:36 +0000 (GMT)
X-AuditID: b6c32a35-603ff70000004a22-fb-5efd1b71a238
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        48.0C.08382.07B1DFE5; Thu,  2 Jul 2020 08:25:36 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200701232536epsmtip23b0e8afbcb7385b02fc04f60b14d6811~dxIkg68Ib2699026990epsmtip2g;
        Wed,  1 Jul 2020 23:25:36 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Hyeongseok.Kim" <Hyeongseok@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 1/5] exfat: Set the unused characters of FileName
 field to the value 0000h
Date:   Thu,  2 Jul 2020 08:20:20 +0900
Message-Id: <20200701232024.2083-2-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701232024.2083-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsWy7bCmrm6h9N84g95HPBbNi9ezWfyd+InJ
        4vKuOWwWP6bXW2xac43NYsHGR4wObB47Z91l99i0qpPNY//cNewefVtWMXp83iQXwBqVY5OR
        mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
        KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8DQoECvODG3uDQvXS85P9fK0MDAyBSoMiEn4+G8
        dSwFvZwVd55cYW1gPMDexcjJISFgItHYcoaxi5GLQ0hgB6PExOOLoZxPjBL/r15gh3C+MUo8
        2/2bCaZl5sJ9zBCJvYwSi1+cYoFrmd7yA6ifg4NNQFvizxZRkAYRAUOJG5+vgdUwC3QxSuy6
        3c0KkhAWSJK49Gc1G4jNIqAqcbGlgxHE5hWwljjVepYZYpu8xOoNB8BsTgEbiXXn/oPdJyGw
        j13iWsM0dpBlEgIuEvMmpUHUC0u8Or4F6jkpic/v9rJBlFRLfNwPNbKDUeLFd1sI21ji5voN
        rCAlzAKaEut36UOEFSV2/p4Ldg2zAJ/Eu689rBBTeCU62oQgSlQl+i4dhgaJtERX+weopR4S
        O9/eZYWESD+jxL/Hc1gnMMrNQtiwgJFxFaNYakFxbnpqsWGBIXKEbWIEJzAt0x2ME99+0DvE
        yMTBeIhRgoNZSYT3tMGvOCHelMTKqtSi/Pii0pzU4kOMpsCgm8gsJZqcD0yheSXxhqZGxsbG
        FiZm5mamxkrivOIyF+KEBNITS1KzU1MLUotg+pg4OKUamNRWhrzbMF2a+77dtQssIXcUEk6n
        zb968vqCdA9/mXg5FbWPtaaGB+Y8j+hOYdffs1thlmXRScVqp727nr2cs5NFy/r7nfyalr9T
        LDU+PguxcXr2O2DH3SfTUlMMmV5r7lR8sHRK1O+mlTwvbm/e+fIii0V6zltPrZ9T3af/zkj7
        EvBHJuTbqbPKljNXLwl0u/5j90zzmuqPtn/6Tur0cEzYnC0gE//vDt/S6X4nuOdtlE2NyGT5
        6O7aocf3sqzO5WOP17qshT3zfwhv9U64cP3O792RoqmWZ/vKjx/jzin9odxk3qs992Hjik4O
        w4I5x95UaGx42Jksv/1QYfHpI1fCHfRuOPlEfWUyStFY5aXEUpyRaKjFXFScCADMD7uZ6QMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42LZdlhJXrdA+m+cwbOVChbNi9ezWfyd+InJ
        4vKuOWwWP6bXW2xac43NYsHGR4wObB47Z91l99i0qpPNY//cNewefVtWMXp83iQXwBrFZZOS
        mpNZllqkb5fAlfFw3jqWgl7OijtPrrA2MB5g72Lk5JAQMJGYuXAfcxcjF4eQwG5Gia0317NA
        JKQljp04A5TgALKFJQ4fLoao+cAo0XNlDytInE1AW+LPFlEQU0TAWKL9axlIJ7NAH6PEzGV1
        ILawQILE78M/mUFsFgFViYstHYwgNq+AtcSp1rPMEJvkJVZvOABmcwrYSKw79x+sRgioZuOV
        lywTGPkWMDKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDjItzR2M21d90DvEyMTB
        eIhRgoNZSYT3tMGvOCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8NwoXxgkJpCeWpGanphakFsFk
        mTg4pRqYahITczcuk9RYckgmOXPzVRYmc5OuQ14Ju/U+bGjrkrJOi0h7PVH3wsakjjeb01q7
        ulTOyk2fahDTys0jnNnmpZve+iHx0zM3gyJVsXdljK2TxNTmrt50aMsZdu5/B5J507dOFs5n
        TlpxVefLH4t+yZ+u5z51KAtNTp787YjiVN1pXQqrElp18tcYPpBaz3BhaWeL4w8VBxV7eeul
        LKqZElWdR4t4it1f9+lK+CieqE/ZrHbr3HeZg7+z/l/dEMUjtPdW/kNPzTy+dX8ufI530P68
        wvuZlfWcyYqzGkQ5I/US9Sf7Z2/Sb8hwXX7UVLjUaaNXz8WF+7gOLVbeu3Oemfpbm9Yd94MU
        pv/036XEUpyRaKjFXFScCADXuoeIoQIAAA==
X-CMS-MailID: 20200701232536epcas1p1e0f92c7cc47e06ce490088c2e3cc1a21
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200701232536epcas1p1e0f92c7cc47e06ce490088c2e3cc1a21
References: <20200701232024.2083-1-namjae.jeon@samsung.com>
        <CGME20200701232536epcas1p1e0f92c7cc47e06ce490088c2e3cc1a21@epcas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Hyeongseok.Kim" <Hyeongseok@gmail.com>

Some fsck tool complain that padding part of the FileName field
is not set to the value 0000h. So let's maintain filesystem cleaner,
as exfat's spec. recommendation.

Fixes: ca06197382bd ("exfat: add directory operations")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Hyeongseok.Kim <Hyeongseok@gmail.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/dir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index 4b91afb0f051..349ca0c282c2 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -430,10 +430,12 @@ static void exfat_init_name_entry(struct exfat_dentry *ep,
 	ep->dentry.name.flags = 0x0;
 
 	for (i = 0; i < EXFAT_FILE_NAME_LEN; i++) {
-		ep->dentry.name.unicode_0_14[i] = cpu_to_le16(*uniname);
-		if (*uniname == 0x0)
-			break;
-		uniname++;
+		if (*uniname != 0x0) {
+			ep->dentry.name.unicode_0_14[i] = cpu_to_le16(*uniname);
+			uniname++;
+		} else {
+			ep->dentry.name.unicode_0_14[i] = 0x0;
+		}
 	}
 }
 
-- 
2.17.1

