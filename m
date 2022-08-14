Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B399D5921CA
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbiHNPmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241602AbiHNPl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178B42317F;
        Sun, 14 Aug 2022 08:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C5DC60C8C;
        Sun, 14 Aug 2022 15:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30153C433B5;
        Sun, 14 Aug 2022 15:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491201;
        bh=FieQMfNxzXPSEp5kaQfeG0576MsAbAodd6WqEw1eqxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jU1Dog+IUkc5CpmkvtG7dyso6HbeuNcqnVaaqLTfzpbE7NPegdncUOKRqA9vI5SC1
         9+UV5cLXApzd241YPaEtujM8mDqcq/CuzqEMDP5g3V5TATqQ9rdFrDSX9MRlRgjLig
         Ee2LhXjJc4R5lT4Ljf5JkHrcBRf/VAQE8EWzjoZooJc/MiOD7xdNiyk30/2Qs8W9qp
         c7KDIuDAz4uWxad/Mgorm7rtcMfuLV3UkY5AiuVJKjHWWnGZTGqdA6yl2GeClmj9yu
         aepc1aarwtpMBVGGkg5AD5h/o0+RdKc1g1wSH2ziPNDIWoyyENcdJtoHYHvACYZ2AZ
         O3wz9lDCnenwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/46] usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch
Date:   Sun, 14 Aug 2022 11:32:16 -0400
Message-Id: <20220814153247.2378312-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153247.2378312-1-sashal@kernel.org>
References: <20220814153247.2378312-1-sashal@kernel.org>
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

