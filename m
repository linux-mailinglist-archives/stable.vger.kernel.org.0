Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B145F99CD
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbiJJHQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiJJHQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:16:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D391E5B79F;
        Mon, 10 Oct 2022 00:10:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7AA0B80E4B;
        Mon, 10 Oct 2022 07:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E57DC433C1;
        Mon, 10 Oct 2022 07:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385712;
        bh=wFaOL2msN++cqgefY2ICCn5WjAPB22W5NnXZDP5dx10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOaadPJU1rK7xIXWJmOTbR2QVPezBLW3iQYwlSu4IcqmETW9uRFcX6lH5WgLRQbXL
         p+o3AvYNWf9EkBhH+IF3J1WIhumRIneqDZSrmhvx9uvpHSWenHDAOyS7KSU4slNc5Y
         xPFZANR+2HJimz0dN9LmUCoOrnwHRekm/yyoj6eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 33/37] wifi: cfg80211: fix MCS divisor value
Date:   Mon, 10 Oct 2022 09:05:52 +0200
Message-Id: <20221010070332.149942326@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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

From: Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>

[ Upstream commit 64e966d1e84b29c9fa916cfeaabbf4013703942e ]

The Bitrate for HE/EHT MCS6 is calculated wrongly due to the
incorrect MCS divisor value for mcs6. Fix it with the proper
value.

previous mcs_divisor value = (11769/6144) = 1.915527

fixed mcs_divisor value = (11377/6144) = 1.851725

Fixes: 9c97c88d2f4b ("cfg80211: Add support to calculate and report 4096-QAM HE rates")
Signed-off-by: Tamizh Chelvam Raja <quic_tamizhr@quicinc.com>
Link: https://lore.kernel.org/r/20220908181034.9936-1-quic_tamizhr@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4ddc269164f8..cb15d7f4eb05 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1353,7 +1353,7 @@ static u32 cfg80211_calculate_bitrate_he(struct rate_info *rate)
 		 25599, /*  4.166666... */
 		 17067, /*  2.777777... */
 		 12801, /*  2.083333... */
-		 11769, /*  1.851851... */
+		 11377, /*  1.851725... */
 		 10239, /*  1.666666... */
 		  8532, /*  1.388888... */
 		  7680, /*  1.250000... */
-- 
2.35.1



