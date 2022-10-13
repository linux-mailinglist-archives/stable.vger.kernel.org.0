Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1602C5FD04A
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 02:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiJMAZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 20:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiJMAXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 20:23:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4F9DCADC;
        Wed, 12 Oct 2022 17:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F37F616E4;
        Thu, 13 Oct 2022 00:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8C2C4347C;
        Thu, 13 Oct 2022 00:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620508;
        bh=eeYR1pQLtcJDxO9LFF9+dLExakAoN06GkoHBkN1iWGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdYGE6++TdhQfyW3B7T4YBoSdVehMx4tfyB74ZNVAqbpqxdE0aIkymmRN0slbvRxC
         sFcs6NmE07yt4gCyLLR75l0yxY0dCyNDo6IscB10apKv61uiecc63S+AiKysVzXYFk
         hMtx92KU7F8vOENjqbYAw07Y4MlT+t5L/rICF1mZQLukjw/YtmXDjcrG37vfyN+mql
         XeabsoBZHA4wJ5VHytnn4xPYuCZvH6/KghAniDvV//HpLNVqye4cLo55B7eBNKwROO
         qTUWL1Br/oaklQB5DsCaXHjPO9HukCx1g/DPRGqTQsbGBi3KSofrFwFvm3l/RUrUna
         T5QIsQEl1kovw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Justin Chen <justinpopo6@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, mathias.nyman@intel.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/47] usb: host: xhci-plat: suspend/resume clks for brcm
Date:   Wed, 12 Oct 2022 20:20:41 -0400
Message-Id: <20221013002124.1894077-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002124.1894077-1-sashal@kernel.org>
References: <20221013002124.1894077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit c69400b09e471a3f1167adead55a808f0da6534a ]

The xhci_plat_brcm xhci block can enter suspend with clock disabled to save
power and re-enable them on resume. Make use of the XHCI_SUSPEND_RESUME_CLKS
quirk to do so.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Link: https://lore.kernel.org/r/1660170455-15781-3-git-send-email-justinpopo6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 2687662f26b6..972a44b2a7f1 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -134,7 +134,7 @@ static const struct xhci_plat_priv xhci_plat_renesas_rcar_gen3 = {
 };
 
 static const struct xhci_plat_priv xhci_plat_brcm = {
-	.quirks = XHCI_RESET_ON_RESUME,
+	.quirks = XHCI_RESET_ON_RESUME | XHCI_SUSPEND_RESUME_CLKS,
 };
 
 static const struct of_device_id usb_xhci_of_match[] = {
-- 
2.35.1

