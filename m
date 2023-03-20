Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA8D6C0AFA
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 08:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjCTHAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 03:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCTHAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 03:00:18 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350C711EB3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 00:00:16 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230320070013epoutp013f293f4a96f6d817bddac0d7c1eabf41~ODnaQIvRg0855108551epoutp01M
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 07:00:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230320070013epoutp013f293f4a96f6d817bddac0d7c1eabf41~ODnaQIvRg0855108551epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1679295613;
        bh=F2fna41vElCudBkEUtJkWpw4XuFauSPQHFQ+SyMQF44=;
        h=From:To:Cc:Subject:Date:References:From;
        b=XINSr5k4FTyx0NRf0m1vBAebzcezo0R7lE3WhuRpbntda3/RZ8nIZrIDFwA3gMMJQ
         ak+1MbMvGyi/RMWkQ0IIhWbTnhzv6tz6E3yRCugtXyBlhXiT8Oq5XQ4EQ59L0J1o8u
         UbfhGdu8egHxwX8heFUGY3K+lOYR52eeCRbjiMbU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20230320070012epcas1p36c5e1f20bd123cec8429b50e82a6f4e0~ODnZwRs1g1653816538epcas1p37;
        Mon, 20 Mar 2023 07:00:12 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.38.243]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Pg5GN3m2qz4x9QY; Mon, 20 Mar
        2023 07:00:12 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.29.37890.B7408146; Mon, 20 Mar 2023 16:00:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132~ODnYa5gYz3100631006epcas1p1S;
        Mon, 20 Mar 2023 07:00:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230320070011epsmtrp2f33d745215f7c0110b43a63ec5690021~ODnYZt3m11173411734epsmtrp2n;
        Mon, 20 Mar 2023 07:00:11 +0000 (GMT)
X-AuditID: b6c32a38-bbd3aa8000029402-6a-6418047b3fc6
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DA.9D.31821.B7408146; Mon, 20 Mar 2023 16:00:11 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.41]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230320070011epsmtip1f578457078a6d396ae62894c2ca4fb55~ODnYPeYYN1527015270epsmtip1f;
        Mon, 20 Mar 2023 07:00:11 +0000 (GMT)
From:   Yeongjin Gil <youngjin.gil@samsung.com>
To:     agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        ebiggers@kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Yeongjin Gil <youngjin.gil@samsung.com>,
        stable@vger.kernel.org, Sungjong Seo <sj1557.seo@samsung.com>
Subject: [PATCH v2] dm verity: fix error handling for check_at_most_once on
 FEC
Date:   Mon, 20 Mar 2023 15:59:32 +0900
Message-Id: <20230320065932.28116-1-youngjin.gil@samsung.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmrm41i0SKwdoVBhbrTx1jttj7bjar
        xdo9f5gtLu+aw2ax5d8RVosTt6QtFmx8xGgxY/9TdgcOj02rOtk83u+7yubRt2UVo8fnTXIB
        LFENjDaJRckZmWWpCql5yfkpmXnptkqhIW66FkoKGfnFJbZK0YaGRnqGBuZ6RkZGeqZGsVZG
        pkoKeYm5qbZKFbpQvUoKRckFQLW5lcVAA3JS9aDiesWpeSkOWfmlIKfrFSfmFpfmpesl5+cq
        KZQl5pQCjVDST/jGmLHg0CXWgi88FR/3L2BuYLzP1cXIwSEhYCKx6ZxDFyMXh5DADkaJmdcn
        skE4nxglZt3uYIFwPjNKbJo3l6mLkROs40LrF0aIxC5GielLtrPCtZw+voQZpIpNQFdi6sun
        rCC2iECQxJPmXWBzmQW6GCWae56CFQkLBErc2DeTBcRmEVCVeNE8gRHkKF4BW4lHPfUQ2+Ql
        GjvOsYPYvAKCEidnPgErZwaKN2+dzQwyU0LgHLvE/4lbGCEaXCTuXdrADGELS7w6voUdwpaS
        +PxuLxtEQzujxIqHcxghnBmMEn/f32eFqLKXaG5tZgO5gllAU2L9Ln2IsKLEzt9zoRYISpy+
        1s0McQWfxLuvPayQkOSV6GgTgihRk7gy6RfURBmJvgezoG7wkGh6cw+sVUggVuJ31wyWCYwK
        s5D8NgvJb7MQjljAyLyKUSy1oDg3PbXYsMAEOZY3MYJTq5bFDsa5bz/oHWJk4mA8xCjBwawk
        wuvGLJEixJuSWFmVWpQfX1Sak1p8iDEZGNgTmaVEk/OByT2vJN7QzMzSwtLIxNDYzNCQsLCJ
        pYGJmZGJhbGlsZmSOK+47clkIYH0xJLU7NTUgtQimC1MHJxSDUy8N3R2iwnLfbaOPfPglLdM
        wdSnWqurzt5T37zjwobJ21//7fJTdLd+0XO+U2VFKUPnoub/7rMn9TyYPKVbX+y03K8jd9/9
        faT5o/zxPeGS/Quq910RkNPYK1LD4DTF1ipT5l70MrZj2k39OemKLUsffH48VeNBxaeabStE
        V+7qWfhpw+SeH/0m1x9bXD9x5F3sWgZmT7WpvVl9cffFp3tqTJ/3/swMi2IzeU7ePavcfqxU
        3G537vJmh67NScrbou0dlWKW79zQ9y++QHitX79f+jTWqpcPpK80OXsZeNy2vLh9rt9Uzx9z
        POLr9hkuX7G/j3VvyqutryKlmLY5rRAWv/YjfDLvRAbOctc3d1S0lViKMxINtZiLihMBWYP2
        gGQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsWy7bCSnG41i0SKwZwZEhbrTx1jttj7bjar
        xdo9f5gtLu+aw2ax5d8RVosTt6QtFmx8xGgxY/9TdgcOj02rOtk83u+7yubRt2UVo8fnTXIB
        LFFcNimpOZllqUX6dglcGQsOXWIt+MJT8XH/AuYGxvtcXYycHBICJhIXWr8wdjFycQgJ7GCU
        +Pf2DTNEQkbiz8T3bF2MHEC2sMThw8UQNR8YJbZdv84KUsMmoCsx9eVTMFtEIEzix7Q7TCBF
        zAJ9jBJ7L71lB0kIC/hL3Lj1C2woi4CqxIvmCYwgQ3kFbCUe9dRD7JKXaOw4B1bOKyAocXLm
        ExYQmxko3rx1NvMERr5ZSFKzkKQWMDKtYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQI
        DlEtrR2Me1Z90DvEyMTBeIhRgoNZSYTXjVkiRYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T
        8UIC6YklqdmpqQWpRTBZJg5OqQYmQZYzNuw/zb5EvMi/ob48IjD6xrnkoIAVfOG5L6K3nlhd
        fPcXn5T5yx1XD1TWul9KTLB5793Q8WMLs/hZtjfpPCzbAncwPVrmfrIuQ9h9a73lLBd3yaiv
        IZIVl/XV+QIkLp/U1PhR8f0xH5O3QyDHYtntXtp/ORlLvVNXVm77qJcUoRXvNuNc1+muk8Ua
        Jv+bst0Ka3qe1htcXTbpi6FywuX5f0sjv7eFCkWc1p815ZnFTTUHhk0HZLNqODdJ7dBkdf+l
        4i026WJ0T0r5s66iefFqt15nRQTdjNeqZ2h9ltFV9SR+j8S2Oc2hOZ35tTkfHrr4FDWt7d/x
        wuNnqp3/Z80DJu8WGM2SmB/Zo8RSnJFoqMVcVJwIALLTqgLAAgAA
X-CMS-MailID: 20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-ArchiveUser: EV
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132
References: <CGME20230320070011epcas1p12f0fe9f9f417dd1a3441efdde55a4132@epcas1p1.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In verity_end_io(), if bi_status is not BLK_STS_OK, it can be return
directly. But if FEC configured, it is desired to correct the data page
through verity_verify_io. And the return value will be converted to
blk_status and passed to verity_finish_io().

BTW, when a bit is set in v->validated_blocks, verity_verify_io() skips
verification regardless of I/O error for the corresponding bio. In this
case, the I/O error could not be returned properly, and as a result,
there is a problem that abnormal data could be read for the
corresponding block.

To fix this problem, when an I/O error occurs, do not skip verification
even if the bit related is set in v->validated_blocks.

Fixes: 843f38d382b1 ("dm verity: add 'check_at_most_once' option to only validate hashes once")
Cc: stable@vger.kernel.org
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
---
v2:
-change commit message and tag
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index ade83ef3b439..9316399b920e 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -523,7 +523,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 		sector_t cur_block = io->block + b;
 		struct ahash_request *req = verity_io_hash_req(v, io);
 
-		if (v->validated_blocks &&
+		if (v->validated_blocks && bio->bi_status == BLK_STS_OK &&
 		    likely(test_bit(cur_block, v->validated_blocks))) {
 			verity_bv_skip_block(v, io, iter);
 			continue;
-- 
2.40.0

