Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE28499B2D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574748AbiAXVuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457581AbiAXVly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BA8C07E338;
        Mon, 24 Jan 2022 12:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00B7A6152E;
        Mon, 24 Jan 2022 20:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BFEC340E5;
        Mon, 24 Jan 2022 20:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056185;
        bh=cFONM5VO67T7vw1Ikt1XC83kSbbTMBI2w2W/licUUvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BoUKezO1vC1Lj5OS4x6q/HefQXXVO+lnydLX1am1Dx1tLYeHUsuYXc9SaGDtSKjgN
         sG23soaNoElAWsX64/ufXHvk1fCtmE2ViNDEkWtaUa0zN7u0iPB0M8lOqEYChQhu3L
         MUKM7y2sx74RjemP0k+qTpVH+94J7MbAgOUwNIjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/846] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
Date:   Mon, 24 Jan 2022 19:38:04 +0100
Message-Id: <20220124184113.599960825@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 4ccdcc8ffd955490feec05380223db6a48961eb5 ]

When building ARCH=arm allmodconfig:

drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c: In function ‘iwl_mvm_ftm_rtt_smoothing’:
./include/asm-generic/div64.h:222:35: error: comparison of distinct pointer types lacks a cast [-Werror]
  222 |         (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
      |                                   ^~
drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1070:9: note: in expansion of macro ‘do_div’
 1070 |         do_div(rtt_avg, 100);
      |         ^~~~~~

do_div() has to be used with an unsigned 64-bit integer dividend but
rtt_avg is a signed 64-bit integer.

div_s64() expects a signed 64-bit integer dividend and signed 32-bit
divisor, which fits this scenario, so use that function here to fix the
warning.

Fixes: 8b0f92549f2c ("iwlwifi: mvm: fix 32-bit build in FTM")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20211227191757.2354329-1-nathan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 6e1d37f258035..bb5fff8174435 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -1054,8 +1054,7 @@ static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 	overshoot = IWL_MVM_FTM_INITIATOR_SMOOTH_OVERSHOOT;
 	alpha = IWL_MVM_FTM_INITIATOR_SMOOTH_ALPHA;
 
-	rtt_avg = alpha * rtt + (100 - alpha) * resp->rtt_avg;
-	do_div(rtt_avg, 100);
+	rtt_avg = div_s64(alpha * rtt + (100 - alpha) * resp->rtt_avg, 100);
 
 	IWL_DEBUG_INFO(mvm,
 		       "%pM: prev rtt_avg=%lld, new rtt_avg=%lld, rtt=%lld\n",
-- 
2.34.1



