Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28513EB85B
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241979AbhHMPNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242029AbhHMPMM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DA4610FF;
        Fri, 13 Aug 2021 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867505;
        bh=xWLck34ubnToho/WAusHO8nnnECUAcIWBVtlkxNrB2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0h1WFRcQGXtlXM40/OrrcCv+lUcg/0gjL6B6u4S+SBpErMP2ErkBOhZrv7r39bWsi
         VuiFLIB6LRHuaxSEGWBHiF1XrImDOOqBEDmo7/ztOFA2g5Yf0V9RmNA9pzZhI9khec
         mtFzJ5/tdNmxmUbvl0CLHkQ7mpp//xrjQuQcwQfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Devaev <mdevaev@gmail.com>
Subject: [PATCH 4.14 21/42] usb: gadget: f_hid: idle uses the highest byte for duration
Date:   Fri, 13 Aug 2021 17:06:47 +0200
Message-Id: <20210813150525.811197546@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Devaev <mdevaev@gmail.com>

commit fa20bada3f934e3b3e4af4c77e5b518cd5a282e5 upstream.

SET_IDLE value must be shifted 8 bits to the right to get duration.
This confirmed by USBCV test.

Fixes: afcff6dc690e ("usb: gadget: f_hid: added GET_IDLE and SET_IDLE handlers")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Maxim Devaev <mdevaev@gmail.com>
Link: https://lore.kernel.org/r/20210727185800.43796-1-mdevaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -583,7 +583,7 @@ static int hidg_setup(struct usb_functio
 		  | HID_REQ_SET_IDLE):
 		VDBG(cdev, "set_idle\n");
 		length = 0;
-		hidg->idle = value;
+		hidg->idle = value >> 8;
 		goto respond;
 		break;
 


