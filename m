Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6879F4BDE73
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352082AbiBUJzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:55:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352073AbiBUJzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D0387BB;
        Mon, 21 Feb 2022 01:24:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A125C60FCC;
        Mon, 21 Feb 2022 09:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897EEC340E9;
        Mon, 21 Feb 2022 09:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435452;
        bh=BNVmtUYVnmuinax3C7ACSj9zjInJX74bgTglaPhnYKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkreUG9hhBsPiQP7hCson7YUjdeIGX85lm8LXW+4hCpN3n+RHJnC26lLKARhrUTwc
         wpqTZyg56+prnsVSUY1Iu7yecZ6IISatNeHf5IPZou2E51ycyyly3X/L/LwtaZq3B/
         J0JxBAdiMLl4UBIxiYTKLJkCJ7X6kkYm0m1uU1ug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.16 168/227] mtd: phram: Prevent divide by zero bug in phram_setup()
Date:   Mon, 21 Feb 2022 09:49:47 +0100
Message-Id: <20220221084940.406240823@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 3e3765875b1b8864898603768fd5c93eeb552211 upstream.

The problem is that "erasesize" is a uint64_t type so it might be
non-zero but the lower 32 bits are zero so when it's truncated,
"(uint32_t)erasesize", then that value is zero. This leads to a
divide by zero bug.

Avoid the bug by delaying the divide until after we have validated
that "erasesize" is non-zero and within the uint32_t range.

Fixes: dc2b3e5cbc80 ("mtd: phram: use div_u64_rem to stop overwrite len in phram_setup")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220121115505.GI1978@kadam
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/phram.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -264,15 +264,19 @@ static int phram_setup(const char *val)
 		}
 	}
 
-	if (erasesize)
-		div_u64_rem(len, (uint32_t)erasesize, &rem);
-
 	if (len == 0 || erasesize == 0 || erasesize > len
-	    || erasesize > UINT_MAX || rem) {
+	    || erasesize > UINT_MAX) {
 		parse_err("illegal erasesize or len\n");
 		ret = -EINVAL;
 		goto error;
 	}
+
+	div_u64_rem(len, (uint32_t)erasesize, &rem);
+	if (rem) {
+		parse_err("len is not multiple of erasesize\n");
+		ret = -EINVAL;
+		goto error;
+	}
 
 	ret = register_device(name, start, len, (uint32_t)erasesize);
 	if (ret)


