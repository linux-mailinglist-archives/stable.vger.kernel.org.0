Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB46659DC01
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353006AbiHWKMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352929AbiHWKJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:09:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD84C7DF69;
        Tue, 23 Aug 2022 01:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D6ABB81C3B;
        Tue, 23 Aug 2022 08:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02C5C433D7;
        Tue, 23 Aug 2022 08:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244945;
        bh=FieQMfNxzXPSEp5kaQfeG0576MsAbAodd6WqEw1eqxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvLWGc129qyQDlCgbrMVufxbAfpNjBdOCqbVwvwvtaDk5QOWW11b9+z0/MOa+t0U+
         CvP+Du8UnPpIxVZX/rmXa4TUgdU3cLvm/SAt2aQUt4wVEqfPm8jkb89XPTt5IldQb5
         12xRJyxjAMhhPMjwm2p7n9Zy3jIBb1hlkQP4gQJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 176/244] usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch
Date:   Tue, 23 Aug 2022 10:25:35 +0200
Message-Id: <20220823080105.159639234@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
index e1cebf581a4a..519bb82b00e8 100644
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



