Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856AE4D64E
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfFTSG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfFTSG3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:06:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84485204FD;
        Thu, 20 Jun 2019 18:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053988;
        bh=x7wSzYAg5Z3U5c4Cr/R9upcHWEUgoG1se+17GB55b8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aj/j2p/WGsAe1dfLM/zL9WbaKQOkcjgCj1rKdHX3p3fjnUFrXg2hjy2xe4Zv4iS7d
         kni6pe4qLHmo44Fw/0HvP3OK3B/UFyDMYEnz/lPnv7Lc3O5QUPEC7xrHFTtyUtL+RP
         qdKYYRckw0NKlHiO4FBgDgqv1PhVm65HAzutbJh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Weinelt <martin@linuxlounge.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.9 096/117] Revert "staging: vc04_services: prevent integer overflow in create_pagelist()"
Date:   Thu, 20 Jun 2019 19:57:10 +0200
Message-Id: <20190620174357.661920821@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit cf07331c8827c9e9e0b4274c9b60204c18592241 which was
commit ca641bae6da977d638458e78cd1487b6160a2718 upstream.

Martin writes:
	This commit breaks the kernel build because the vchiq_pagelist_info
	struct is not defined in v4.9.182.

	It was only added in v4.10, in commit
	4807f2c0e684e907c501cb96049809d7a957dbc2.

Reported-by: Martin Weinelt <martin@linuxlounge.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
@@ -381,18 +381,9 @@ create_pagelist(char __user *buf, size_t
 	int run, addridx, actual_pages;
         unsigned long *need_release;
 
-	if (count >= INT_MAX - PAGE_SIZE)
-		return NULL;
-
 	offset = (unsigned int)buf & (PAGE_SIZE - 1);
 	num_pages = (count + offset + PAGE_SIZE - 1) / PAGE_SIZE;
 
-	if (num_pages > (SIZE_MAX - sizeof(PAGELIST_T) -
-			 sizeof(struct vchiq_pagelist_info)) /
-			(sizeof(u32) + sizeof(pages[0]) +
-			 sizeof(struct scatterlist)))
-		return NULL;
-
 	*ppagelist = NULL;
 
 	/* Allocate enough storage to hold the page pointers and the page


