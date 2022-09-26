Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7D5EA169
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbiIZKuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiIZKtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:49:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC9F5809F;
        Mon, 26 Sep 2022 03:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8740E60AD6;
        Mon, 26 Sep 2022 10:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79702C433C1;
        Mon, 26 Sep 2022 10:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188011;
        bh=MzkHCLYvjKv1iQXlxQ3Q59mwqhfyiQVWWuSzgPLRTKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6loO5J9urnczH7W0PnqPqQ4um7jcHt7yDNFyiQZ2ruh2ch0KzGOfRyyuib2r6WV/
         T/KyCtoV52xtw53gRGiKo/6hjkN9ywxJA/gtcB6RnIU7pZXGxeaogYeM+PRiB7S/8q
         HLCtoiI/ysdiCRKHlFESOr7Wd5ul0SS2DE62044M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/141] usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop
Date:   Mon, 26 Sep 2022 12:10:38 +0200
Message-Id: <20220926100755.043153929@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit 040f2dbd2010c43f33ad27249e6dac48456f4d99 ]

Relocate the pullups_connected check until after it is ensured that there
are no runtime PM transitions.  If another context triggered the DWC3
core's runtime resume, it may have already enabled the Run/Stop.  Do not
re-run the entire pullup sequence again, as it may issue a core soft
reset while Run/Stop is already set.

This patch depends on
  commit 69e131d1ac4e ("usb: dwc3: gadget: Prevent repeat pullup()")

Fixes: 77adb8bdf422 ("usb: dwc3: gadget: Allow runtime suspend if UDC unbinded")
Cc: stable <stable@kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220728020647.9377-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 818a70e56d89..41ed2f6f8a8d 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2155,9 +2155,6 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 	is_on = !!is_on;
 
-	if (dwc->pullups_connected == is_on)
-		return 0;
-
 	dwc->softconnect = is_on;
 	/*
 	 * Per databook, when we want to stop the gadget, if a control transfer
@@ -2194,6 +2191,11 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		return 0;
 	}
 
+	if (dwc->pullups_connected == is_on) {
+		pm_runtime_put(dwc->dev);
+		return 0;
+	}
+
 	if (!is_on) {
 		ret = dwc3_gadget_soft_disconnect(dwc);
 	} else {
-- 
2.35.1



