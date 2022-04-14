Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E729F500F07
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244160AbiDNNXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244182AbiDNNWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:22:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D309391557;
        Thu, 14 Apr 2022 06:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79E7FB8296D;
        Thu, 14 Apr 2022 13:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2191C385A1;
        Thu, 14 Apr 2022 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942278;
        bh=t7k5Z8xW/UXhospe3ujYiUIvZzorl8/rIkYHU2jTO18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C45dLFKo0wYKblzD7tEBgjpfGXmiZ5aWHQ5yRFmW0mmilEXt0/NlxNZtjRRDWaKQ4
         soRlIe5zyW1Njhpfm0J8kYbPXr7F4Jw7N01gcXYUEVv+OL3XvZ20NkKRDej4azgUEX
         yioEEN0S7vajQS582izZR1sImDRlXeML+RHsXL5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Ranquet <granquet@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/338] clocksource/drivers/timer-of: Check return value of of_iomap in timer_of_base_init()
Date:   Thu, 14 Apr 2022 15:09:42 +0200
Message-Id: <20220414110841.147921739@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Guillaume Ranquet <granquet@baylibre.com>

[ Upstream commit 4467b8bad2401794fb89a0268c8c8257180bf60f ]

of_base->base can either be iomapped using of_io_request_and_map() or
of_iomap() depending whether or not an of_base->name has been set.

Thus check of_base->base against NULL as of_iomap() does not return a
PTR_ERR() in case of error.

Fixes: 9aea417afa6b ("clocksource/drivers/timer-of: Don't request the resource by name")
Signed-off-by: Guillaume Ranquet <granquet@baylibre.com>
Link: https://lore.kernel.org/r/20220307172656.4836-1-granquet@baylibre.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-of.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-of.c b/drivers/clocksource/timer-of.c
index 6e2cb3693ed8..82bb0d39e8af 100644
--- a/drivers/clocksource/timer-of.c
+++ b/drivers/clocksource/timer-of.c
@@ -164,9 +164,9 @@ static __init int timer_of_base_init(struct device_node *np,
 	of_base->base = of_base->name ?
 		of_io_request_and_map(np, of_base->index, of_base->name) :
 		of_iomap(np, of_base->index);
-	if (IS_ERR(of_base->base)) {
-		pr_err("Failed to iomap (%s)\n", of_base->name);
-		return PTR_ERR(of_base->base);
+	if (IS_ERR_OR_NULL(of_base->base)) {
+		pr_err("Failed to iomap (%s:%s)\n", np->name, of_base->name);
+		return of_base->base ? PTR_ERR(of_base->base) : -ENOMEM;
 	}
 
 	return 0;
-- 
2.34.1



