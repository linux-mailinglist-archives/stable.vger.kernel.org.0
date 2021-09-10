Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78412406BB0
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhIJMdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233713AbhIJMdX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DA9C611EE;
        Fri, 10 Sep 2021 12:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277132;
        bh=3UyNhzUiclm1A1daHkGsEO0SLMHNHt/riauCPLOASlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv6D4rqHF4BOL2amgWbOEG8I+fB58kp9v54YOHLD7ie6OD/yrLJB4bML0z+xUocc+
         EX0X2FQDYLqkQuRXHiCSY19aqD02F9H4Sh+mEyUUU1ucpI2Qza5GTbVJeUd9RcPP/V
         ZNDFMMrKL+KyK+XiO/blWPlkbY0aqfDABw0gWRRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.13 15/22] usb: mtu3: restore HS function when set SS/SSP
Date:   Fri, 10 Sep 2021 14:30:14 +0200
Message-Id: <20210910122916.432121640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122915.942645251@linuxfoundation.org>
References: <20210910122915.942645251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit e88f28514065a6c48aadc367efb0ef6378a01543 upstream.

Due to HS function is disabled when set as FS, need restore
it when set as SS/SSP.

Fixes: dc4c1aa7eae9 ("usb: mtu3: add ->udc_set_speed()")
Cc: stable@vger.kernel.org
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1628836253-7432-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mtu3/mtu3_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -227,11 +227,13 @@ void mtu3_set_speed(struct mtu3 *mtu, en
 		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
 		break;
 	case USB_SPEED_SUPER:
+		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
 		mtu3_clrbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
 			     SSUSB_U3_PORT_SSP_SPEED);
 		break;
 	case USB_SPEED_SUPER_PLUS:
-			mtu3_setbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
+		mtu3_setbits(mbase, U3D_POWER_MANAGEMENT, HS_ENABLE);
+		mtu3_setbits(mtu->ippc_base, SSUSB_U3_CTRL(0),
 			     SSUSB_U3_PORT_SSP_SPEED);
 		break;
 	default:


