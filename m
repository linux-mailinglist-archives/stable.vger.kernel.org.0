Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9888C3DD91F
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhHBN5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235435AbhHBNzk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7F8D60551;
        Mon,  2 Aug 2021 13:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912448;
        bh=ycYnckxHiwK6o3thCMS/KVwMBi2G5QpfGPS+8aUeJZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOoJRRo7EYuVbOOdK9kcldRhGAeSvp0L2xFtcJLoiuUZ78pdMz9NAM4oKZVGcqIGe
         KacMPMkUBkkjwK3xKJm+zFDQteEIOoeHtbuHc1VYOyHpp2Uu/2DSsGe5fuxpQeZ4eR
         ViDvktXyv8MSRcRq7DCS96j+NLR5OUyXzJWlFeXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 20/67] HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT
Date:   Mon,  2 Aug 2021 15:44:43 +0200
Message-Id: <20210802134339.701461753@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit 6ca2350e11f09d5d3e53777d1eff8ff6d300ed93 upstream.

Commit 670e90924bfe ("HID: wacom: support named keys on older devices")
added support for sending named events from the soft buttons on the
24HDT and 27QHDT. In the process, however, it inadvertantly disabled the
touchscreen of the 24HDT and 27QHDT by default. The
`wacom_set_shared_values` function would normally enable touch by default
but because it checks the state of the non-shared `has_mute_touch_switch`
flag and `wacom_setup_touch_input_capabilities` sets the state of the
/shared/ version, touch ends up being disabled by default.

This patch sets the non-shared flag, letting `wacom_set_shared_values`
take care of copying the value over to the shared version and setting
the default touch state to "on".

Fixes: 670e90924bfe ("HID: wacom: support named keys on older devices")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3829,7 +3829,7 @@ int wacom_setup_touch_input_capabilities
 		    wacom_wac->shared->touch->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
-			wacom_wac->shared->has_mute_touch_switch = true;
+			wacom_wac->has_mute_touch_switch = true;
 		}
 		fallthrough;
 


