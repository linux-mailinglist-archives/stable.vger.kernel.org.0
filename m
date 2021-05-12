Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DFC37CB6F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhELQfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241192AbhELQ0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1FA461DC1;
        Wed, 12 May 2021 15:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834622;
        bh=EZBUdic1ODIUiPSeHv/94AAS5QcaeB+4Ir21GTwETug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBh531PWXvmYvtSESOBxjHSqttjeNWIQCLWEmO9KwYRusQPxBeEh0GrMiIKX8F2U3
         GitoQuFlSp5ZgShf27H/xbXJ5pPnflVTG1inHj738DFuWK6eyb+SD73IAN1D3xOwvH
         dJWQGQUIP9J8Jc5Y/SAJbaSVPW6RH6s93QdhomF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.12 018/677] tty: mxser: fix TIOCSSERIAL permission check
Date:   Wed, 12 May 2021 16:41:04 +0200
Message-Id: <20210512144837.832252365@linuxfoundation.org>
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

commit b91cfb2573aeb5ab426fc3c35bcfe9e0d2a7ecbc upstream.

Changing the port type and closing_wait parameter are privileged
operations so make sure to return -EPERM if a regular user tries to
change them.

Note that the closing_wait parameter would not actually have been
changed but the return value did not indicate that.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-15-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/mxser.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1270,6 +1270,7 @@ static int mxser_set_serial_info(struct
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((ss->baud_base != info->baud_base) ||
 				(close_delay != info->port.close_delay) ||
+				(closing_wait != info->port.closing_wait) ||
 				((ss->flags & ~ASYNC_USR_MASK) != (info->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&port->mutex);
 			return -EPERM;
@@ -1296,11 +1297,11 @@ static int mxser_set_serial_info(struct
 			baud = ss->baud_base / ss->custom_divisor;
 			tty_encode_baud_rate(tty, baud, baud);
 		}
-	}
 
-	info->type = ss->type;
+		info->type = ss->type;
 
-	process_txrx_fifo(info);
+		process_txrx_fifo(info);
+	}
 
 	if (tty_port_initialized(port)) {
 		if (flags != (port->flags & ASYNC_SPD_MASK)) {


