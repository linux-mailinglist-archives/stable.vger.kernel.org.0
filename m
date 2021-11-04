Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8D844551A
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhKDOUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:20:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232159AbhKDOSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5039F61248;
        Thu,  4 Nov 2021 14:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035377;
        bh=CAOceHmDjFQ4rqH7fuDy64h/MqmjOcvb8w5OWtrZZTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPt+oDbg5sWXnLMRXUj8F3mFpDlfAynKz3Om5UI4grlN7MF/i4BesDQdv/IHxAfe6
         ne84VaymhD7rVPyqTwdIdg7RKSWRAJdUwssXLKkNKzSegyw33nEigQPm7ekUjkZu7p
         jN2DTEUnQmpaR4ikaGDKHl69cVQshsIm/CooL0Yw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mile Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Subject: [PATCH 4.19 3/7] IB/qib: Use struct_size() helper
Date:   Thu,  4 Nov 2021 15:13:06 +0100
Message-Id: <20211104141158.144097533@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141158.037189396@linuxfoundation.org>
References: <20211104141158.037189396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 829ca44ecf60e9b6f83d0161a6ef10c1304c5060 upstream.

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace the following form:

sizeof(*pkt) + sizeof(pkt->addr[0])*n

with:

struct_size(pkt, addr, n)

Also, notice that variable size is unnecessary, hence it is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Mile Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -908,10 +908,11 @@ static int qib_user_sdma_queue_pkts(cons
 		}
 
 		if (frag_size) {
-			int pktsize, tidsmsize, n;
+			int tidsmsize, n;
+			size_t pktsize;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
-			pktsize = sizeof(*pkt) + sizeof(pkt->addr[0])*n;
+			pktsize = struct_size(pkt, addr, n);
 
 			/*
 			 * Determine if this is tid-sdma or just sdma.


