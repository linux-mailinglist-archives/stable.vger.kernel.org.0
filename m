Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6355A4A44B3
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243770AbiAaLcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379033AbiAaL3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1EEC0613FF;
        Mon, 31 Jan 2022 03:18:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BBFB61257;
        Mon, 31 Jan 2022 11:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCCEC340EF;
        Mon, 31 Jan 2022 11:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627936;
        bh=p9gzYhntkEFFU0kZCVkx2X3WS7L38CrCbtyOn9AY4Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkeGDZsXp0H4D5ieDbo8PqjRWZNH1zNMpX9Cr30aAm1OxDoHSO1krqEsTsyFQo0Td
         MUk3DVXI1ezFxVESpfrQLvbGOr3wdcoPZ2+RTgZVdLDJxkw2bBNYpDQIqc872baDUd
         BgYo/wm2ymrk0y8t9ueaICXfuYmTcre3kzgGodfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DocMAX <mail@vacharakis.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 5.16 073/200] usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
Date:   Mon, 31 Jan 2022 11:55:36 +0100
Message-Id: <20220131105236.043195423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 5b67b315037250a61861119683e7fcb509deea25 upstream.

Two people have reported (and mentioned numerous other reports on the
web) that VIA's VL817 USB-SATA bridge does not work with the uas
driver.  Typical log messages are:

[ 3606.232149] sd 14:0:0:0: [sdg] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
[ 3606.232154] sd 14:0:0:0: [sdg] tag#2 CDB: Write(16) 8a 00 00 00 00 00 18 0c c9 80 00 00 00 80 00 00
[ 3606.306257] usb 4-4.4: reset SuperSpeed Plus Gen 2x1 USB device number 11 using xhci_hcd
[ 3606.328584] scsi host14: uas_eh_device_reset_handler success

Surprisingly, the devices do seem to work okay for some other people.
The cause of the differing behaviors is not known.

In the hope of getting the devices to work for the most users, even at
the possible cost of degraded performance for some, this patch adds an
unusual_devs entry for the VL817 to block it from binding to the uas
driver by default.  Users will be able to override this entry by means
of a module parameter, if they want.

CC: <stable@vger.kernel.org>
Reported-by: DocMAX <mail@vacharakis.de>
Reported-and-tested-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/Ye8IsK2sjlEv1rqU@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2301,6 +2301,16 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
 		US_FL_SCM_MULT_TARG ),
 
+/*
+ * Reported by DocMAX <mail@vacharakis.de>
+ * and Thomas Weißschuh <linux@weissschuh.net>
+ */
+UNUSUAL_DEV( 0x2109, 0x0715, 0x9999, 0x9999,
+		"VIA Labs, Inc.",
+		"VL817 SATA Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",


