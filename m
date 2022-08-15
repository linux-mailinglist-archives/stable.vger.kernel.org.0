Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D359385F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244722AbiHOTVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344631AbiHOTVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:21:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBBE646F;
        Mon, 15 Aug 2022 11:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B55861154;
        Mon, 15 Aug 2022 18:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C5DC433D6;
        Mon, 15 Aug 2022 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588820;
        bh=sk4lIZvVGOueaKj0wAzDD6CxUXQdfitup2cyTbAEu54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2Vd0YFGRN0SGKtGr8UCqXeFlFd05KzdVyLkYvJzMsDpbzSO9vVirmqiDeLL0Src9
         zSIKF15PusoMgaN98/2tp+DiGYNcE4w1+XWRg1vUt1hbBvjPkHH2IRYyOu6jp7OY8l
         MzIRsKcTaH4NOV7jf+6j2rPdLRfSsl2TnI+ObH3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rohith Kollalsi <quic_rkollals@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 493/779] usb: dwc3: core: Do not perform GCTL_CORE_SOFTRESET during bootup
Date:   Mon, 15 Aug 2022 20:02:17 +0200
Message-Id: <20220815180358.345485471@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Rohith Kollalsi <quic_rkollals@quicinc.com>

[ Upstream commit 07903626d98853e605fe63e5ce149f1b7314bbea ]

According to the programming guide, it is recommended to
perform a GCTL_CORE_SOFTRESET only when switching the mode
from device to host or host to device. However, it is found
that during bootup when __dwc3_set_mode() is called for the
first time, GCTL_CORESOFTRESET is done with suspendable bit(BIT 17)
of DWC3_GUSB3PIPECTL set. This some times leads to issues
like controller going into bad state and controller registers
reading value zero. Until GCTL_CORESOFTRESET is done and
run/stop bit is set core initialization is not complete.
Setting suspendable bit of DWC3_GUSB3PIPECTL and then
performing GCTL_CORESOFTRESET is therefore not recommended.
Avoid this by only performing the reset if current_dr_role is set,
that is, when doing subsequent role switching.

Fixes: f88359e1588b ("usb: dwc3: core: Do core softreset when switch mode")
Signed-off-by: Rohith Kollalsi <quic_rkollals@quicinc.com>
Link: https://lore.kernel.org/r/20220714045625.20377-1-quic_rkollals@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 8adb26599797..cfac5503aa66 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -158,9 +158,13 @@ static void __dwc3_set_mode(struct work_struct *work)
 		break;
 	}
 
-	/* For DRD host or device mode only */
-	if ((DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC31, 190A)) &&
-	    dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG) {
+	/*
+	 * When current_dr_role is not set, there's no role switching.
+	 * Only perform GCTL.CoreSoftReset when there's DRD role switching.
+	 */
+	if (dwc->current_dr_role && ((DWC3_IP_IS(DWC3) ||
+			DWC3_VER_IS_PRIOR(DWC31, 190A)) &&
+			dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG)) {
 		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 		reg |= DWC3_GCTL_CORESOFTRESET;
 		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
-- 
2.35.1



