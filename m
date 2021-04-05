Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AEF353D69
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhDEI7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234188AbhDEI7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11D13610E8;
        Mon,  5 Apr 2021 08:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613175;
        bh=M2E5XEh3GnqziyHsM8riwrpelAwbh49FkbgoKVacE0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JC+n05u5ERhp9vqp1Bg8CZdANGLX4POBi4T6Zw8xShUV5ngPaCS4Cl9TG7DnHEmR3
         KHccH8/X4ZVyMLCnoao/hZmWUGjaHdzEpbmMFocdGNieZFoeZVXDjKYqLgrKUjo6gX
         giyqzWHAWUPpHeiXKRNZumNtVlpuZHNUfB13GRbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 47/52] USB: cdc-acm: downgrade message to debug
Date:   Mon,  5 Apr 2021 10:54:13 +0200
Message-Id: <20210405085023.514338455@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit e4c77070ad45fc940af1d7fb1e637c349e848951 upstream.

This failure is so common that logging an error here amounts
to spamming log files.

Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311130126.15972-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -676,7 +676,8 @@ static void acm_port_dtr_rts(struct tty_
 
 	res = acm_set_control(acm, val);
 	if (res && (acm->ctrl_caps & USB_CDC_CAP_LINE))
-		dev_err(&acm->control->dev, "failed to set dtr/rts\n");
+		/* This is broken in too many devices to spam the logs */
+		dev_dbg(&acm->control->dev, "failed to set dtr/rts\n");
 }
 
 static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)


