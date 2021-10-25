Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0CE439F2C
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhJYTSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhJYTRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 453026101C;
        Mon, 25 Oct 2021 19:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189322;
        bh=NsnvHBtfrB7JTvTJxoyc14T4KqvhNTSri0+FiRhQ19k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyT4e8Ap0nEDMaQXUBtnT3FyS5lV4MmR5wwTFL1HCU/MqmEOnw9r803AhKYMoxRy7
         gCm6Xwn6VKRxTVGMXTKgi7o0bUUqpZsw8cMwwzpzbxeXD+r+y2uC1BtHYKxmruq4Vb
         YbXz4rK5C98bfnvDJ2Iv3q0yHjlHI6fEDY+pm+rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 07/44] USB: serial: qcserial: add EM9191 QDL support
Date:   Mon, 25 Oct 2021 21:13:48 +0200
Message-Id: <20211025190930.135658023@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Morgado <aleksander@aleksander.es>

commit 11c52d250b34a0862edc29db03fbec23b30db6da upstream.

When the module boots into QDL download mode it exposes the 1199:90d2
ids, which can be mapped to the qcserial driver, and used to run
firmware upgrades (e.g. with the qmi-firmware-update program).

  T:  Bus=01 Lev=03 Prnt=08 Port=03 Cnt=01 Dev#= 10 Spd=480 MxCh= 0
  D:  Ver= 2.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
  P:  Vendor=1199 ProdID=90d2 Rev=00.00
  S:  Manufacturer=Sierra Wireless, Incorporated
  S:  Product=Sierra Wireless EM9191
  S:  SerialNumber=8W0382004102A109
  C:  #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=2mA
  I:  If#=0x0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=10 Driver=qcserial

Signed-off-by: Aleksander Morgado <aleksander@aleksander.es>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/qcserial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -169,6 +169,7 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x1199, 0x907b)},	/* Sierra Wireless EM74xx */
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
+	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */


