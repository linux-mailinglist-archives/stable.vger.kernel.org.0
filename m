Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF064F3A59
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244746AbiDELof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354622AbiDEKO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3509A6BDC6;
        Tue,  5 Apr 2022 03:01:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C69D4B81C83;
        Tue,  5 Apr 2022 10:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2594CC385A1;
        Tue,  5 Apr 2022 10:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152891;
        bh=ScwmD875nfYCsSx5Q9hrMEVZYdEQUwoF7X66WEA/Ibk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gpi9csjRb+ncSjGxf500Dmi4ClIkBE8cF/7+wV22r+lF1bVqyPnEkvIrNDveTDb+3
         WBcf0RmuOsPwFQuv1nRfwAj9CA2ayah9G0Tax5o09U3N7j4UXm82zt3bcvodOvbPlt
         hVR/hPUtYKNScXWoSeNBi3JsP/BUK7yS307rZsyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 026/599] xhci: fix garbage USBSTS being logged in some cases
Date:   Tue,  5 Apr 2022 09:25:20 +0200
Message-Id: <20220405070259.597723405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 3105bc977d7cbf2edc35e24cc7e009686f6e4a56 upstream.

xhci_decode_usbsts() is expected to return a zero-terminated string by
its only caller, xhci_stop_endpoint_command_watchdog(), which directly
logs the return value:

  xhci_warn(xhci, "USBSTS:%s\n", xhci_decode_usbsts(str, usbsts));

However, if no recognized bits are set in usbsts, the function will
return without having called any sprintf() and therefore return an
untouched non-zero-terminated caller-provided buffer, causing garbage
to be output to log.

Fix that by always including the raw value in the output.

Note that before commit 4843b4b5ec64 ("xhci: fix even more unsafe memory
usage in xhci tracing") the result effect in the failure case was different
as a static buffer was used here, but the code still worked incorrectly.

Fixes: 9c1aa36efdae ("xhci: Show host status when watchdog triggers and host is assumed dead.")
Cc: stable@vger.kernel.org
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220303110903.1662404-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -2612,8 +2612,11 @@ static inline const char *xhci_decode_us
 {
 	int ret = 0;
 
+	ret = sprintf(str, " 0x%08x", usbsts);
+
 	if (usbsts == ~(u32)0)
-		return " 0xffffffff";
+		return str;
+
 	if (usbsts & STS_HALT)
 		ret += sprintf(str + ret, " HCHalted");
 	if (usbsts & STS_FATAL)


