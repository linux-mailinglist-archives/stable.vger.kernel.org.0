Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFD3E7F18
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhHJRhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232656AbhHJRfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE3660E09;
        Tue, 10 Aug 2021 17:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616915;
        bh=d/+valeJjRb3Dr0/1u1KGw7QRstu5u3fNpILih65bG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6iO2kRHpoKjeqxoxGjdoeUZuNKU9+4B+8LeJItpuwod2nPSIqBhHxfiEhJ4PjRtB
         NBUSVLBAnYocEAxfKL+6s00/ojRFdKjbobQFeSfxsghFp/ekuv1vw/ehdNzrJnDi3g
         bNBFu9oLehipP0+kRliNGiDLdr8aWUTfBT7fijr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Devaev <mdevaev@gmail.com>
Subject: [PATCH 5.4 47/85] usb: gadget: f_hid: idle uses the highest byte for duration
Date:   Tue, 10 Aug 2021 19:30:20 +0200
Message-Id: <20210810172949.825274932@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
@@ -579,7 +579,7 @@ static int hidg_setup(struct usb_functio
 		  | HID_REQ_SET_IDLE):
 		VDBG(cdev, "set_idle\n");
 		length = 0;
-		hidg->idle = value;
+		hidg->idle = value >> 8;
 		goto respond;
 		break;
 


