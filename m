Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7836CC342
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjC1Owf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjC1OwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33DCC656
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82AA0B81D6F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AB6C433D2;
        Tue, 28 Mar 2023 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015124;
        bh=nmnE+C/7SeTa5kfh1ckVOyQkfPvx48ePwk17onKQgtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wabEfsK0La8o1xJF5BVDoktud6K76LP78ZRmXAr0Gx3tJgTaSk3wnL/1wGA1iTQsB
         mcAAN+y6L6zSgXUzWcexK8tzWzc5uUcSlQ5gLnnscF27afECE7233SwKSjwzS3C6dV
         hcDWPI1tl22bVJP8zLROosd6bNwqePfnXCEH2NFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable <stable@kernel.org>,
        Ziyang Huang <hzyitc@outlook.com>,
        Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
        Minas Harutyunyan <hminas@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>
Subject: [PATCH 6.2 175/240] usb: dwc2: drd: fix inconsistent mode if role-switch-default-mode="host"
Date:   Tue, 28 Mar 2023 16:42:18 +0200
Message-Id: <20230328142626.926018449@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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


