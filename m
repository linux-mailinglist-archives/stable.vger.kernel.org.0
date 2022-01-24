Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525C8498BF0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243085AbiAXTRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41504 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345749AbiAXTPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:15:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 598C9612FC;
        Mon, 24 Jan 2022 19:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C495C340E5;
        Mon, 24 Jan 2022 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051738;
        bh=APWsZhwa5pVHhTAULT9fAjfDNrVdk3v3541Ngoypbog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BWJlBjnP0nEHh2xgmzA+Yy9SPKBGYn+dE3szEc2zl+RQgQfPuRQ5uage/z9wt4c+L
         jVE7rFCB6nZ+xxujvAv15VZELMAYjaEHYhbXWxJpXScKnqvw8Ki+n7sKdJn9gfYUSG
         HYW9ek7bH2f7lv4+cchsfMxZ6SfEG8qWrrlOVKcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 039/239] media: stk1160: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:41:17 +0100
Message-Id: <20220124183944.384759003@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 6aa6e70cdb5b863a57bad61310bf89b6617a5d2d upstream.

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 9cb2173e6ea8 ("[media] media: Add stk1160 new driver (easycap replacement)")
Cc: stable@vger.kernel.org      # 3.7
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/stk1160/stk1160-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -75,7 +75,7 @@ int stk1160_read_reg(struct stk1160 *dev
 		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, buf, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), 1000);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
@@ -95,7 +95,7 @@ int stk1160_write_reg(struct stk1160 *de
 
 	ret =  usb_control_msg(dev->udev, pipe, 0x01,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, reg, NULL, 0, HZ);
+			value, reg, NULL, 0, 1000);
 	if (ret < 0) {
 		stk1160_err("write failed on reg 0x%x (%d)\n",
 			reg, ret);


