Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A85AEC73
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbiIFOKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241275AbiIFOJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:09:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E223586B55;
        Tue,  6 Sep 2022 06:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44A946154A;
        Tue,  6 Sep 2022 13:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BEAC433D7;
        Tue,  6 Sep 2022 13:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471919;
        bh=WsIXHhwZKqW9vpxERr/6UpLNcCO2QaZy90B67zbXNXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xebnjNgbpVS84yqqF14plF4TKEcLQtvsVXBHDysxKjSbOQMz1+CBG3wAkm3u9DZgQ
         y4v5Cr02l+6I1ZC6iZgXrWezWcMrLXJCkORta64GM54vJ9PBOjtJuyJJ1YLOgdEH5o
         eNJMmA1IN3MxTebDHMnh7vhPEr6b3tVFWQBCo0k4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 085/155] clk: ti: Fix missing of_node_get() ti_find_clock_provider()
Date:   Tue,  6 Sep 2022 15:30:33 +0200
Message-Id: <20220906132833.020109251@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 26f2da0d2f823dc7180b0505d46318f64d1e0a7a ]

For ti_find_clock_provider() we want to return the np with refcount
incremented. However we are missing of_node_get() for the
clock-output-names case that causes refcount warnings.

Fixes: 51f661ef9a10 ("clk: ti: Add ti_find_clock_provider() to use clock-output-names")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220621091118.33930-1-tony@atomide.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 3463579220b51..121d8610beb15 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -143,6 +143,7 @@ static struct device_node *ti_find_clock_provider(struct device_node *from,
 			continue;
 
 		if (!strncmp(n, tmp, strlen(tmp))) {
+			of_node_get(np);
 			found = true;
 			break;
 		}
-- 
2.35.1



