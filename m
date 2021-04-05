Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57EE354063
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbhDEJRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239717AbhDEJRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:17:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B61BE613B3;
        Mon,  5 Apr 2021 09:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614245;
        bh=HpnAhgzZCOA6IMX6Z22MbDgI/Ts+cQ2D3fEGu+/PpGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lmc7tUG+Xs7YFh33Ju0IAWQaxXVCUvClSsN3jmolgSCQFg5Tp2EWwkmnOO2CDp5AV
         m7rVUEK5ReX711k6SAn5hFJCVp1Q8Su/xTNRPz4hPGvh4EXv0nb7B61edBWESJ2/wi
         aLm6tUC/4gQlx2LK974k768F2X9GtfLyyrCHpR0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruno Thomsen <bruno.thomsen@gmail.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.11 136/152] USB: cdc-acm: downgrade message to debug
Date:   Mon,  5 Apr 2021 10:54:45 +0200
Message-Id: <20210405085038.640609576@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
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
@@ -659,7 +659,8 @@ static void acm_port_dtr_rts(struct tty_
 
 	res = acm_set_control(acm, val);
 	if (res && (acm->ctrl_caps & USB_CDC_CAP_LINE))
-		dev_err(&acm->control->dev, "failed to set dtr/rts\n");
+		/* This is broken in too many devices to spam the logs */
+		dev_dbg(&acm->control->dev, "failed to set dtr/rts\n");
 }
 
 static int acm_port_activate(struct tty_port *port, struct tty_struct *tty)


