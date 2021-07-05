Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AA03BB8E8
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 10:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhGEIXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 04:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230293AbhGEIXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 04:23:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D36AA6128B;
        Mon,  5 Jul 2021 08:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625473240;
        bh=mCeASRcy2as2LCxAx/EwFqOXzJ0xOLOo4eReNRoA3fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIXLCtVohk9YXxTcnQ9aS6Rlc0uu/6rejc9Qlyz8UHxM+eHqBuoZwP0KdiIRPTtv9
         ocz3Z9ckd16zl2ReRRkH5PZhgB1ZX3i5q8kc4dqAxddY9qdygMAUJW25A3PU+Q7QTa
         A6WHNBc8DzXBeEZL3MZq88MBfQQs7fRsh/3RJkN1o3sAxMX6TQzcbJxPnejohhjydr
         NcOYxIQUmz9YGSMIfzKKUymxfWFuEOqW4oAwc7W/WZaaSwgHXuwRyFEYh6vegRQFJZ
         Odp5DA7bExOOBUrscN4VLu48XmzynfP9SRRLeLDV8qpDjqfMDdkxp8HZ8IFqKAiTAZ
         0PrVvJRPVsD+g==
Received: from johan by xi with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1m0JqF-0004lr-6z; Mon, 05 Jul 2021 10:20:35 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2 2/6] USB: serial: cp210x: fix flow-control error handling
Date:   Mon,  5 Jul 2021 10:20:11 +0200
Message-Id: <20210705082015.18286-3-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210705082015.18286-1-johan@kernel.org>
References: <20210705082015.18286-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure that the driver crtscts state is not updated in the unlikely
event that the flow-control request fails. Not doing so could break RTS
control.

Fixes: 5951b8508855 ("USB: serial: cp210x: suppress modem-control errors")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cp210x.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index fd198031de71..fd6bd574e2a5 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1189,6 +1189,7 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 	struct cp210x_flow_ctl flow_ctl;
 	u32 flow_repl;
 	u32 ctl_hs;
+	bool crtscts;
 	int ret;
 
 	/*
@@ -1248,14 +1249,14 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 			flow_repl |= CP210X_SERIAL_RTS_FLOW_CTL;
 		else
 			flow_repl |= CP210X_SERIAL_RTS_INACTIVE;
-		port_priv->crtscts = true;
+		crtscts = true;
 	} else {
 		ctl_hs &= ~CP210X_SERIAL_CTS_HANDSHAKE;
 		if (port_priv->rts)
 			flow_repl |= CP210X_SERIAL_RTS_ACTIVE;
 		else
 			flow_repl |= CP210X_SERIAL_RTS_INACTIVE;
-		port_priv->crtscts = false;
+		crtscts = false;
 	}
 
 	if (I_IXOFF(tty)) {
@@ -1278,8 +1279,12 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 	flow_ctl.ulControlHandshake = cpu_to_le32(ctl_hs);
 	flow_ctl.ulFlowReplace = cpu_to_le32(flow_repl);
 
-	cp210x_write_reg_block(port, CP210X_SET_FLOW, &flow_ctl,
+	ret = cp210x_write_reg_block(port, CP210X_SET_FLOW, &flow_ctl,
 			sizeof(flow_ctl));
+	if (ret)
+		goto out_unlock;
+
+	port_priv->crtscts = crtscts;
 out_unlock:
 	mutex_unlock(&port_priv->mutex);
 }
-- 
2.31.1

