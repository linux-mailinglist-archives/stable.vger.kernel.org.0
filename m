Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB1463DF13
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiK3Snj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiK3Sn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B848B65BC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 636F7B81CA8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D31C433C1;
        Wed, 30 Nov 2022 18:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833805;
        bh=FV9cKpXU40ig1PLuoNySucKUItQdqkjAvnyrw0XqHSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkn+ssDlE6LRcWC1AEURULJj89Jjgd+yKDIx1dEN7ci32GHL7/+fvGHO755DRiohF
         g0S/D1KS9tkTGYTi7+4CSPnPkJ55Hf1zKvNxxO4Th5z2hsY4e9jhZEzukheQjDvG+W
         TQVuT6x4/CxSKaX+LdX2O14ADqX9voFuyVoBr85Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Zhang <quic_paulz@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 005/289] wifi: cfg80211: Fix bitrates overflow issue
Date:   Wed, 30 Nov 2022 19:19:50 +0100
Message-Id: <20221130180544.238892050@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Zhang <quic_paulz@quicinc.com>

[ Upstream commit 18429c51c7ff6e6bfd627316c54670230967a7e5 ]

When invoking function cfg80211_calculate_bitrate_eht about
(320 MHz, EHT-MCS 13, EHT-NSS 2, EHT-GI 0), which means the
parameters as flags: 0x80, bw: 7, mcs: 13, eht_gi: 0, nss: 2,
this formula (result * rate->nss) will overflow and causes
the returned bitrate to be 3959 when it should be 57646.

Here is the explanation:
 u64 tmp;
 u32 result;
 …
 /* tmp = result = 4 * rates_996[0]
  *     = 4 * 480388888 = 0x72889c60
  */
 tmp = result;

 /* tmp = 0x72889c60 * 6144 = 0xabccea90000 */
 tmp *= SCALE;

 /* tmp = 0xabccea90000 / mcs_divisors[13]
  *     = 0xabccea90000 / 5120 = 0x8970bba6
  */
 do_div(tmp, mcs_divisors[rate->mcs]);

 /* result = 0x8970bba6 */
 result = tmp;

 /* normally (result * rate->nss) = 0x8970bba6 * 2 = 0x112e1774c,
  * but since result is u32, (result * rate->nss) = 0x12e1774c,
  * overflow happens and it loses the highest bit.
  * Then result =  0x12e1774c / 8 = 39595753,
  */
 result = (result * rate->nss) / 8;

Signed-off-by: Paul Zhang <quic_paulz@quicinc.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 775836f6785a..450d609b512a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1555,10 +1555,12 @@ static u32 cfg80211_calculate_bitrate_eht(struct rate_info *rate)
 	tmp = result;
 	tmp *= SCALE;
 	do_div(tmp, mcs_divisors[rate->mcs]);
-	result = tmp;
 
 	/* and take NSS */
-	result = (result * rate->nss) / 8;
+	tmp *= rate->nss;
+	do_div(tmp, 8);
+
+	result = tmp;
 
 	return result / 10000;
 }
-- 
2.35.1



