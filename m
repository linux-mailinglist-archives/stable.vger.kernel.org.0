Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6BA4F3307
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245456AbiDEIzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241202AbiDEIcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D1A1DA;
        Tue,  5 Apr 2022 01:29:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF5D6062B;
        Tue,  5 Apr 2022 08:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E884DC385A2;
        Tue,  5 Apr 2022 08:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147365;
        bh=58RmXMaSK5PuvhFzkytvjVsSYIvGzU7PtUDOIzpbiJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBZZxk4AZo1XRshkaBGaIFJSv7bbn2mBq9Ua9noB+P7+aA9L/A/iuhQLsJhmZS+l3
         MCbCk86yGNH4BHLqVSTsPNYs1ms5wZWEFfsNUPHHD+/kBz2jCCc/cFSB9dydkX3kwn
         osC52s5D4NSamOI7qqNCcXQ54/8+UHgvYWqdWQcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.17 1099/1126] ubi: fastmap: Return error code if memory allocation fails in add_aeb()
Date:   Tue,  5 Apr 2022 09:30:46 +0200
Message-Id: <20220405070439.698946781@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -468,7 +468,9 @@ static int scan_pool(struct ubi_device *
 			if (err == UBI_IO_FF_BITFLIPS)
 				scrub = 1;
 
-			add_aeb(ai, free, pnum, ec, scrub);
+			ret = add_aeb(ai, free, pnum, ec, scrub);
+			if (ret)
+				goto out;
 			continue;
 		} else if (err == 0 || err == UBI_IO_BITFLIPS) {
 			dbg_bld("Found non empty PEB:%i in pool", pnum);
@@ -638,8 +640,10 @@ static int ubi_attach_fastmap(struct ubi
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
@@ -649,8 +653,10 @@ static int ubi_attach_fastmap(struct ubi
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
@@ -660,8 +666,10 @@ static int ubi_attach_fastmap(struct ubi
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
@@ -671,8 +679,10 @@ static int ubi_attach_fastmap(struct ubi
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


