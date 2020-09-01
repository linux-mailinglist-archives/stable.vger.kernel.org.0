Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0BA259404
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgIAPel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:34:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgIAPei (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FBC720866;
        Tue,  1 Sep 2020 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974477;
        bh=nLJ+6B4bgisxIzyhAjXdfAcpFlxAgiJfxV7qDHHQ0pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqBK/F5AUmvdSx91n/a3IXMndycNLSIB8bWYk6GG/eK+t6YTsefDpYB16Rfe/dWMk
         2xXGioIEA8PJJcEW4uuLRB2MkbMkL6HfqWhXZb6NdTC1WJHYj9KNluPtC+cns87Zzv
         p8Kx6ivEMnBhf6i3hRMBiuuNPF8WqJsBoXSHhoSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>
Subject: [PATCH 5.4 190/214] usb: uas: Add quirk for PNY Pro Elite
Date:   Tue,  1 Sep 2020 17:11:10 +0200
Message-Id: <20200901151002.050829426@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 9a469bc9f32dd33c7aac5744669d21a023a719cd upstream.

PNY Pro Elite USB 3.1 Gen 2 device (SSD) doesn't respond to ATA_12
pass-through command (i.e. it just hangs). If it doesn't support this
command, it should respond properly to the host. Let's just add a quirk
to be able to move forward with other operations.

Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Link: https://lore.kernel.org/r/2b0585228b003eedcc82db84697b31477df152e0.1597803605.git.thinhn@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -80,6 +80,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
+UNUSUAL_DEV(0x154b, 0xf00d, 0x0000, 0x9999,
+		"PNY",
+		"Pro Elite SSD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
 UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VIA",


