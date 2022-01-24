Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431EC49902D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351957AbiAXT6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:58:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50246 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbiAXTwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:52:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1580860989;
        Mon, 24 Jan 2022 19:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAB1C340E8;
        Mon, 24 Jan 2022 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053969;
        bh=HkJde7G0N3DRpmHjssvvdYfr06UK7b1u/hUJBLTfLf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWjdYUDEYkQS17SfaxzHQxD0xOFt9HQJXJ6Ng5oiOi3YfHrufv9d0+2CzQI61NyCH
         C+LIlUpWArhp3jej1Zuvz/+HyCr7A/8z+P5zlW7TJLC3dt1sXq2m1K9xlYRQBxv8qh
         uMrCwR6zgEY/bK5JZB6zDavMWAql/B2etcECtDWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/563] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
Date:   Mon, 24 Jan 2022 19:40:01 +0100
Message-Id: <20220124184032.606666415@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index fe3d52620a897..b1335fe3b01a2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -967,8 +967,7 @@ static void iwl_mvm_ftm_rtt_smoothing(struct iwl_mvm *mvm,
 	overshoot = IWL_MVM_FTM_INITIATOR_SMOOTH_OVERSHOOT;
 	alpha = IWL_MVM_FTM_INITIATOR_SMOOTH_ALPHA;
 
-	rtt_avg = alpha * rtt + (100 - alpha) * resp->rtt_avg;
-	do_div(rtt_avg, 100);
+	rtt_avg = div_s64(alpha * rtt + (100 - alpha) * resp->rtt_avg, 100);
 
 	IWL_DEBUG_INFO(mvm,
 		       "%pM: prev rtt_avg=%lld, new rtt_avg=%lld, rtt=%lld\n",
-- 
2.34.1



