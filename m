Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32905608A49
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiJVIuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234904AbiJVItH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:49:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30A4119BE6;
        Sat, 22 Oct 2022 01:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9085F60B4D;
        Sat, 22 Oct 2022 08:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A85C433D6;
        Sat, 22 Oct 2022 08:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426000;
        bh=1TJHyyfg+QsA6U78R8mxqIahZXicXXqn1XHvFq8xnAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfulSeMFg3DtIv+nxC1WLrYy+yryeeq3DmFvenguGCpLD4uFobCm9t3NSt1jdUjzO
         bQK3+T43YsJWb/Y/1EZArWPysF41/Fz9mKa/RViME/dhJ0RkLWZWPLkLiHfTuv+h1F
         xyV2TnUuWFQTZxKdgsuxwpB5XXlClf1g+J/kW7Hs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 656/717] usb: host: xhci-plat: suspend/resume clks for brcm
Date:   Sat, 22 Oct 2022 09:28:55 +0200
Message-Id: <20221022072527.415643934@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index ef10982ad482..5fb55bf19493 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -123,7 +123,7 @@ static const struct xhci_plat_priv xhci_plat_renesas_rcar_gen3 = {
 };
 
 static const struct xhci_plat_priv xhci_plat_brcm = {
-	.quirks = XHCI_RESET_ON_RESUME,
+	.quirks = XHCI_RESET_ON_RESUME | XHCI_SUSPEND_RESUME_CLKS,
 };
 
 static const struct of_device_id usb_xhci_of_match[] = {
-- 
2.35.1



