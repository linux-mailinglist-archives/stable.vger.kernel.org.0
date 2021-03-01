Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA44328938
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhCARwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238572AbhCARqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:46:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74DF4650DD;
        Mon,  1 Mar 2021 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617937;
        bh=A/xLtAbml7+7AdWvXvXgY6S0HKkVMjf/GFMkeT7FYJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfGWzQwfWDbanNk6Bg6g9YmNTnGxJyg5SDHGcGUs6HL6GU7fV+SrF5l5Xj+oaG+Xv
         6Tv/qBbdcFhq6ezGPz4KRFqeRYLyaMFX10yjWi8Fk/Fb3zpaelpgKFh8e9zvtBcWC0
         oPeI5nyjtT8lYb7VzZPUZncef4k3BzXCiDVLlX70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir <svv75@mail.ru>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 249/340] USB: serial: ftdi_sio: fix FTX sub-integer prescaler
Date:   Mon,  1 Mar 2021 17:13:13 +0100
Message-Id: <20210301161100.548153350@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 528222d0c8ce93e435a95cd1e476b60409dd5381 upstream.

The most-significant bit of the sub-integer-prescaler index is set in
the high byte of the baudrate request wIndex also for FTX devices.

This fixes rates like 1152000 which got mapped to 1.2 MBd.

Reported-by: Vladimir <svv75@mail.ru>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=210351
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1386,8 +1386,9 @@ static int change_speed(struct tty_struc
 	index_value = get_ftdi_divisor(tty, port);
 	value = (u16)index_value;
 	index = (u16)(index_value >> 16);
-	if ((priv->chip_type == FT2232C) || (priv->chip_type == FT2232H) ||
-		(priv->chip_type == FT4232H) || (priv->chip_type == FT232H)) {
+	if (priv->chip_type == FT2232C || priv->chip_type == FT2232H ||
+			priv->chip_type == FT4232H || priv->chip_type == FT232H ||
+			priv->chip_type == FTX) {
 		/* Probably the BM type needs the MSB of the encoded fractional
 		 * divider also moved like for the chips above. Any infos? */
 		index = (u16)((index << 8) | priv->interface);


