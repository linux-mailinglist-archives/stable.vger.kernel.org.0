Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AC76E634D
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjDRMj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjDRMjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840581386B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EA25632E9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F81FC433EF;
        Tue, 18 Apr 2023 12:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821562;
        bh=BqMtq36f+7HGvPLAXLGwZSOUfHS2pj7KmuFL9BlVbdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHmavKG3DSQw1VKLg/xvSxMgoo0NqnBAQGDwqc4UYijHy4++pDJBNg6vTkXedu5H4
         6uRYsz9KD0qqPVBGBIaloOjtFG9kCFdBC7Y+SfzQDVQCfGgBXzipgfljlMQgokV5wx
         OfHXOE40BlM/JxiJqfVGu7odhOuKSUIzrlOVGnJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/91] counter: stm32-lptimer-cnt: Provide defines for clock polarities
Date:   Tue, 18 Apr 2023 14:21:53 +0200
Message-Id: <20230418120307.279136448@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

[ Upstream commit 05593a3fd1037b5fee85d3c8c28112f19e7baa06 ]

The STM32 low-power timer permits configuration of the clock polarity
via the LPTIMX_CFGR register CKPOL bits. This patch provides
preprocessor defines for the supported clock polarities.

Cc: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/a111c8905c467805ca530728f88189b59430f27e.1630031207.git.vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 00f4bc5184c1 ("counter: 104-quad-8: Fix Synapse action reported for Index signals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/stm32-lptimer-cnt.c | 6 +++---
 include/linux/mfd/stm32-lptimer.h   | 5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/counter/stm32-lptimer-cnt.c b/drivers/counter/stm32-lptimer-cnt.c
index fa7f86cf0ea32..a56fbe598e119 100644
--- a/drivers/counter/stm32-lptimer-cnt.c
+++ b/drivers/counter/stm32-lptimer-cnt.c
@@ -140,9 +140,9 @@ static const enum counter_function stm32_lptim_cnt_functions[] = {
 };
 
 enum stm32_lptim_synapse_action {
-	STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE,
-	STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES,
+	STM32_LPTIM_SYNAPSE_ACTION_RISING_EDGE = STM32_LPTIM_CKPOL_RISING_EDGE,
+	STM32_LPTIM_SYNAPSE_ACTION_FALLING_EDGE = STM32_LPTIM_CKPOL_FALLING_EDGE,
+	STM32_LPTIM_SYNAPSE_ACTION_BOTH_EDGES = STM32_LPTIM_CKPOL_BOTH_EDGES,
 	STM32_LPTIM_SYNAPSE_ACTION_NONE,
 };
 
diff --git a/include/linux/mfd/stm32-lptimer.h b/include/linux/mfd/stm32-lptimer.h
index 90b20550c1c8b..06d3f11dc3c9f 100644
--- a/include/linux/mfd/stm32-lptimer.h
+++ b/include/linux/mfd/stm32-lptimer.h
@@ -45,6 +45,11 @@
 #define STM32_LPTIM_PRESC	GENMASK(11, 9)
 #define STM32_LPTIM_CKPOL	GENMASK(2, 1)
 
+/* STM32_LPTIM_CKPOL */
+#define STM32_LPTIM_CKPOL_RISING_EDGE	0
+#define STM32_LPTIM_CKPOL_FALLING_EDGE	1
+#define STM32_LPTIM_CKPOL_BOTH_EDGES	2
+
 /* STM32_LPTIM_ARR */
 #define STM32_LPTIM_MAX_ARR	0xFFFF
 
-- 
2.39.2



