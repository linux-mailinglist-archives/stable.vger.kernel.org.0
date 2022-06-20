Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99BF551A1E
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243854AbiFTNET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244481AbiFTNDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:03:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788331EAE1;
        Mon, 20 Jun 2022 05:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D16661543;
        Mon, 20 Jun 2022 12:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984DC3411C;
        Mon, 20 Jun 2022 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729899;
        bh=9CXotcOEN4LmqbhAxjjPOPUo1jo6/xqjSYmfQc5Ijsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TU8MGXy5KSDhNWdC2eaJok8xWA9ji7Q977kT2ttvjhXy4coRT/f9kQxU5jBt2r6IQ
         H3b9TADl3ylTw1tw3Eaz+8yKlNjpvQFHanU0n+1M77kRH1jOd8x5EutvVeCpYNTVhP
         gUxg5zfOVJIQSKQuYj1IRKPy6thlCMTEnjwRgNCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH 5.18 110/141] usb: dwc3: pci: Restore line lost in merge conflict resolution
Date:   Mon, 20 Jun 2022 14:50:48 +0200
Message-Id: <20220620124732.793486825@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

commit 7ddda2614d62ef7fdef7fd85f5151cdf665b22d8 upstream.

Commit 582ab24e096f ("usb: dwc3: pci: Set "linux,phy_charger_detect"
property on some Bay Trail boards") added a new swnode similar to the
existing ones for boards where the PHY handles charger detection.

Unfortunately, the "linux,sysdev_is_parent" property got lost in the
merge conflict resolution of commit ca9400ef7f67 ("Merge 5.17-rc6 into
usb-next"). Now dwc3_pci_intel_phy_charger_detect_properties is the
only swnode in dwc3-pci that is missing "linux,sysdev_is_parent".

It does not seem to cause any obvious functional issues, but it's
certainly unintended so restore the line to make the properties
consistent again.

Fixes: ca9400ef7f67 ("Merge 5.17-rc6 into usb-next")
Cc: stable@vger.kernel.org
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20220528170913.9240-1-stephan@gerhold.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -127,6 +127,7 @@ static const struct property_entry dwc3_
 	PROPERTY_ENTRY_STRING("dr_mode", "peripheral"),
 	PROPERTY_ENTRY_BOOL("snps,dis_u2_susphy_quirk"),
 	PROPERTY_ENTRY_BOOL("linux,phy_charger_detect"),
+	PROPERTY_ENTRY_BOOL("linux,sysdev_is_parent"),
 	{}
 };
 


