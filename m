Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6037C51A742
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354814AbiEDRCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354577AbiEDQ6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:58:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D2C18B34;
        Wed,  4 May 2022 09:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC34CB82752;
        Wed,  4 May 2022 16:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632FBC385A4;
        Wed,  4 May 2022 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683031;
        bh=tYbbtFWE1gBnzqfxTsWUCnZsm02ZdWEOGyvLnKVQE5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H54ctx2y5Uek03VWs27OuCHN+rjuQ+nb0F7kIllExRNJGUfyw0L9E7xpuIsw8sOnL
         E06Gp7wzwjKPLAj9s0ZzXjFQwipmlCOswlxUwISuGFo63QsXWumNaJiLLcHIoxxUON
         Lf41N10g9fIAq6mOaU0hDAPTQBW23rnPv2G0SUBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Sven Peter <sven@svenpeter.dev>
Subject: [PATCH 5.10 022/129] usb: dwc3: Try usb-role-switch first in dwc3_drd_init
Date:   Wed,  4 May 2022 18:43:34 +0200
Message-Id: <20220504153023.018906145@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153021.299025455@linuxfoundation.org>
References: <20220504153021.299025455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

commit ab7aa2866d295438dc60522f85c5421c6b4f1507 upstream.

If the PHY controller node has a "port" dwc3 tries to find an
extcon device even when "usb-role-switch" is present. This happens
because dwc3_get_extcon() sees that "port" node and then calls
extcon_find_edev_by_node() which will always return EPROBE_DEFER
in that case.

On the other hand, even if an extcon was present and dwc3_get_extcon()
was successful it would still be ignored in favor of "usb-role-switch".

Let's just first check if "usb-role-switch" is configured in the device
tree and directly use it instead and only try to look for an extcon
device otherwise.

Fixes: 8a0a13799744 ("usb: dwc3: Registering a role switch in the DRD code.")
Cc: stable <stable@kernel.org>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20220411155300.9766-1-sven@svenpeter.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/drd.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -568,16 +568,15 @@ int dwc3_drd_init(struct dwc3 *dwc)
 {
 	int ret, irq;
 
+	if (ROLE_SWITCH &&
+	    device_property_read_bool(dwc->dev, "usb-role-switch"))
+		return dwc3_setup_role_switch(dwc);
+
 	dwc->edev = dwc3_get_extcon(dwc);
 	if (IS_ERR(dwc->edev))
 		return PTR_ERR(dwc->edev);
 
-	if (ROLE_SWITCH &&
-	    device_property_read_bool(dwc->dev, "usb-role-switch")) {
-		ret = dwc3_setup_role_switch(dwc);
-		if (ret < 0)
-			return ret;
-	} else if (dwc->edev) {
+	if (dwc->edev) {
 		dwc->edev_nb.notifier_call = dwc3_drd_notifier;
 		ret = extcon_register_notifier(dwc->edev, EXTCON_USB_HOST,
 					       &dwc->edev_nb);


