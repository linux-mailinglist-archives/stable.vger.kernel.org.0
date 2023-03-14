Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E386B945A
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 13:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjCNMoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 08:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjCNMoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 08:44:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B54597FD3;
        Tue, 14 Mar 2023 05:43:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E3B8B81906;
        Tue, 14 Mar 2023 12:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD9C433EF;
        Tue, 14 Mar 2023 12:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678797801;
        bh=AY/Ig6/D6B8kAit4w8uSAEvPz3sYAX7+kRJBXfUowsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVU6ng439p6BJyoms5qFXTQtMjzQZTzHFespAmfIp+lr1hAALyxT02SNauWnlAf7r
         0PnyyknyMeq1s3hsxbE53FYwgAQY44lHOoocglClZE0mjBpkmVocIOUSa5VPZaihSB
         Buj73b03rHsw2Z4FSEJqaeZppcK6tnfnAdU+xB4I6SLY3yGeVP8GCT0YHMXey4gZzS
         4mHTKBgopceHYIzgdYL1wK9frE4f1HqPykfjZMI2yTooRo6BDWxhJ+CiK3XGGPFGkZ
         OOdtOHUWTisRByqcm1DL8Ti3nvH5pKvZeyRmR2mORhiQXKMOVwAWGKY+6sMdKnUYhC
         lNh/SEwkJt34Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.2 11/13] sh: intc: Avoid spurious sizeof-pointer-div warning
Date:   Tue, 14 Mar 2023 08:43:03 -0400
Message-Id: <20230314124305.470657-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314124305.470657-1-sashal@kernel.org>
References: <20230314124305.470657-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 250870824c1cf199b032b1ef889c8e8d69d9123a ]

GCC warns about the pattern sizeof(void*)/sizeof(void), as it looks like
the abuse of a pattern to calculate the array size. This pattern appears
in the unevaluated part of the ternary operator in _INTC_ARRAY if the
parameter is NULL.

The replacement uses an alternate approach to return 0 in case of NULL
which does not generate the pattern sizeof(void*)/sizeof(void), but still
emits the warning if _INTC_ARRAY is called with a nonarray parameter.

This patch is required for successful compilation with -Werror enabled.

The idea to use _Generic for type distinction is taken from Comment #7
in https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108483 by Jakub Jelinek

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://lore.kernel.org/r/619fa552-c988-35e5-b1d7-fe256c46a272@mkarcher.dialup.fu-berlin.de
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sh_intc.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/sh_intc.h b/include/linux/sh_intc.h
index c255273b02810..37ad81058d6ae 100644
--- a/include/linux/sh_intc.h
+++ b/include/linux/sh_intc.h
@@ -97,7 +97,10 @@ struct intc_hw_desc {
 	unsigned int nr_subgroups;
 };
 
-#define _INTC_ARRAY(a) a, __same_type(a, NULL) ? 0 : sizeof(a)/sizeof(*a)
+#define _INTC_SIZEOF_OR_ZERO(a) (_Generic(a,                 \
+                                 typeof(NULL):  0,           \
+                                 default:       sizeof(a)))
+#define _INTC_ARRAY(a) a, _INTC_SIZEOF_OR_ZERO(a)/sizeof(*a)
 
 #define INTC_HW_DESC(vectors, groups, mask_regs,	\
 		     prio_regs,	sense_regs, ack_regs)	\
-- 
2.39.2

