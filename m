Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C5E406B75
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbhIJMcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233166AbhIJMcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2368B611CA;
        Fri, 10 Sep 2021 12:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277060;
        bh=VTTJOM2FyXZVychL+yuCUxJWD2N265UEcHTQCbeTkHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvSNvC82Jtone8+oHJ5yWuh+7LjhaADJvd+63slLu2CRwyz7qlDCtCbrMz3WMsYao
         7u5DPkxCcx9sQ4U4yaJKu3k5a8QHjTRcXc46CfnJ9pimdti2I5hnLjypaEFHgySX2O
         I6bijK3yh4KbaT/Hm4AqKl1WJMk5RzMv2lDzV4+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH 5.14 12/23] usb: mtu3: restore HS function when set SS/SSP
Date:   Fri, 10 Sep 2021 14:30:02 +0200
Message-Id: <20210910122916.403456979@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
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
@@ -227,11 +227,13 @@ static void mtu3_set_speed(struct mtu3 *
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


