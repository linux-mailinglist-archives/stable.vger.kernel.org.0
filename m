Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE746592166
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbiHNPgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240922AbiHNPfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE811659E;
        Sun, 14 Aug 2022 08:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0370160C41;
        Sun, 14 Aug 2022 15:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F49C433D6;
        Sun, 14 Aug 2022 15:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491076;
        bh=j2KoHzmv7mNAD0mAEpA0x+P63+btGz4TXSLAu6PoG78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Epyb+j3scWUAzPzg1Zkcz42FkXupnNA2jU7v7AQ/Ne0CZGcvkwfh+4Wd6iccrJ4Kg
         C8UvcSXZuCavSK/Ea5IG8BHFXxEBpdPedsAkkTTpusWTUZErEGMP9hTGLE7U0ZugtT
         Tmxmi2Lw9NCtHkJ5b8tMlffAFTRK4If4TJLnqflrDxOkiroCffiYBxGNTSQqiODjbX
         wweOWhlk8VL/uS0k5p7e2mqZhzhaqT2SH5OkjcqWA8zRAeV8pJ1tKq138f2RdUPJEr
         BHURNyAHkaAvoCUsBbnDl+EE+mn5+Am85kdTwBOjcAGeK4BUFIN/dT16WT1A7FvEtJ
         4/VKUuUJmZiGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 19/56] usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch
Date:   Sun, 14 Aug 2022 11:29:49 -0400
Message-Id: <20220814153026.2377377-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit db638c6500abaffb8f7770b2a69c40d003d54ae1 ]

When using usb-role-switch, D+ pull-up is set as soon as DTCL_SFTDISCON is
cleared, whatever the vbus valid signal state is. The pull-up should not
be set when vbus isn't present (this is determined by the drd controller).

This patch ensures that B-Session (so Peripheral role + vbus valid signal)
is valid before clearing the DCTL_SFTDISCON bit when role switch is used.
Keep original behavior when usb-role-switch isn't used.

Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20220622160717.314580-1-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/gadget.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index fe2a58c75861..8b15742d9e8a 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3594,7 +3594,8 @@ void dwc2_hsotg_core_disconnect(struct dwc2_hsotg *hsotg)
 void dwc2_hsotg_core_connect(struct dwc2_hsotg *hsotg)
 {
 	/* remove the soft-disconnect and let's go */
-	dwc2_clear_bit(hsotg, DCTL, DCTL_SFTDISCON);
+	if (!hsotg->role_sw || (dwc2_readl(hsotg, GOTGCTL) & GOTGCTL_BSESVLD))
+		dwc2_clear_bit(hsotg, DCTL, DCTL_SFTDISCON);
 }
 
 /**
-- 
2.35.1

