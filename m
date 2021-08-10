Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EE73E7FFB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhHJRpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235858AbhHJRnx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75FB46101E;
        Tue, 10 Aug 2021 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617157;
        bh=7JPd5TI+quikPazaZthqblTvGHnfh1lhRrFWrqZR3Sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3AipaDcicyn24KJkw8IrI5CtlD5uVHIPbQcH9QfoQNlk0hO/Q+l50o1PGeAN4UrW
         YiK83XykBVP4SCrVKoYzm+tWQ8282sncb6u1S7tmWCCu06gUnoZ/XAAOC4WNgWtl4y
         6r4j/AyTco5pERTFsStDB+wDlleK4eY1vR/ap95A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Devaev <mdevaev@gmail.com>
Subject: [PATCH 5.10 069/135] usb: gadget: f_hid: idle uses the highest byte for duration
Date:   Tue, 10 Aug 2021 19:30:03 +0200
Message-Id: <20210810172958.061635813@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -573,7 +573,7 @@ static int hidg_setup(struct usb_functio
 		  | HID_REQ_SET_IDLE):
 		VDBG(cdev, "set_idle\n");
 		length = 0;
-		hidg->idle = value;
+		hidg->idle = value >> 8;
 		goto respond;
 		break;
 


