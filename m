Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E613A7CC
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732383AbfFIQxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731713AbfFIQxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 398612081C;
        Sun,  9 Jun 2019 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099199;
        bh=9c6gTPPLhc//uMtT9TCigZWOvEZ7xOphkK8zOKNZCGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5xS3yOOBzbaiLWiBX4i2bIJVGKw39gktNbKncMw7JGOjCP0CDHN5+SytLlRsoKRH
         5GBqDsQfLmw8bPMUNu/lLFMzqxHfOf5PjPkv5jA9VRO7GLUBtC4ghfkymR1BWfuxSx
         uNzRxLHtzBEwts/EmbGmxySWcYj7LHeW34ZvE+9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.9 45/83] staging: vc04_services: prevent integer overflow in create_pagelist()
Date:   Sun,  9 Jun 2019 18:42:15 +0200
Message-Id: <20190609164131.760341489@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ca641bae6da977d638458e78cd1487b6160a2718 upstream.

The create_pagelist() "count" parameter comes from the user in
vchiq_ioctl() and it could overflow.  If you look at how create_page()
is called in vchiq_prepare_bulk_data(), then the "size" variable is an
int so it doesn't make sense to allow negatives or larger than INT_MAX.

I don't know this code terribly well, but I believe that typical values
of "count" are typically quite low and I don't think this check will
affect normal valid uses at all.

The "pagelist_size" calculation can also overflow on 32 bit systems, but
not on 64 bit systems.  I have added an integer overflow check for that
as well.

The Raspberry PI doesn't offer the same level of memory protection that
x86 does so these sorts of bugs are probably not super critical to fix.

Fixes: 71bad7f08641 ("staging: add bcm2708 vchiq driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
@@ -381,9 +381,18 @@ create_pagelist(char __user *buf, size_t
 	int run, addridx, actual_pages;
         unsigned long *need_release;
 
+	if (count >= INT_MAX - PAGE_SIZE)
+		return NULL;
+
 	offset = (unsigned int)buf & (PAGE_SIZE - 1);
 	num_pages = (count + offset + PAGE_SIZE - 1) / PAGE_SIZE;
 
+	if (num_pages > (SIZE_MAX - sizeof(PAGELIST_T) -
+			 sizeof(struct vchiq_pagelist_info)) /
+			(sizeof(u32) + sizeof(pages[0]) +
+			 sizeof(struct scatterlist)))
+		return NULL;
+
 	*ppagelist = NULL;
 
 	/* Allocate enough storage to hold the page pointers and the page


