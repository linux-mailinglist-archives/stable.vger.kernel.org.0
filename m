Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7617B1BC92D
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgD1SjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgD1SjQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A2120575;
        Tue, 28 Apr 2020 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099155;
        bh=T0bqKDiD0pEiEkKfmreEht0rqWSSsLOrK+hh34wIOiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsGq6jUVSnuUulD4OEtkZsnBDlOApGvlJGUT4wmOQDEhtbKVRGm1NeGOabWAMYO7+
         WHny2oUmZnZiYLj40tzHJi+maGq50Gfa0LGk/eLfGhZKzoR61ORAldg1I4fskZDE63
         MOhfIV5T+HtqpYZRpGPH79ABwLuQcFfendyKqESw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 4.19 106/131] usb-storage: Add unusual_devs entry for JMicron JMS566
Date:   Tue, 28 Apr 2020 20:25:18 +0200
Message-Id: <20200428182238.513339421@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

commit 94f9c8c3c404ee1f7aaff81ad4f24aec4e34a78b upstream.

Cyril Roelandt reports that his JMicron JMS566 USB-SATA bridge fails
to handle WRITE commands with the FUA bit set, even though it claims
to support FUA.  (Oddly enough, a later version of the same bridge,
version 2.03 as opposed to 1.14, doesn't claim to support FUA.  Also
oddly, the bridge _does_ support FUA when using the UAS transport
instead of the Bulk-Only transport -- but this device was blacklisted
for uas in commit bc3bdb12bbb3 ("usb-storage: Disable UAS on JMicron
SATA enclosure") for apparently unrelated reasons.)

This patch adds a usb-storage unusual_devs entry with the BROKEN_FUA
flag.  This allows the bridge to work properly with usb-storage.

Reported-and-tested-by: Cyril Roelandt <tipecaml@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.2004221613110.11262-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2323,6 +2323,13 @@ UNUSUAL_DEV(  0x3340, 0xffff, 0x0000, 0x
 		USB_SC_DEVICE,USB_PR_DEVICE,NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Cyril Roelandt <tipecaml@gmail.com> */
+UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x0114,
+		"JMicron",
+		"USB to ATA/ATAPI Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_BROKEN_FUA ),
+
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
 		"iRiver",


