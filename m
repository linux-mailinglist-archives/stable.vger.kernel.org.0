Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05FB59456C
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344099AbiHOWGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348309AbiHOWFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886AC11609A;
        Mon, 15 Aug 2022 12:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6905A611E7;
        Mon, 15 Aug 2022 19:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562F1C433C1;
        Mon, 15 Aug 2022 19:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592249;
        bh=Xq3v93P9JTZdi2AV2EUYbUde+wbxdFFKx2QgvcEJt9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeof42bTN5mZDVAuPuNVLXsSmELPXMmuU3Kq7svhgkp0zf3Iy/yzpK8qsPFmxmGLn
         AtbiNEfrqIsHfJkWpb6u5dDYrZM60D1E9Eg9fyDAIiz6lHVqvgwkrlHR7oz1idrJdM
         mExfYsBPYq5HCT3grqGExJrcOyfKiD4Y2mUFeBDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0756/1095] usb: dwc3: core: Deprecate GCTL.CORESOFTRESET
Date:   Mon, 15 Aug 2022 20:02:35 +0200
Message-Id: <20220815180500.580769281@linuxfoundation.org>
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

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit afbd04e66e5d16ca3c7ea2e3c56eca25558eacf3 ]

Synopsys IP DWC_usb32 and DWC_usb31 version 1.90a and above deprecated
GCTL.CORESOFTRESET. The DRD mode switching flow is updated to remove the
GCTL soft reset. Add version checks to prevent using deprecated setting
in mode switching flow.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/9df529fde6e55f5508321b6bc26e92848044ef2b.1655338967.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index d28cd1a6709b..46a3b8941e40 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -158,7 +158,8 @@ static void __dwc3_set_mode(struct work_struct *work)
 	}
 
 	/* For DRD host or device mode only */
-	if (dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG) {
+	if ((DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC31, 190A)) &&
+	    dwc->desired_dr_role != DWC3_GCTL_PRTCAP_OTG) {
 		reg = dwc3_readl(dwc->regs, DWC3_GCTL);
 		reg |= DWC3_GCTL_CORESOFTRESET;
 		dwc3_writel(dwc->regs, DWC3_GCTL, reg);
-- 
2.35.1



