Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9459465A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbiHOWGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348654AbiHOWGF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:06:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80478116EEF;
        Mon, 15 Aug 2022 12:37:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A44A8B80EAB;
        Mon, 15 Aug 2022 19:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58DAC433D6;
        Mon, 15 Aug 2022 19:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592259;
        bh=GhUnTEMiB/95ekdv6mXv9gqAcCtVgrLB9cNCLk8LCWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLIHClLQ23WQfOZDG+TT1SAoCW4MbGN8lzzqheN7yvynKXK5UhU8dY7LIspqdH+8P
         nzk6U/wv9uzX9WXXd2EZ0QSQmHFMwZFGS3HCgK1ynBk8LVMNUa/Ps5QQKocdVU490g
         X9C9ihdvUsbie4ZdpzJ8AnKs6MHIip17sTjIRN+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rohith Kollalsi <quic_rkollals@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0757/1095] usb: dwc3: core: Do not perform GCTL_CORE_SOFTRESET during bootup
Date:   Mon, 15 Aug 2022 20:02:36 +0200
Message-Id: <20220815180500.610840846@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 46a3b8941e40..ecec9cdfa0a6 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -157,9 +157,13 @@ static void __dwc3_set_mode(struct work_struct *work)
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



