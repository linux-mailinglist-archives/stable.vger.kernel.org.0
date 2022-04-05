Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73D4F263A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiDEHz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbiDEHyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5617334652;
        Tue,  5 Apr 2022 00:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5E89B81B9C;
        Tue,  5 Apr 2022 07:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424C9C340EE;
        Tue,  5 Apr 2022 07:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145016;
        bh=cOvpwQJTw7gWEKGJhWUj4AsASxuLwhZB0JKb1hmt1Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXXEwRP8VxQeQbeDiRj2NPOslLWadMmXbc1bsDiB4xXVvuoNjeDK7VpGYRWF9yECB
         AEoJ2imXzmiTgMTfNxD54HyOMp9SbJ9ImuUVVYTIKA5qOKSO57WgZ5hB5ldpYKIc3r
         vtVT5SQvSsf0TX/I61dsay7UWTZ8ClOTjm094kCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0253/1126] perf/arm-cmn: Update watchpoint format
Date:   Tue,  5 Apr 2022 09:16:40 +0200
Message-Id: <20220405070415.036583062@linuxfoundation.org>
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 31fac565773981df43f018b2dbfbc7a3164f4b6c ]

>From CMN-650 onwards, some of the fields in the watchpoint config
registers moved subtly enough to easily overlook. Watchpoint events are
still only partially supported on newer IPs - which in itself deserves
noting - but were not intended to become any *less* functional than on
CMN-600.

Fixes: 60d1504070c2 ("perf/arm-cmn: Support new IP features")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/e1ce4c2f1e4f73ab1c60c3a85e4037cd62dd6352.1645727871.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index d45e8c17e1f8..71448229bc5e 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -71,9 +71,11 @@
 #define CMN_DTM_WPn(n)			(0x1A0 + (n) * 0x18)
 #define CMN_DTM_WPn_CONFIG(n)		(CMN_DTM_WPn(n) + 0x00)
 #define CMN_DTM_WPn_CONFIG_WP_DEV_SEL2	GENMASK_ULL(18,17)
-#define CMN_DTM_WPn_CONFIG_WP_COMBINE	BIT(6)
-#define CMN_DTM_WPn_CONFIG_WP_EXCLUSIVE	BIT(5)
-#define CMN_DTM_WPn_CONFIG_WP_GRP	BIT(4)
+#define CMN_DTM_WPn_CONFIG_WP_COMBINE	BIT(9)
+#define CMN_DTM_WPn_CONFIG_WP_EXCLUSIVE	BIT(8)
+#define CMN600_WPn_CONFIG_WP_COMBINE	BIT(6)
+#define CMN600_WPn_CONFIG_WP_EXCLUSIVE	BIT(5)
+#define CMN_DTM_WPn_CONFIG_WP_GRP	GENMASK_ULL(5, 4)
 #define CMN_DTM_WPn_CONFIG_WP_CHN_SEL	GENMASK_ULL(3, 1)
 #define CMN_DTM_WPn_CONFIG_WP_DEV_SEL	BIT(0)
 #define CMN_DTM_WPn_VAL(n)		(CMN_DTM_WPn(n) + 0x08)
@@ -155,6 +157,7 @@
 #define CMN_CONFIG_WP_COMBINE		GENMASK_ULL(27, 24)
 #define CMN_CONFIG_WP_DEV_SEL		GENMASK_ULL(50, 48)
 #define CMN_CONFIG_WP_CHN_SEL		GENMASK_ULL(55, 51)
+/* Note that we don't yet support the tertiary match group on newer IPs */
 #define CMN_CONFIG_WP_GRP		BIT_ULL(56)
 #define CMN_CONFIG_WP_EXCLUSIVE		BIT_ULL(57)
 #define CMN_CONFIG1_WP_VAL		GENMASK_ULL(63, 0)
@@ -908,15 +911,18 @@ static u32 arm_cmn_wp_config(struct perf_event *event)
 	u32 grp = CMN_EVENT_WP_GRP(event);
 	u32 exc = CMN_EVENT_WP_EXCLUSIVE(event);
 	u32 combine = CMN_EVENT_WP_COMBINE(event);
+	bool is_cmn600 = to_cmn(event->pmu)->model == CMN600;
 
 	config = FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_DEV_SEL, dev) |
 		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_CHN_SEL, chn) |
 		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_GRP, grp) |
-		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_EXCLUSIVE, exc) |
 		 FIELD_PREP(CMN_DTM_WPn_CONFIG_WP_DEV_SEL2, dev >> 1);
+	if (exc)
+		config |= is_cmn600 ? CMN600_WPn_CONFIG_WP_EXCLUSIVE :
+				      CMN_DTM_WPn_CONFIG_WP_EXCLUSIVE;
 	if (combine && !grp)
-		config |= CMN_DTM_WPn_CONFIG_WP_COMBINE;
-
+		config |= is_cmn600 ? CMN600_WPn_CONFIG_WP_COMBINE :
+				      CMN_DTM_WPn_CONFIG_WP_COMBINE;
 	return config;
 }
 
-- 
2.34.1



