Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735E355DD9D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245242AbiF1C3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244218AbiF1CZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:25:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A713524BD1;
        Mon, 27 Jun 2022 19:23:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59F7DB81C1B;
        Tue, 28 Jun 2022 02:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4309AC36AE3;
        Tue, 28 Jun 2022 02:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383035;
        bh=ZdL7kXYlijASJXlGwtFrtZj74qHRNjaZa+d3EueRukQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7MrhSqhKwE5f6k1ctVnIQ4qaHGpHjBbS89dGbkZrzNlau6GTJY8/Cd7Jo8ZCINcB
         6xNT8GI9Cu6VXrr9FMQmYv2u3ryjEbGW6VbvFDd1KV4Gz+3MQp1M1QyX9/EBk0w7G3
         /Jg1ddM5D5KVB7UMh2jMaCI04kvfqS+B1euPA6VE19KGtzll4kZHU1yiydUT4glZ2K
         fNqm7bN2dh49a9Gkyfyvd7KKu05GmzkDhSEMs1MWBtWxdQ9B0IpwZ8oSdB0bwFRwhK
         7ZWAmlCj/ATTjgSynVPdeWVJWA5L+3alvUxJk/AbPg3XrD0O7pY/IwwWq0VuO6KOce
         0KKblX++OnfRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 27/34] mips: lantiq: Add missing of_node_put() in irq.c
Date:   Mon, 27 Jun 2022 22:22:34 -0400
Message-Id: <20220628022241.595835-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022241.595835-1-sashal@kernel.org>
References: <20220628022241.595835-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 3748d2185ac4c2c6f80989672253aad909ecaf95 ]

In icu_of_init(), of_find_compatible_node() will return a node
pointer with refcount incremented. We should use of_node_put()
when it is not used anymore.

Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/lantiq/irq.c b/arch/mips/lantiq/irq.c
index 43c2f271e6ab..ee4d73d72500 100644
--- a/arch/mips/lantiq/irq.c
+++ b/arch/mips/lantiq/irq.c
@@ -407,6 +407,7 @@ int __init icu_of_init(struct device_node *node, struct device_node *parent)
 		if (!ltq_eiu_membase)
 			panic("Failed to remap eiu memory");
 	}
+	of_node_put(eiu_node);
 
 	return 0;
 }
-- 
2.35.1

