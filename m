Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796FA37CAD4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhELQcV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241205AbhELQ0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B9C161DDF;
        Wed, 12 May 2021 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834637;
        bh=VK0MFofrzr7YBMuQFMAcpeKWlIPhDfH9DV2Xw1QXqrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPqhNalKezLkcWnb3Gov92c2GUkgILQNWQSkDH1uFldRPYjmfJxfPCLTDxoXotoKt
         wzMr4OpoqymMk/MYhrJgGK6NoxO4CkcsKVKsi5pOVBNdjiJYnQ3kfAGIh4EGHiE6rh
         nzCTFNsOVWVygHhfLsTLwSXPxCowDekFIT3rMlfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 023/677] USB: serial: xr: fix CSIZE handling
Date:   Wed, 12 May 2021 16:41:09 +0200
Message-Id: <20210512144838.001863146@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ea7ada4de2f7406150dd35ecd0302842587a464e upstream.

The XR21V141X does not have a 5- or 6-bit mode, but the current
implementation failed to properly restore the old setting when CS5 or
CS6 was requested. Instead an invalid request would be sent to the
device.

Fixes: c2d405aa86b4 ("USB: serial: add MaxLinear/Exar USB to Serial driver")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org	# 5.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/xr_serial.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/xr_serial.c
+++ b/drivers/usb/serial/xr_serial.c
@@ -468,6 +468,11 @@ static void xr_set_termios(struct tty_st
 		if (old_termios)
 			termios->c_cflag |= old_termios->c_cflag & CSIZE;
 		else
+			termios->c_cflag |= CS8;
+
+		if (C_CSIZE(tty) == CS7)
+			bits |= XR21V141X_UART_DATA_7;
+		else
 			bits |= XR21V141X_UART_DATA_8;
 		break;
 	case CS7:


