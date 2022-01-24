Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA1B498D14
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351618AbiAXT1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:27:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53432 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350901AbiAXTZc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:25:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA5A96129A;
        Mon, 24 Jan 2022 19:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0A2C340E5;
        Mon, 24 Jan 2022 19:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052331;
        bh=237rbF9pS7DmapYAq12bvUaL8GTC3vSFTf2z40fMX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhOsn9d+K0dHGio5CuuRniwFy3Su7KpAj/eNl2iwQ8G/aZINzbAbTJyZK8PapQFqL
         lbyc7vltM8J5dr9+bpvwXjnmctGwtQSjlgwB45V+ClVcatsYVX1UXM/rEdMLnbsRrs
         +Pr4uL7Be6mzj7PZDS1186fYfbN58IWVTPDe2FhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 023/320] media: stk1160: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:40:07 +0100
Message-Id: <20220124183954.546983378@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
@@ -65,7 +65,7 @@ int stk1160_read_reg(struct stk1160 *dev
 		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, buf, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), 1000);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
@@ -85,7 +85,7 @@ int stk1160_write_reg(struct stk1160 *de
 
 	ret =  usb_control_msg(dev->udev, pipe, 0x01,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, reg, NULL, 0, HZ);
+			value, reg, NULL, 0, 1000);
 	if (ret < 0) {
 		stk1160_err("write failed on reg 0x%x (%d)\n",
 			reg, ret);


