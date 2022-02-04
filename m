Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C994A92CE
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 04:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245044AbiBDDm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 22:42:28 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50814 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232345AbiBDDmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 22:42:23 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2141hSM6012591;
        Fri, 4 Feb 2022 03:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=HmE0xb3hH+aUxstiJvmsRUlkplpk3vjpuANukSi698U=;
 b=SienoCq14327GkafJdN0uIN3IvsCWSlGyOG+2ayvxSOGk/dzDDO/NeEol1Obj02QoxL6
 Ao8yyvMNz+uGdr3QS9pMihsSyhDzvA2Wl2LWnaAJQr0iIaDN9tTloMMIh4dxLWrRt9zU
 kqiL5FVRq3ZQBTfa7//nji+nLGrx55AhqrGLmrU75gHA2rHdTOe6meCY38ksiMt574qi
 AKjdrT9dunspS+PTBZScwlKBR9wWLT+lsgcOPdsbmkf/RCO5jFukcyxZhzkGVcQc6TWS
 GvuA0PGaAIMcPMhLbXkswUv0CzUuUClrx+FDQwPeWHtYPLNMqTwDAwVcYWDm3TREJzgw pA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hevsjxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 03:42:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2143fVM8172178;
        Fri, 4 Feb 2022 03:42:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3dvtq6mfkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Feb 2022 03:42:12 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2143gBA0173900;
        Fri, 4 Feb 2022 03:42:11 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by userp3030.oracle.com with ESMTP id 3dvtq6mfjq-1;
        Fri, 04 Feb 2022 03:42:11 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>, stable@vger.kernel.org,
        Dmitry Ivanov <dmitry.ivanov2@hpe.com>,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>
Subject: [PATCH] block: bio-integrity: Advance seed correctly for larger interval sizes
Date:   Thu,  3 Feb 2022 22:42:09 -0500
Message-Id: <20220204034209.4193-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: TKgKzsopAs0l1_zIylS2G8x9VO6VNAze
X-Proofpoint-ORIG-GUID: TKgKzsopAs0l1_zIylS2G8x9VO6VNAze
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 309a62fa3a9e ("bio-integrity: bio_integrity_advance must update
integrity seed") added code to update the integrity seed value when
advancing a bio. However, it failed to take into account that the
integrity interval might be larger than the 512-byte block layer
sector size. This broke bio splitting on PI devices with 4KB logical
blocks.

The seed value should be advanced by bio_integrity_intervals() and not
the number of sectors.

Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: stable@vger.kernel.org
Fixes: 309a62fa3a9e ("bio-integrity: bio_integrity_advance must update integrity seed")
Tested-by: Dmitry Ivanov <dmitry.ivanov2@hpe.com>
Reported-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/bio-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index d25114715459..0827b19820c5 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -373,7 +373,7 @@ void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
-	bip->bip_iter.bi_sector += bytes_done >> 9;
+	bip->bip_iter.bi_sector += bio_integrity_intervals(bi, bytes_done >> 9);
 	bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
 }
 
-- 
2.32.0

