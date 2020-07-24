Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370E922BAEF
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 02:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgGXAV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 20:21:28 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54343 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgGXAV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 20:21:28 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200724002125epoutp0465f1768320ae67d627ea67eefb6582af~kiFlbqX-21269512695epoutp04c
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 00:21:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200724002125epoutp0465f1768320ae67d627ea67eefb6582af~kiFlbqX-21269512695epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595550085;
        bh=YKOPdXXoigLfzegu747bw8dpV4cCGOz2G9+E9gkb368=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=la2S3U9/FnEJ6iOh5ybvmB5twCralVgCwsU4H2Cd6hNsg/8M0vWwoorMo+6X3Rzpp
         rfJpMwwaVutW8jWlTR/Syveyi3NqHrt5V+YLRKVMuMFu/Z/6Bi7kcqDvzPEvbZ3pMh
         h/HniOKMbXF86oix/DTjg6tJ/5PK93wHJN10jKBU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200724002125epcas1p29b16c66cd38f94286c6b3dd86f1d279f~kiFlI973N2758927589epcas1p2L;
        Fri, 24 Jul 2020 00:21:25 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.161]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BCVHR71MRzMqYkZ; Fri, 24 Jul
        2020 00:21:23 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.86.19033.3892A1F5; Fri, 24 Jul 2020 09:21:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200724002123epcas1p1ba65569ce62beb1ba94efb38907a798b~kiFjf1_Y30286002860epcas1p1T;
        Fri, 24 Jul 2020 00:21:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724002123epsmtrp26e24d3fc5d714503e2f32ed6de88618c~kiFjfOVgJ3166431664epsmtrp2N;
        Fri, 24 Jul 2020 00:21:23 +0000 (GMT)
X-AuditID: b6c32a36-159ff70000004a59-7f-5f1a29831419
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.30.08303.3892A1F5; Fri, 24 Jul 2020 09:21:23 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002123epsmtip28e8cf1a52bbbaac31a746db1793929db~kiFjTlu5v0534305343epsmtip2Z;
        Fri, 24 Jul 2020 00:21:23 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, Hyeongseok Kim <hyeongseok@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 3/4] exfat: fix wrong size update of stream entry by
 typo
Date:   Fri, 24 Jul 2020 09:15:43 +0900
Message-Id: <20200724001544.30862-4-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724001544.30862-1-namjae.jeon@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmgW6zplS8wdb92hbNi9ezWfyd+InJ
        4sf0eotNa66xWSzY+IjRgdVj56y77B6bVnWyeeyfu4bdo2/LKkaPz5vkAlijcmwyUhNTUosU
        UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
        9O1sivJLS1IVMvKLS2yVUgtScgoMDQr0ihNzi0vz0vWS83OtDA0MjEyBKhNyMrZt+8Re8Ju9
        4siXO2wNjBfZuhg5OCQETCTe3mXsYuTiEBLYwShxaNIJNgjnE6PEseV/mSCcz4wS84/uAXI4
        wTr67t9khUjsYpTo737BCNfypP8AE8hcNgFtiT9bREEaRAQMJW58vsYCYjMLZEk8nTwJbLWw
        QKDEiSnsIGEWAVWJK/0XWEFsXgEbiVvrnkDtkpdYveEAM4jNKWArsfzvURaQVRIC29gl9lz/
        zAxR5CKxY94OdghbWOLV8S1QtpTE53d7od6slvi4H6q8g1HixXdbCNtY4ub6DawgJcwCmhLr
        d+lDhBUldv6eywhxMZ/Eu689rBBTeCU62oQgSlQl+i4dhrpSWqKr/QPUUg+J9XePQUNnAqPE
        nH+fWScwys1C2LCAkXEVo1hqQXFuemqxYYERcnRtYgSnLC2zHYyT3n7QO8TIxMF4iFGCg1lJ
        hFeHUTxeiDclsbIqtSg/vqg0J7X4EKMpMOwmMkuJJucDk2ZeSbyhqZGxsbGFiZm5mamxkjjv
        v7Ps8UIC6YklqdmpqQWpRTB9TBycUg1MGtFGlnrd5YtnaMpxxKj9tPn5vSDgmt6jQ9eClijs
        frXv6QK2pQZvjO/JhoeI/bW973S7VLEj9Z+2ybQ9884kiXCGvhFWV3y4fVFJE0Pw/lPxTGE7
        lBRUntp91/nw7dDJGz+XFDQLeN1y96mdlCwpIj77hcDuT2WOXo+SXzVLFBb8lBK7v7Jy4d8n
        wTIxE2+tvnjZac2Eb39TZkavS9tydf3qU5u6d9Y3FDAGf7T2Lcv4r2t3sF+MecfHyge+O43C
        H68vtJrLb6bap8i2RJ+5JvpumYBzYeAP5hnLNhxrcd4ofFykP132auQ21gtCl75+/PRIdhO3
        2JcOtUSl6sT5N2umKPolih75vkhmyUUmJZbijERDLeai4kQALwoC1eIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42LZdlhJXrdZUyreYMpdXovmxevZLP5O/MRk
        8WN6vcWmNdfYLBZsfMTowOqxc9Zddo9NqzrZPPbPXcPu0bdlFaPH501yAaxRXDYpqTmZZalF
        +nYJXBnbtn1iL/jNXnHkyx22BsaLbF2MnBwSAiYSffdvsoLYQgI7GCX2bcyEiEtLHDtxhrmL
        kQPIFpY4fLi4i5ELqOQDo8Sqo29YQeJsAtoSf7aIgpgiAsYS7V/LQDqZBXIkzn66A9YpLOAv
        sWhWBEiYRUBV4kr/BbBFvAI2ErfWPWGCWCQvsXrDAWYQm1PAVmL536MsEMfYSMz8vpNxAiPf
        AkaGVYySqQXFuem5xYYFRnmp5XrFibnFpXnpesn5uZsYwWGlpbWDcc+qD3qHGJk4GA8xSnAw
        K4nw6jCKxwvxpiRWVqUW5ccXleakFh9ilOZgURLn/TprYZyQQHpiSWp2ampBahFMlomDU6qB
        KalR7NvThiyFq1MfNInyXvCc5j7N8IeF14HAz7skjy55vn9+uGSdrrv1+34NzaWi8z/LKc7j
        Y5kmxB8jIfBmlbzhxN7vQQX9N/Qbo19+TJQ1WXNi1v0k6U0qjw1eVxY6Prs2dXOs7cStG1Kv
        3eN49CVNQILdoHrV/LLVCpcrlwgXno3UfXHXgeHnvkel9hMrbZxPKs9/0MzpGbTwtsq0TYea
        Xwp1brrumLb+Z+Cfa71RKvs23djRtbdPab7sY8MXXOcMl84osdmQcEOl8uL/mpDT9Q7zk3fU
        lTXEWrz+kbfJWYy962Zg0l22BV0GK6Y8Tp9V/3LD8Q9et3+snqmQ8e6PnIaP7PNKXcmaOTtq
        lJVYijMSDbWYi4oTATF6V4CaAgAA
X-CMS-MailID: 20200724002123epcas1p1ba65569ce62beb1ba94efb38907a798b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724002123epcas1p1ba65569ce62beb1ba94efb38907a798b
References: <20200724001544.30862-1-namjae.jeon@samsung.com>
        <CGME20200724002123epcas1p1ba65569ce62beb1ba94efb38907a798b@epcas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyeongseok Kim <hyeongseok@gmail.com>

[ Upstream commit 41e3928f8c58184fcf0bb22e822af39a436370c7 ]

The stream.size field is updated to the value of create timestamp
of the file entry. Fix this to use correct stream entry pointer.

Fixes: 29bbb14bfc80 ("exfat: fix incorrect update of stream entry in __exfat_truncate()")
Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/exfat/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index b93aa9e6cb16..04278f3c0adf 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -175,7 +175,7 @@ int __exfat_truncate(struct inode *inode, loff_t new_size)
 			ep2->dentry.stream.size = 0;
 		} else {
 			ep2->dentry.stream.valid_size = cpu_to_le64(new_size);
-			ep2->dentry.stream.size = ep->dentry.stream.valid_size;
+			ep2->dentry.stream.size = ep2->dentry.stream.valid_size;
 		}
 
 		if (new_size == 0) {
-- 
2.17.1

