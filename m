Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016A0259C9D
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgIAPOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgIAPN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF553206EB;
        Tue,  1 Sep 2020 15:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973239;
        bh=+bnBL3MGrBJAv8hplTWu8YL7eEhU7qYBZycfW4Qv6rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4f0ypCX4EwXGDXyHaLcQn9w/K5xWboHS3ycnoMxS0u9f4T2JHbkDwktYnM3EyxW3
         6j6m/YW2GYC3Zrm73WSCa4ISxUuhdCPIhAM3nsq7KJgWouekkpjR8P6fM+jCELS8IO
         MZDIzXtXRJ7Xbu/y6heT7rIWlyJyofw8yzGDbZXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <thinhn@synopsys.com>
Subject: [PATCH 4.4 55/62] usb: uas: Add quirk for PNY Pro Elite
Date:   Tue,  1 Sep 2020 17:10:38 +0200
Message-Id: <20200901150923.502234652@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
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
@@ -155,6 +155,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x99
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


