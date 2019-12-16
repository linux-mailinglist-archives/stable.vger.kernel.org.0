Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C27B121763
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbfLPSfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:49896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbfLPSIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:08:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B19B72072D;
        Mon, 16 Dec 2019 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519701;
        bh=1AUrRWkuKd93Vu4XM2xAppPLl4YptojGjXIUS81Acr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZwQs08kf9URlCN2awVcFnMoQbPtESOep3u5Bjmt1S01AumJNEIrwQeiA4C0UPPn4
         2dLx/2J2Z7nbzjF1EmVEkgogR1DI61QGuaMEhYI85pxD7JIMUT4Nz+cxq1CN63xXbY
         q17dMpMXE+FKWuqtCjts/IX+gf5i4tdp7Vja5APo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.3 008/180] USB: uas: honor flag to avoid CAPACITY16
Date:   Mon, 16 Dec 2019 18:47:28 +0100
Message-Id: <20191216174807.557919593@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit bff000cae1eec750d62e265c4ba2db9af57b17e1 upstream.

Copy the support over from usb-storage to get feature parity

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191114112758.32747-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -825,6 +825,10 @@ static int uas_slave_configure(struct sc
 		sdev->wce_default_on = 1;
 	}
 
+	/* Some disks cannot handle READ_CAPACITY_16 */
+	if (devinfo->flags & US_FL_NO_READ_CAPACITY_16)
+		sdev->no_read_capacity_16 = 1;
+
 	/*
 	 * Some disks return the total number of blocks in response
 	 * to READ CAPACITY rather than the highest block number.


