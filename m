Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1689353CEF
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhDEI5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232671AbhDEI52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A6161393;
        Mon,  5 Apr 2021 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613042;
        bh=jkpm1jRPbd6eolbAWaB0SK4IN7tLnQeelbZ+bKD1WK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QR0hULOU+i2j1QebqGU56OOK8ulM2OBYgBu6FsfKifTRIkGHM0jrujLpyFSkfqdNG
         bDLfLXcyP7A3twh3EEcHjtnyTaApt+7LY+/32zkNr2Mn6E3PhwHBtx1QoMy4l34C1l
         GGOdT2SC2gVsy1XPWwtPhILMw9+2XxS6/z9kOFE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.9 30/35] USB: cdc-acm: downgrade message to debug
Date:   Mon,  5 Apr 2021 10:54:05 +0200
Message-Id: <20210405085019.818603234@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
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
@@ -543,7 +543,8 @@ static void acm_port_dtr_rts(struct tty_
 
 	res = acm_set_control(acm, val);
 	if (res && (acm->ctrl_caps & USB_CDC_CAP_LINE))
-		dev_err(&acm->control->dev, "failed to set dtr/rts\n");
+		/* This is broken in too many devices to spam the logs */
+		dev_dbg(&acm->control->dev, "failed to set dtr/rts\n");
 }
 
 static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)


