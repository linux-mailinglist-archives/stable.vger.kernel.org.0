Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6D6C0AEE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 07:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCTGyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 02:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCTGyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 02:54:38 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE0E12063
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 23:54:33 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230320065421epoutp0373d0155c16dd5a91755c7aac5afbe535~ODiSMFGTh2016120161epoutp03-
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:54:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230320065421epoutp0373d0155c16dd5a91755c7aac5afbe535~ODiSMFGTh2016120161epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1679295261;
        bh=F2fna41vElCudBkEUtJkWpw4XuFauSPQHFQ+SyMQF44=;
        h=From:To:Cc:Subject:Date:References:From;
        b=NS4Pu9ZJDV8MaDJCtaGooTdRrex4MPo+wxAE7k3bmCm5wL5n0GWeUzExMBUhohUSs
         PYMiSR5IeNQKb4Dq6rT9XZco5yy88z9kJqJtXXQ4c2fRkIAd4YTECQ5Jf/iRAmGBXn
         RQ41ahB0g4JuvUCbXwWidAlGx2GUjxTE3DSbY/DA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20230320065420epcas1p35a0904e0fcc8db6b4b83884e87234dde~ODiR4i2FZ2054320543epcas1p3r;
        Mon, 20 Mar 2023 06:54:20 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.38.240]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Pg57c3444z4x9QF; Mon, 20 Mar
        2023 06:54:20 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.E4.54823.81308146; Mon, 20 Mar 2023 15:54:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20230320065416epcas1p2511cb60bfb14ed2048e5d39677490c78~ODiN5LN4v1268912689epcas1p2K;
        Mon, 20 Mar 2023 06:54:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230320065416epsmtrp2779526ba33939601772762ac5a22cc35~ODiN4giSV0786307863epsmtrp2T;
        Mon, 20 Mar 2023 06:54:16 +0000 (GMT)
X-AuditID: b6c32a39-d01fc7000000d627-1f-6418031828c3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E7.D3.18071.81308146; Mon, 20 Mar 2023 15:54:16 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.41]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230320065416epsmtip29a1a8ee94368b0b3e42c0651cb8e6f62~ODiNtfU1X0675106751epsmtip2s;
        Mon, 20 Mar 2023 06:54:16 +0000 (GMT)
From:   Yeongjin Gil <youngjin.gil@samsung.com>
To:     sj1557.seo@samsung.com, youngjin.gil@samsung.com
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] dm verity: fix error handling for check_at_most_once on
 FEC
Date:   Mon, 20 Mar 2023 15:54:16 +0900
Message-Id: <20230320065416.27998-1-youngjin.gil@samsung.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLJsWRmVeSWpSXmKPExsWy7bCmvq4Es0SKwYGHRhZb/h1htViw8RGj
        xYz9T9kdmD36tqxi9Pi8SS6AKaqB0SaxKDkjsyxVITUvOT8lMy/dVik0xE3XQkkhI7+4xFYp
        2tDQSM/QwFzPyMhIz9Qo1srIVEkhLzE31VapQheqV0mhKLkAqDa3shhoQE6qHlRcrzg1L8Uh
        K78U5DC94sTc4tK8dL3k/FwlhbLEnFKgEUr6Cd8YMxYcusRa8IWn4uP+BcwNjPe5uhg5OSQE
        TCSOnH3E1sXIxSEksINR4sHKThaQhJDAJ0aJvctzIBLfGCUO3D3PDNNxe3IPE0RiL6PEwpM/
        oNqBOl7fmssOUsUmoCsx9eVTVhBbBKhj3keQHZwczAJSEus+HQKzhQUCJW7smwm2jkVAVeLi
        qRlAUzk4eAVsJVqmC0Ask5do7DgHNpJXQFDi5MwnLBBj5CWat85mBtkrITCPXWLijgssEA0u
        Er1/VzJC2MISr45vYYewpSQ+v9vLBtHQziix4uEcRghnBqPE3/f3WSGq7CWaW5vZQK5gFtCU
        WL9LHyKsKLHz91yooYISp691M0NcwSfx7msPK0i5hACvREebEESJmsSVSb+gJspI9D2YBXWD
        h8TMWzsZQcqFBGIlmj/wTWBUmIXktVlIXpuFcMMCRuZVjGKpBcW56anFhgWmyHG8iRGcErUs
        dzBOf/tB7xAjEwfjIUYJDmYlEV6/BaIpQrwpiZVVqUX58UWlOanFhxiTgWE9kVlKNDkfmJTz
        SuINzcwsLSyNTAyNzQwNCQubWBqYmBmZWBhbGpspifOK255MFhJITyxJzU5NLUgtgtnCxMEp
        1cBkkbUkMsMjavbHq3V67SIfM7Rjt1k45Jb+Tpucfv7Tcf+7DVxLrzi9T6w5+SaqddvmhXyq
        qm6r68O+fD39YeOu2zcKg3f2VflXvJm5yS5E22S+jIDcpaMsrt3nn2y9UW8gt6pjkd2XKQYb
        3X4q9Wg8ypg4Sd+8S2yBwpQrxl2V9yW5d75Kns5zhXk6x23TBUF7txWzOWy4zezpnDdhqvUL
        jncd0y1WHU9T8ilKquzybtXs6LzMW8Z6u+LerqVCMp0FhcsmT3AT1E9q+L1wxgKtyExJv7k3
        b82avH7qbD159ZfrPpY3JLxJFby7izclmk0x7zejRPcjER8t79OxSutLL/wtmC1+6dzCt84c
        5b+VWIozEg21mIuKEwEoO+IOQAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42LZdlhJXleCWSLFoOGWjMWWf0dYLRZsfMRo
        MWP/U3YHZo++LasYPT5vkgtgiuKySUnNySxLLdK3S+DKWHDoEmvBF56Kj/sXMDcw3ufqYuTk
        kBAwkbg9uYepi5GLQ0hgN6NE25LPjBAJGYk/E9+zdTFyANnCEocPF0PUfGCUOP9uP1gNm4Cu
        xNSXT1lBakQEzCS2rtcDCTMLSEms+3SIDcQWFvCXuHHrFzOIzSKgKnHx1AwmkHJeAVuJlukC
        EJvkJRo7zrGD2LwCghInZz5hgRgjL9G8dTbzBEa+WUhSs5CkFjAyrWKUTC0ozk3PLTYsMMxL
        LdcrTswtLs1L10vOz93ECA4tLc0djNtXfdA7xMjEwXiIUYKDWUmE12+BaIoQb0piZVVqUX58
        UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTKarP0b9Mp/efvXU1BR/ezOT
        B40G7z2dLU5MFSid/5312obNl2UjA5NyOuUenA7R0NDatirnOgfbvUNRq711+A1nJIc/Lrjm
        sXOWda8VR8LJ1SzvDyy8yZlQtf30bMn9z79HfglbPOlkkEHqmpqVXEpXa1x7HTNNWnJOTr4l
        9k5g3pOtj+/Utrsd+ia99Wp+dkh/uXR3wPEs+/gL6VJdJzS0XrXJWLN3rJHRU38tK9VzIU/0
        h96z9UUvPKLjgs7afjUS6gj9kF87M+HA3N3Xd3hs2iOnM9foEPedrlM5H2W37Es66JeicW7t
        PrczS5l3H2vpfFoU8ifF8Ypi3dq3thZqzA5Tb9lUTI51T6japcRSnJFoqMVcVJwIAFmjeaSc
        AgAA
X-CMS-MailID: 20230320065416epcas1p2511cb60bfb14ed2048e5d39677490c78
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-ArchiveUser: EV
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230320065416epcas1p2511cb60bfb14ed2048e5d39677490c78
References: <CGME20230320065416epcas1p2511cb60bfb14ed2048e5d39677490c78@epcas1p2.samsung.com>
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

