Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE54C3BA16A
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 15:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhGBNpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 09:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232715AbhGBNp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Jul 2021 09:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9568D61440;
        Fri,  2 Jul 2021 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625233376;
        bh=O2JgpgSzI1fK5NYzIru4yBvKZ6mUJEW0O262pd1WwYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTIiCwCyL3ELZzd2S5qLC9HwdtSqgU5rQfAHOPoYG0Jdn6Cr8/i5pFePOemmbjt5n
         eoYha9t5Zk19wzMyxH81oLlLDjyKQNe4TW6wYPyD4j/fl5r3jjYGvG0k8rhiZ3Csiw
         ExP8LHakS3Q6IRqHxDSzDnlBNtFQjzKnkK583LipZ95vEjlUc04yKR/qXk96h88P4a
         omPz8i9cgo30+BjT6Lj0gTRbcHpjtWODg6Db/bESkAHcL5GREfQ9NtIM75bs25Wfzm
         WaX8wlsWVdsSC9T1jSCZquPYOjNgU+nkLQiTFxsD/aJnTO4fDk/TqCaoNiDEzPJc2Y
         Z+J6IU5RRJQhg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lzJRT-0006Q4-2s; Fri, 02 Jul 2021 15:42:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/6] USB: serial: cp210x: fix flow-control error handling
Date:   Fri,  2 Jul 2021 15:42:23 +0200
Message-Id: <20210702134227.24621-3-johan@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702134227.24621-1-johan@kernel.org>
References: <20210702134227.24621-1-johan@kernel.org>
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
index b41e2c7649fb..eb3be4f65603 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1191,6 +1191,7 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
 	struct cp210x_flow_ctl flow_ctl;
 	u32 flow_repl;
 	u32 ctl_hs;
+	bool crtscts;
 	int ret;
 
 	/*
@@ -1246,14 +1247,14 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
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
@@ -1276,8 +1277,12 @@ static void cp210x_set_flow_control(struct tty_struct *tty,
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

