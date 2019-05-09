Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE2F191A1
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbfEIS55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfEISxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:53:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C413217F9;
        Thu,  9 May 2019 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557428023;
        bh=w5ymQl7lHM1mS1Q4LCFLffre3cuHotjrwiYmGOLvaco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYDdozm+iMfmo31B8i62zB28Coc66JfLDm74PvanmW5LpQkuGipKHF8hxNzLA2oe4
         zCIdCfww8VERc5efRNy06Yfpou41LR31msGR0Nxiwoawmwf3zmT9hu8JWvoBB6wyOC
         0TKhwNwb4FrNDhYClyQnUi9IKEphj+G7jSzoxLpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.0 93/95] i3c: Fix a shift wrap bug in i3c_bus_set_addr_slot_status()
Date:   Thu,  9 May 2019 20:42:50 +0200
Message-Id: <20190509181315.703849416@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
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


