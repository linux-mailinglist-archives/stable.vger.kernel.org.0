Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 602B21406E7
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgAQJvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:51:10 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41491 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgAQJvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:51:08 -0500
Received: by mail-lf1-f66.google.com with SMTP id m30so17830279lfp.8;
        Fri, 17 Jan 2020 01:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H3I1kDXP2xB9zKvHqrsjSq/pe+FbsHs1Q5j6rerVmVA=;
        b=OffkbDWbSuQGyoztGrnUYfn/O5J/0JBqbc5mlXPFfEkpg4K1Z5/TLo3vNonW4l3bmj
         s2exYesIYlpBSzWw++PDqBbdAaYa8AFHaPQn22ZvwzfDJNpxMB/6aZPdWx/GIskdhPyA
         H/dfN7ls0AWpw/Eu/mmtQoyKXTdjtT0d2NxPuzFGCygmxPeQ4Y3yIIzX9SkaS03vOmVj
         v0sJlMH4rnfnsTmqD3ExcPWLjA+1e0zjXIgc4WIXYFknDTI+7ZIMPHggDY0XcFTLP0KT
         abuIcuTP3c7Hapye649LUDWzZiAOUEEqKRJWNcd7isvoIyx57s5BszBzunO833UfpbG+
         OTGg==
X-Gm-Message-State: APjAAAXc7kmwDGAqF3J4OdHiMRLSRl0VwAx5hz4JYznimgh0Rwj8PBUH
        p+/rTot2nTdLF8RoH7HGrOQ=
X-Google-Smtp-Source: APXvYqzL1YqNykHjbGyNujGD35RjAUICgs4j8lRqbv5BUNv2V26CbH2oXR9EhhhRCF/a7y6AMSnYYQ==
X-Received: by 2002:a19:5057:: with SMTP id z23mr4886317lfj.132.1579254666248;
        Fri, 17 Jan 2020 01:51:06 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id h19sm12075512ljl.57.2020.01.17.01.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:51:04 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1isOHQ-0007DI-C8; Fri, 17 Jan 2020 10:51:04 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 2/5] USB: serial: io_edgeport: handle unbound ports on URB completion
Date:   Fri, 17 Jan 2020 10:50:23 +0100
Message-Id: <20200117095026.27655-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117095026.27655-1-johan@kernel.org>
References: <20200117095026.27655-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check for NULL port data in the shared interrupt and bulk completion
callbacks to avoid dereferencing a NULL pointer in case a device sends
data for a port device which isn't bound to a driver (e.g. due to a
malicious device having unexpected endpoints or after an allocation
failure on port probe).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/io_edgeport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 9690a5f4b9d6..0582d78bdb1d 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -716,7 +716,7 @@ static void edge_interrupt_callback(struct urb *urb)
 			if (txCredits) {
 				port = edge_serial->serial->port[portNumber];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					spin_lock_irqsave(&edge_port->ep_lock,
 							  flags);
 					edge_port->txCredits += txCredits;
@@ -1825,7 +1825,7 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 				port = edge_serial->serial->port[
 							edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
-				if (edge_port->open) {
+				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
 						__func__, rxLen,
 						edge_serial->rxPort);
-- 
2.24.1

