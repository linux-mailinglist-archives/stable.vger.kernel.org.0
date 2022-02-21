Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B611B4BE6C4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350637AbiBUJed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:34:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350409AbiBUJeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:34:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E70A29826;
        Mon, 21 Feb 2022 01:14:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CB8ACE0E93;
        Mon, 21 Feb 2022 09:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDC1C340EB;
        Mon, 21 Feb 2022 09:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434811;
        bh=BNVmtUYVnmuinax3C7ACSj9zjInJX74bgTglaPhnYKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMadomUPY9+dE4GKOaPpqoKdxd/5dRu3Y37rV06kW3u0ySZluQyGNB3v9OxJYX0Un
         x0ISlwB9Lt7YCyyOaNHETtgvLe04gTG/gLS4w636P8bIkcyvACdpm4RM30ftcA3LU3
         Ob9BVZu5vyYxHSh6O5uVBFyl4LXLQ6wyhUbTAQ1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 139/196] mtd: phram: Prevent divide by zero bug in phram_setup()
Date:   Mon, 21 Feb 2022 09:49:31 +0100
Message-Id: <20220221084935.577841576@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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


