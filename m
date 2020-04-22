Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F1F1B40F2
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgDVKN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbgDVKN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:13:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E2620575;
        Wed, 22 Apr 2020 10:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550405;
        bh=3h2z9IDbzxVQV+fUdUOCvqUsPvo+eOXmgmiUdyvpTDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThVXLNxHrx9WIuxySWQY1W4srmY0RMDG35s4YSLN04gdYtAO/RPPIn9mnrh3iaEw2
         yHLXI5Km18sznrXExjIEGbtgBPbnD2R1kN9Wsqh/4slLEX+3o4ppUdBVFafwuKyE+w
         8d/zMwXnT4lC2XYHva3+Atle0wl80SGw47T1Y+8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 105/199] mfd: dln2: Fix sanity checking for endpoints
Date:   Wed, 22 Apr 2020 11:57:11 +0200
Message-Id: <20200422095108.300701436@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 95d0f2df0ad42..672831d5ee32e 100644
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
@@ -740,10 +745,10 @@ static int dln2_probe(struct usb_interface *interface,
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



