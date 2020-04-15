Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431A1A9DDA
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897596AbgDOLrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:47:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897585AbgDOLrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:47:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7196E21655;
        Wed, 15 Apr 2020 11:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951220;
        bh=jObTWNnMaHHidvtaybkPvbifiOTSw/wElwG0AYkUPhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcbWAuryh4zxdi1LGc9cN18r1DKS9AuvpqJufNqlrpylZjCgHLvrI2CwAZi1C2f2N
         BgZfwEkFlqlJM2TSW5ul4F5Yol+vq3+qhKfd+uzN3qFLqcKVYUgUltefEBZQB0ZE9h
         MP7GZqynwZyhygX8lbs0P9L8+6G67IimqWnJr+vo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 31/40] mfd: dln2: Fix sanity checking for endpoints
Date:   Wed, 15 Apr 2020 07:46:14 -0400
Message-Id: <20200415114623.14972-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114623.14972-1-sashal@kernel.org>
References: <20200415114623.14972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fb945c95a482200876993977008b67ea658bd938 ]

While the commit 2b8bd606b1e6 ("mfd: dln2: More sanity checking for endpoints")
tries to harden the sanity checks it made at the same time a regression,
i.e.  mixed in and out endpoints. Obviously it should have been not tested on
real hardware at that time, but unluckily it didn't happen.

So, fix above mentioned typo and make device being enumerated again.

While here, introduce an enumerator for magic values to prevent similar issue
to happen in the future.

Fixes: 2b8bd606b1e6 ("mfd: dln2: More sanity checking for endpoints")
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/dln2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
index 1476465ce803b..6ea0dd37b4535 100644
--- a/drivers/mfd/dln2.c
+++ b/drivers/mfd/dln2.c
@@ -93,6 +93,11 @@ struct dln2_mod_rx_slots {
 	spinlock_t lock;
 };
 
+enum dln2_endpoint {
+	DLN2_EP_OUT	= 0,
+	DLN2_EP_IN	= 1,
+};
+
 struct dln2_dev {
 	struct usb_device *usb_dev;
 	struct usb_interface *interface;
@@ -736,10 +741,10 @@ static int dln2_probe(struct usb_interface *interface,
 	    hostif->desc.bNumEndpoints < 2)
 		return -ENODEV;
 
-	epin = &hostif->endpoint[0].desc;
-	epout = &hostif->endpoint[1].desc;
+	epout = &hostif->endpoint[DLN2_EP_OUT].desc;
 	if (!usb_endpoint_is_bulk_out(epout))
 		return -ENODEV;
+	epin = &hostif->endpoint[DLN2_EP_IN].desc;
 	if (!usb_endpoint_is_bulk_in(epin))
 		return -ENODEV;
 
-- 
2.20.1

