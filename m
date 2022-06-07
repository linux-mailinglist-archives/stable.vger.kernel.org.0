Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C040541BE7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379118AbiFGVzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382610AbiFGVvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:51:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8282F02D;
        Tue,  7 Jun 2022 12:09:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03C83618E2;
        Tue,  7 Jun 2022 19:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137CEC385A2;
        Tue,  7 Jun 2022 19:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628945;
        bh=RLD4YtdsaYVnX+6jAT3sOdk/Zl8sOQA3J/lFzBYiBgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUiGrv2263SsMgpmmmGaVSchA+A3JWWyoKZheAvfF2ICmoyKBe/ZQOn5rr8Ojq6Vh
         5lldif4PSom6HUutcq2ExLl/3E0nslB4TP/KvZVuZCx8boVduXD3kMTwk177v4qukS
         yJXEfb6HK3Jvt8Hbgi2n3IoyviAK5BAtcjvSfwD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Iwona Winiarska <iwona.winiarska@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 514/879] hwmon: (dimmtemp) Fix bitmap handling
Date:   Tue,  7 Jun 2022 19:00:32 +0200
Message-Id: <20220607165017.796984550@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 9baabde04de64137e86b39112c6259f3da512bd6 ]

Building arm:allmodconfig may fail with the following error.

In function 'fortify_memcpy_chk',
    inlined from 'bitmap_copy' at include/linux/bitmap.h:261:2,
    inlined from 'bitmap_copy_clear_tail' at include/linux/bitmap.h:270:2,
    inlined from 'bitmap_from_u64' at include/linux/bitmap.h:622:2,
    inlined from 'check_populated_dimms' at
	drivers/hwmon/peci/dimmtemp.c:284:2:
include/linux/fortify-string.h:344:25: error:
	call to '__write_overflow_field' declared with attribute warning:
	detected write beyond size of field (1st parameter)

The problematic code is
	bitmap_from_u64(priv->dimm_mask, dimm_mask);

dimm_mask is declared as u64, but the bitmap in priv->dimm_mask is only
24 bit wide. On 32-bit systems, this results in writes over the end of
the bitmap.

Fix the problem by using u32 instead of u64 for dimm_mask. This is
currently sufficient, and a compile time check to ensure that the number
of dimms does not exceed the bit map size is already in place.

Fixes: 73bc1b885dae ("hwmon: peci: Add dimmtemp driver")
Cc: Iwona Winiarska <iwona.winiarska@intel.com>
Reviewed-by: Iwona Winiarska <iwona.winiarska@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/peci/dimmtemp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/peci/dimmtemp.c b/drivers/hwmon/peci/dimmtemp.c
index c8222354c005..53e58a9c28ea 100644
--- a/drivers/hwmon/peci/dimmtemp.c
+++ b/drivers/hwmon/peci/dimmtemp.c
@@ -219,7 +219,7 @@ static int check_populated_dimms(struct peci_dimmtemp *priv)
 	int chan_rank_max = priv->gen_info->chan_rank_max;
 	int dimm_idx_max = priv->gen_info->dimm_idx_max;
 	u32 chan_rank_empty = 0;
-	u64 dimm_mask = 0;
+	u32 dimm_mask = 0;
 	int chan_rank, dimm_idx, ret;
 	u32 pcs;
 
@@ -278,9 +278,9 @@ static int check_populated_dimms(struct peci_dimmtemp *priv)
 		return -EAGAIN;
 	}
 
-	dev_dbg(priv->dev, "Scanned populated DIMMs: %#llx\n", dimm_mask);
+	dev_dbg(priv->dev, "Scanned populated DIMMs: %#x\n", dimm_mask);
 
-	bitmap_from_u64(priv->dimm_mask, dimm_mask);
+	bitmap_from_arr32(priv->dimm_mask, &dimm_mask, DIMM_NUMS_MAX);
 
 	return 0;
 }
-- 
2.35.1



