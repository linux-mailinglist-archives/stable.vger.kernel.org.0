Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084EA419A03
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbhI0RGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235819AbhI0RFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:05:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D666C6108E;
        Mon, 27 Sep 2021 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762250;
        bh=HE337sP3/0yJ052M2YgQGw+axEVVTAXC+bLq9fAyAdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naWwLr37R1+NYXD8qBnpyCb7kOEWeoFVWeNQRcqdaDuw89A7XCNoLsdVNWZIsbue5
         bmMk1xyfTodsBI8dTsMjoEbWEwB9s9kf3CH97jtrCdBrLBCPEULPgbnVMb3fzHi7IU
         uxFWx7ZGsf5YHJu+wL7ep6Hr9ABWU4DJWH9huQB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 5.4 19/68] mcb: fix error handling in mcb_alloc_bus()
Date:   Mon, 27 Sep 2021 19:02:15 +0200
Message-Id: <20210927170220.616077145@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170219.901812470@linuxfoundation.org>
References: <20210927170219.901812470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 25a1433216489de4abc889910f744e952cb6dbae upstream.

There are two bugs:
1) If ida_simple_get() fails then this code calls put_device(carrier)
   but we haven't yet called get_device(carrier) and probably that
   leads to a use after free.
2) After device_initialize() then we need to use put_device() to
   release the bus.  This will free the internal resources tied to the
   device and call mcb_free_bus() which will free the rest.

Fixes: 5d9e2ab9fea4 ("mcb: Implement bus->dev.release callback")
Fixes: 18d288198099 ("mcb: Correctly initialize the bus's device")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/32e160cf6864ce77f9d62948338e24db9fd8ead9.1630931319.git.johannes.thumshirn@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -277,8 +277,8 @@ struct mcb_bus *mcb_alloc_bus(struct dev
 
 	bus_nr = ida_simple_get(&mcb_ida, 0, 0, GFP_KERNEL);
 	if (bus_nr < 0) {
-		rc = bus_nr;
-		goto err_free;
+		kfree(bus);
+		return ERR_PTR(bus_nr);
 	}
 
 	bus->bus_nr = bus_nr;
@@ -293,12 +293,12 @@ struct mcb_bus *mcb_alloc_bus(struct dev
 	dev_set_name(&bus->dev, "mcb:%d", bus_nr);
 	rc = device_add(&bus->dev);
 	if (rc)
-		goto err_free;
+		goto err_put;
 
 	return bus;
-err_free:
-	put_device(carrier);
-	kfree(bus);
+
+err_put:
+	put_device(&bus->dev);
 	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_GPL(mcb_alloc_bus);


