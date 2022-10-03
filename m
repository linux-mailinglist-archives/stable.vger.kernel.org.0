Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10465F291F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJCHOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJCHNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:13:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D833EA4F;
        Mon,  3 Oct 2022 00:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6D4B60F9A;
        Mon,  3 Oct 2022 07:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F6C433D6;
        Mon,  3 Oct 2022 07:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781167;
        bh=Lh2CViwMROmNg68AF88Ts0GLIYttPkhHlWpqusuk6MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgydtPEwImhvdxT17zVv59hmNgSK29b+q40xcZmkfvmchHcc5RboEkaqK4CRy6cMb
         jGTmtLlxlku7i8X1Kf6anDcz1O8aYF2TODpbbYk9Lkdz6ALmVpnEHss7+BtoWRpN47
         yCPdsx51ABbuj0F8tIagPeSbbtKR/XyIII4SWLBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 006/101] counter: 104-quad-8: Fix skipped IRQ lines during events configuration
Date:   Mon,  3 Oct 2022 09:10:02 +0200
Message-Id: <20221003070724.662230508@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 2bc54aaa65d2126ae629919175708a28ce7ef06e ]

IRQ trigger configuration is skipped if it has already been set before;
however, the IRQ line still needs to be OR'd to irq_enabled because
irq_enabled is reset for every events_configure call. This patch moves
the irq_enabled OR operation update to before the irq_trigger check so
that IRQ line enablement is not skipped.

Fixes: c95cc0d95702 ("counter: 104-quad-8: Fix persistent enabled events bug")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20220815122301.2750-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/179eed11eaf225dbd908993b510df0c8f67b1230.1663844776.git.william.gray@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/counter/104-quad-8.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 62c2b7ac4339..4407203e0c9b 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -449,6 +449,9 @@ static int quad8_events_configure(struct counter_device *counter)
 			return -EINVAL;
 		}
 
+		/* Enable IRQ line */
+		irq_enabled |= BIT(event_node->channel);
+
 		/* Skip configuration if it is the same as previously set */
 		if (priv->irq_trigger[event_node->channel] == next_irq_trigger)
 			continue;
@@ -462,9 +465,6 @@ static int quad8_events_configure(struct counter_device *counter)
 			  priv->irq_trigger[event_node->channel] << 3;
 		iowrite8(QUAD8_CTR_IOR | ior_cfg,
 			 &priv->reg->channel[event_node->channel].control);
-
-		/* Enable IRQ line */
-		irq_enabled |= BIT(event_node->channel);
 	}
 
 	iowrite8(irq_enabled, &priv->reg->index_interrupt);
-- 
2.35.1



