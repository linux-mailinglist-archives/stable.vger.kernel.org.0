Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED75EA2BC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234409AbiIZLOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiIZLNr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:13:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3540561DAC;
        Mon, 26 Sep 2022 03:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C03860C79;
        Mon, 26 Sep 2022 10:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A5DC433D6;
        Mon, 26 Sep 2022 10:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188473;
        bh=zmOjWxkhM1V1ZrODRFUduVy3DgEmiPDGvKEwK9BkK+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYKlUaWAFXoj7PACF+3Vk7jsrCzfqpMUuV9fUJrJHVsg5G/rojVUgbtud5I1E+5Bg
         Em3yc/jvMGpHA/BrQyc8Uodt0ZXqbeJMAwd/OjMkVeCq8D/mh9KIwNEjvp7WYrvNX8
         dWfgXLAuj1wutYWcLc4Yzpr43M8Zzh4maJ+XT2LI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/148] usb: dwc3: gadget: Prevent repeat pullup()
Date:   Mon, 26 Sep 2022 12:10:41 +0200
Message-Id: <20220926100756.315444893@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 69e131d1ac4e52a59ec181ab4f8aa8c48cd8fb64 ]

Don't do soft-disconnect if it's previously done. Likewise, don't do
soft-connect if the device is currently connected and running. It would
break normal operation.

Currently the caller of pullup() (udc's sysfs soft_connect) only checks
if it had initiated disconnect to prevent repeating soft-disconnect. It
doesn't check for soft-connect. To be safe, let's keep the check here
regardless whether the udc core is fixed.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1c1345bd66c97a9d32f77d63aaadd04b7b037143.1650593829.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 040f2dbd2010 ("usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 761065336322..61499b657129 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2442,6 +2442,10 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 	int			ret;
 
 	is_on = !!is_on;
+
+	if (dwc->pullups_connected == is_on)
+		return 0;
+
 	dwc->softconnect = is_on;
 	/*
 	 * Per databook, when we want to stop the gadget, if a control transfer
-- 
2.35.1



