Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14A14512D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgAVJgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:36:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731659AbgAVJgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:36:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DA92467B;
        Wed, 22 Jan 2020 09:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685772;
        bh=kY1nxN1JPrzaZnbMRspteBjmxUVgqiIfg0WzaphiETY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LhabiJMfayIyaezSTSYt7E4TPpxEbW+UQrT5NuMvsC0Mi4Ga6Ab40IKkRkxIHVdwy
         puMdGMSiB0oaSrv6JBteHiP26Fu3dC7WBUQRxkIS6oMuiasZxtaCh/5wLLGhjjClLm
         PCtkv1tvmL2mhYJDws/m2EFfHTf5HzjE57a2OdNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 73/97] USB: serial: keyspan: handle unbound ports
Date:   Wed, 22 Jan 2020 10:29:17 +0100
Message-Id: <20200122092808.111006459@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 3018dd3fa114b13261e9599ddb5656ef97a1fa17 ]

Check for NULL port data in the control URB completion handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe()).

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/keyspan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 185ef1d8c6cd..e08755e9b612 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -567,6 +567,8 @@ static void	usa49_glocont_callback(struct urb *urb)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
 
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);
@@ -968,6 +970,8 @@ static void usa67_glocont_callback(struct urb *urb)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		p_priv = usb_get_serial_port_data(port);
+		if (!p_priv)
+			continue;
 
 		if (p_priv->resend_cont) {
 			dev_dbg(&port->dev, "%s - sending setup\n", __func__);
-- 
2.20.1



