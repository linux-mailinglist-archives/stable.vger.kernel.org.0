Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1238C401BFD
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbhIFNA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243408AbhIFM75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD7560F43;
        Mon,  6 Sep 2021 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933133;
        bh=NqlX92/GQHQpSMeOrgCcx4gEgQ4guDEV/v9Zh2d8UaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uE10zbVMfaRix98QfHh9MLhJ1z1siJSNCeethepMVGfdqXnw7mJsITmKEfS2U2dxj
         yhFZzfcTHttNOVZf4s3R5uxNEf0xHT1YyW87l1caQAfsNHADzx4g1USqvuaXQ5oQ4X
         JU6z9FuIGY6JKUlIwyG3gslju8iaescJyL9K5TGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.14 06/14] USB: serial: cp210x: fix flow-control error handling
Date:   Mon,  6 Sep 2021 14:55:52 +0200
Message-Id: <20210906125448.389455058@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit ba4bbdabecd11530dca78dbae3ee7e51ffdc0a06 upstream.

Make sure that the driver crtscts state is not updated in the unlikely
event that the flow-control request fails. Not doing so could break RTS
control.

Fixes: 5951b8508855 ("USB: serial: cp210x: suppress modem-control errors")
Cc: stable@vger.kernel.org	# 5.11
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -1190,6 +1190,7 @@ static void cp210x_set_flow_control(stru
 	struct cp210x_flow_ctl flow_ctl;
 	u32 flow_repl;
 	u32 ctl_hs;
+	bool crtscts;
 	int ret;
 
 	/*
@@ -1249,14 +1250,14 @@ static void cp210x_set_flow_control(stru
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
@@ -1279,8 +1280,12 @@ static void cp210x_set_flow_control(stru
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


