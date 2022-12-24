Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4DF655717
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiLXBbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiLXBbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:31:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F913055B;
        Fri, 23 Dec 2022 17:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B41861BFB;
        Sat, 24 Dec 2022 01:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67CDC433EF;
        Sat, 24 Dec 2022 01:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845423;
        bh=lQ5K7ti7ooaQbz7h7OzPaF6tCLSFNqN5Idal7gXxsko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d73isXt/iWdpK4/g1qQbwgvgmV/X8UlOe/pxzB6fZvCrI4vwZLb4B0qTLIS4CHUZH
         w1ru7JQen4J2vSGrqdV93U1alsTEKWGOmimbVKV2VICnubsLkT+4gcLQuPfUOsLc4z
         MhKy0Bn8KiqGhXhUlVEWyWdygE3PufBPaia4FnRrZ/ZvvRAhXwC/Ppvxb3gDkjOSxC
         jqXVc6J9KU6AcgUtLIbbx7sAu/501/cOHdSlFrGwrN2JAajXMrOogNSNkbE55dcGRs
         d3fWRTsvU44dJWJ5ssYqRXT6/YDADc9Mzx5be5L3Ohh53NreimeIv3/mQtnSrCBIdu
         sVJik0+sqTNmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Antoniu Miclaus <antoniu.miclaus@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, lars@metafoo.de,
        Michael.Hennerich@analog.com, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 20/26] iio: filter: admv8818: close potential out-of-bounds read in __admv8818_read_[h|l]pf_freq()
Date:   Fri, 23 Dec 2022 20:29:24 -0500
Message-Id: <20221224012930.392358-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224012930.392358-1-sashal@kernel.org>
References: <20221224012930.392358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 3f4033a811bcd1a1f077ce5297488a5c4dd30eb1 ]

ADMV8818_SW_IN_WR0_MSK and ADMV8818_SW_OUT_WR0_MSK have 3 bits,
which means a length of 8, but freq_range_hpf and freq_range_lpf
array size is 4, may end up reading 4 elements beyond the end of
those arrays.

Check value first before access freq_range_hpf and freq_range_lpf
to harden against the hardware allowing out of range values.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://lore.kernel.org/r/20220922115848.1800021-1-weiyongjun@huaweicloud.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/filter/admv8818.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/filter/admv8818.c b/drivers/iio/filter/admv8818.c
index 68de45fe21b4..fe8d46cb7f1d 100644
--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -265,7 +265,7 @@ static int __admv8818_read_hpf_freq(struct admv8818_state *st, u64 *hpf_freq)
 		return ret;
 
 	hpf_band = FIELD_GET(ADMV8818_SW_IN_WR0_MSK, data);
-	if (!hpf_band) {
+	if (!hpf_band || hpf_band > 4) {
 		*hpf_freq = 0;
 		return ret;
 	}
@@ -303,7 +303,7 @@ static int __admv8818_read_lpf_freq(struct admv8818_state *st, u64 *lpf_freq)
 		return ret;
 
 	lpf_band = FIELD_GET(ADMV8818_SW_OUT_WR0_MSK, data);
-	if (!lpf_band) {
+	if (!lpf_band || lpf_band > 4) {
 		*lpf_freq = 0;
 		return ret;
 	}
-- 
2.35.1

