Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3C859241E
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 18:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbiHNQ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 12:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242341AbiHNQ1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 12:27:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636221A82F;
        Sun, 14 Aug 2022 09:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41FBAB80AEE;
        Sun, 14 Aug 2022 16:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD4C43470;
        Sun, 14 Aug 2022 16:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660494216;
        bh=wL+I1X6OYqaa+s1yOlsuInujXPWsQqoekriR1F0yces=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LX1vvYxddXiF7Dm0fpmnYAtWJP3OZWh4up2YBmrm/gnjxJDl6/dcf2m0X3ylsoI9m
         D8TkYrEc/2I9Xjff7ESb3PAVJXbisWpJ6J9QM8hwlvZcbJ4cCvPIDN8L9n6IFSEIMb
         R701H28M7SUPJn4ugYsi0mOA2Fa7KjhN00pqOuE7K2zgunfJnyZ3SCkGAxw/2c4K9B
         boGW0ZgyEdTaI6k+JQc3CM6GaJR+n9YTIRS+e7uqE+cTe7xO2dNhOQy0w+7TsTOT+i
         zMxpVXN3gXjWh71uSgjKRy9N/IM6XtG/SPgjnF/72YMcqgVdc8nLuatt+U92YqZTXs
         tf4HA8PgWJ9sQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liang He <windhl@126.com>, Timur Tabi <timur@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 02/39] tty: serial: Fix refcount leak bug in ucc_uart.c
Date:   Sun, 14 Aug 2022 12:22:51 -0400
Message-Id: <20220814162332.2396012-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814162332.2396012-1-sashal@kernel.org>
References: <20220814162332.2396012-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit d24d7bb2cd947676f9b71fb944d045e09b8b282f ]

In soc_info(), of_find_node_by_type() will return a node pointer
with refcount incremented. We should use of_node_put() when it is
not used anymore.

Acked-by: Timur Tabi <timur@kernel.org>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220618060850.4058525-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/ucc_uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 6000853973c1..3cc9ef08455c 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1137,6 +1137,8 @@ static unsigned int soc_info(unsigned int *rev_h, unsigned int *rev_l)
 		/* No compatible property, so try the name. */
 		soc_string = np->name;
 
+	of_node_put(np);
+
 	/* Extract the SOC number from the "PowerPC," string */
 	if ((sscanf(soc_string, "PowerPC,%u", &soc) != 1) || !soc)
 		return 0;
-- 
2.35.1

