Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D89D5058B0
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 16:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbiDROKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 10:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343828AbiDROI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 10:08:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F7336334;
        Mon, 18 Apr 2022 06:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B8B2B80EE6;
        Mon, 18 Apr 2022 13:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90506C385A7;
        Mon, 18 Apr 2022 13:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287427;
        bh=fzk8MKUGqmpclWYl7A30PfvIc3vCf2G+DHGNqab7TAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO7Ag/Gp4pLekTjfbkP+By4WJZKHloe20Vnda/zn8FeEuMUnl7XMgZzXWvtbkqeLp
         nrZtHJVU6hA118b6H8TNzmGAoqQihXD6kEROXNVESFDvilogUCA4/Ze1R1G1qTGe+5
         0z7Uz1BHAjsUuXCmMmUQ7Tt/qvopoGNgM1C4mLgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4.9 157/218] ubi: fastmap: Return error code if memory allocation fails in add_aeb()
Date:   Mon, 18 Apr 2022 14:13:43 +0200
Message-Id: <20220418121204.502286242@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit c3c07fc25f37c157fde041b3a0c3dfcb1590cbce upstream.

Abort fastmap scanning and return error code if memory allocation fails
in add_aeb(). Otherwise ubi will get wrong peb statistics information
after scanning.

Fixes: dbb7d2a88d2a7b ("UBI: Add fastmap core")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/ubi/fastmap.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -478,7 +478,9 @@ static int scan_pool(struct ubi_device *
 			if (err == UBI_IO_FF_BITFLIPS)
 				scrub = 1;
 
-			add_aeb(ai, free, pnum, ec, scrub);
+			ret = add_aeb(ai, free, pnum, ec, scrub);
+			if (ret)
+				goto out;
 			continue;
 		} else if (err == 0 || err == UBI_IO_BITFLIPS) {
 			dbg_bld("Found non empty PEB:%i in pool", pnum);
@@ -648,8 +650,10 @@ static int ubi_attach_fastmap(struct ubi
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &ai->free, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 0);
+		ret = add_aeb(ai, &ai->free, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 0);
+		if (ret)
+			goto fail;
 	}
 
 	/* read EC values from used list */
@@ -659,8 +663,10 @@ static int ubi_attach_fastmap(struct ubi
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 0);
+		ret = add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 0);
+		if (ret)
+			goto fail;
 	}
 
 	/* read EC values from scrub list */
@@ -670,8 +676,10 @@ static int ubi_attach_fastmap(struct ubi
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 1);
+		ret = add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 1);
+		if (ret)
+			goto fail;
 	}
 
 	/* read EC values from erase list */
@@ -681,8 +689,10 @@ static int ubi_attach_fastmap(struct ubi
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
-		add_aeb(ai, &ai->erase, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 1);
+		ret = add_aeb(ai, &ai->erase, be32_to_cpu(fmec->pnum),
+			      be32_to_cpu(fmec->ec), 1);
+		if (ret)
+			goto fail;
 	}
 
 	ai->mean_ec = div_u64(ai->ec_sum, ai->ec_count);


