Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFEE6CC459
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbjC1PEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjC1PEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:04:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EE6EC7D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A24B81D83
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D49C433EF;
        Tue, 28 Mar 2023 15:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015746;
        bh=nmnE+C/7SeTa5kfh1ckVOyQkfPvx48ePwk17onKQgtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSmMs42Y8iLAGFYKnawWjhwl4BmkQ6y3jIMMn4bT+yumiuOMwtmTzfaC+iY1S8NVP
         18T0I62RZb9zYRJRsuH0G0lz0PvSKWxX1pVAJZprdLz3gR2KCTN1n9Xm/UGxSY4sSH
         gM7E9ZvwEwKu5vluLrade9q89Pa+sEcAUQMpuUZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Ziyang Huang <hzyitc@outlook.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>
Subject: [PATCH 6.1 161/224] usb: dwc2: drd: fix inconsistent mode if role-switch-default-mode="host"
Date:   Tue, 28 Mar 2023 16:42:37 +0200
Message-Id: <20230328142624.080520830@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ziyang Huang <hzyitc@outlook.com>

commit 82f5332d3b9872ab5b287e85c57b76d8bb640cd1 upstream.

Some boards might use USB-A female connector for USB ports, however,
the port could be connected to a dual-mode USB controller, making it
also behaves as a peripheral device if male-to-male cable is connected.

In this case, the dts looks like this:

	&usb0 {
		status = "okay";
		dr_mode = "otg";
		usb-role-switch;
		role-switch-default-mode = "host";
	};

After boot, dwc2_ovr_init() sets GOTGCTL to GOTGCTL_AVALOVAL and call
dwc2_force_mode() with parameter host=false, which causes inconsistent
mode - The hardware is in peripheral mode while the kernel status is
in host mode.

What we can do now is to call dwc2_drd_role_sw_set() to switch to
device mode, and everything should work just fine now, even switching
back to none(default) mode afterwards.

Fixes: e14acb876985 ("usb: dwc2: drd: add role-switch-default-node support")
Cc: stable <stable@kernel.org>
Signed-off-by: Ziyang Huang <hzyitc@outlook.com>
Tested-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Acked-by: Minas Harutyunyan <hminas@synopsys.com>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/SG2PR01MB204837BF68EDB0E343D2A375C9A59@SG2PR01MB2048.apcprd01.prod.exchangelabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/drd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -35,7 +35,8 @@ static void dwc2_ovr_init(struct dwc2_hs
 
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 
-	dwc2_force_mode(hsotg, (hsotg->dr_mode == USB_DR_MODE_HOST));
+	dwc2_force_mode(hsotg, (hsotg->dr_mode == USB_DR_MODE_HOST) ||
+				(hsotg->role_sw_default_mode == USB_DR_MODE_HOST));
 }
 
 static int dwc2_ovr_avalid(struct dwc2_hsotg *hsotg, bool valid)


