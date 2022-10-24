Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED0760B2AF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiJXQup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiJXQtQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6465E0703;
        Mon, 24 Oct 2022 08:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E262B819B6;
        Mon, 24 Oct 2022 12:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5C3C433D6;
        Mon, 24 Oct 2022 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616049;
        bh=eeYR1pQLtcJDxO9LFF9+dLExakAoN06GkoHBkN1iWGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8I56jnpgoxwPRXQiqYYLjRBxw+0hMnNfpI0/mooPu4tE8ExBKE3KpginTiU2Flll
         MHvbcqPKIhkxiz4hGxivGteDlIo1vSagmKU5H/Y6WE/L/oParLzQn7BpPc0iC5SkaT
         78JYWX2S21TwP06PoScE9i6jzZ0Z+P4ZvzVdO+aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 481/530] usb: host: xhci-plat: suspend/resume clks for brcm
Date:   Mon, 24 Oct 2022 13:33:45 +0200
Message-Id: <20221024113106.827926990@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



