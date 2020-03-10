Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BDD17F8FE
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgCJMw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgCJMw5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:52:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD4AA20674;
        Tue, 10 Mar 2020 12:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844776;
        bh=WLTWQkKSnLnhF6Yiww78OxYvtR69QxHf5Yt/kkUHpaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhBeHsXB+wsePFVsSzB4PwC/x+GNhmsUBM/cIAuUevSrXqJ5pXL/HG2QWzvj1KE6C
         c34Jqp4J350We9KyqilvYo1sy2hINVks5wlo2JWyakU2yGGo/aOGBcrKnTtnWRFzba
         1WYJ0rbeK25aB5BROaPM/lmGeANRvJEzXeJSxw+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Lin <jilin@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 066/168] usb: storage: Add quirk for Samsung Fit flash
Date:   Tue, 10 Mar 2020 13:38:32 +0100
Message-Id: <20200310123641.954557630@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Lin <jilin@nvidia.com>

commit 86d92f5465958752481269348d474414dccb1552 upstream.

Current driver has 240 (USB2.0) and 2048 (USB3.0) as max_sectors,
e.g., /sys/bus/scsi/devices/0:0:0:0/max_sectors

If data access times out, driver error handling will issue a port
reset.
Sometimes Samsung Fit (090C:1000) flash disk will not respond to
later Set Address or Get Descriptor command.

Adding this quirk to limit max_sectors to 64 sectors to avoid issue
occurring.

Signed-off-by: Jim Lin <jilin@nvidia.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1583158895-31342-1-git-send-email-jilin@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1258,6 +1258,12 @@ UNUSUAL_DEV( 0x090a, 0x1200, 0x0000, 0x9
 		USB_SC_RBC, USB_PR_BULK, NULL,
 		0 ),
 
+UNUSUAL_DEV(0x090c, 0x1000, 0x1100, 0x1100,
+		"Samsung",
+		"Flash Drive FIT",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* aeb */
 UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
 		"Feiya",


