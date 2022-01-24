Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8A24998A6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449460AbiAXV2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449769AbiAXVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74E7C067A40;
        Mon, 24 Jan 2022 12:12:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E42B8122C;
        Mon, 24 Jan 2022 20:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ED9C340E5;
        Mon, 24 Jan 2022 20:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055129;
        bh=237rbF9pS7DmapYAq12bvUaL8GTC3vSFTf2z40fMX3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ro1j3G1Uy8lLFqAHH8Ld4VOwnLc4W1hMPj5jEEII5HAPP41+d3gB/ywtumH9Qwpbl
         rzPVNV8urWB5cUEd/Ffh34JRIvWI/M3dI2Yrru5iMZ/SOhR4G1TGCGlUgkpJpAE1Ai
         04IuBDfsiC7I/zKkgWQ5EpBfoFVT4dKmjOoJnGX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 051/846] media: stk1160: fix control-message timeouts
Date:   Mon, 24 Jan 2022 19:32:48 +0100
Message-Id: <20220124184102.713105020@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


