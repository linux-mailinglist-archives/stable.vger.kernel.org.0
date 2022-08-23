Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0050559E350
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240769AbiHWMSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359668AbiHWMQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:16:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D76EA301;
        Tue, 23 Aug 2022 02:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AAA1B81C89;
        Tue, 23 Aug 2022 09:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867FAC433D6;
        Tue, 23 Aug 2022 09:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247674;
        bh=s13R4a8PeApI8DNa3FJYBlL7I+6m6pE3xwfI2dqz9Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcBDLlYj7Lxww1kT8kApftP/jbzzkUtts/K2PwFE4Lf/D6N14DgeiXGg1ka7oPmCr
         slqv4glhEf+y621qIL6TArNNegqSBi8eMAAOsa655jGdwPOpjWJemrbYo6uTwluKkv
         UQAhjUsf+eKwIwU1LwbjpKPyp9AL8ZZDvL/XBv2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minas Harutyunyan <hminas@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/158] usb: dwc2: gadget: remove D+ pull-up while no vbus with usb-role-switch
Date:   Tue, 23 Aug 2022 10:27:23 +0200
Message-Id: <20220823080050.435999238@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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
index 64485f82dc5b..da0df69cc234 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3593,7 +3593,8 @@ void dwc2_hsotg_core_disconnect(struct dwc2_hsotg *hsotg)
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



