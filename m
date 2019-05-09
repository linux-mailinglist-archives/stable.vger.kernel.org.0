Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A685819155
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfEISzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbfEISz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:55:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145232183F;
        Thu,  9 May 2019 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428128;
        bh=w5ymQl7lHM1mS1Q4LCFLffre3cuHotjrwiYmGOLvaco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xK5FNZ8NU6fYjarHPMg/8dlARJCet77ZS0KPPGpCsguZhFSFrAZn4XzpYj25BOy6N
         JVOe6dowCc79cqXys3LBVeEjAcRGDGoNx3Gx8OetHC+qscWpg8OFdkpMqlEMdV4qQ9
         ooWTM/K6AAx/Pqs0F+1V4lMNQli10GbOEa/rKJC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.1 28/30] i3c: Fix a shift wrap bug in i3c_bus_set_addr_slot_status()
Date:   Thu,  9 May 2019 20:43:00 +0200
Message-Id: <20190509181257.001930575@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181250.417203112@linuxfoundation.org>
References: <20190509181250.417203112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 476c7e1d34f2a03b1aa5a924c50703053fe5f77c upstream.

The problem here is that addr can be I3C_BROADCAST_ADDR (126).  That
means we're shifting by (126 * 2) % 64 which is 60.  The
I3C_ADDR_SLOT_STATUS_MASK is an enum which is an unsigned int in GCC
so shifts greater than 31 are undefined.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i3c/master.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -385,8 +385,9 @@ static void i3c_bus_set_addr_slot_status
 		return;
 
 	ptr = bus->addrslots + (bitpos / BITS_PER_LONG);
-	*ptr &= ~(I3C_ADDR_SLOT_STATUS_MASK << (bitpos % BITS_PER_LONG));
-	*ptr |= status << (bitpos % BITS_PER_LONG);
+	*ptr &= ~((unsigned long)I3C_ADDR_SLOT_STATUS_MASK <<
+						(bitpos % BITS_PER_LONG));
+	*ptr |= (unsigned long)status << (bitpos % BITS_PER_LONG);
 }
 
 static bool i3c_bus_dev_addr_is_avail(struct i3c_bus *bus, u8 addr)


