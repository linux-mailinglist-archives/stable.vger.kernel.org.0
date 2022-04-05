Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDCA4F3377
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbiDEK25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbiDEJci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36CCE00;
        Tue,  5 Apr 2022 02:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44ABFCE1B55;
        Tue,  5 Apr 2022 09:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5918BC385A4;
        Tue,  5 Apr 2022 09:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150373;
        bh=8mb2t1vcLixCqqs5leqyvJaYwmzvz3X3Dz9GErrHCoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od7Ck3llL80cSNN5YU24kVhmZ4UeiO1AuYbbEe4ce16Yw6fg9mayMHaP0h6S0afSr
         vhWgZVUpaz8gcCAZABgmwkwx1wFjFhsIekzg5F/5FXidfj4p3kFYoqALvNI3vWsjjD
         +TGt7xHql5nzT+Hn4GxOYf9b5NS0ibPMcwc2k77s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 033/913] xhci: fix garbage USBSTS being logged in some cases
Date:   Tue,  5 Apr 2022 09:18:15 +0200
Message-Id: <20220405070340.809378946@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -2624,8 +2624,11 @@ static inline const char *xhci_decode_us
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


