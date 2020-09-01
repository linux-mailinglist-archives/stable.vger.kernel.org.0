Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47149259415
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgIAPf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgIAPf1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFBF20866;
        Tue,  1 Sep 2020 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974526;
        bh=uZ2cKxuigQGTZJA16yFuIuvZhEK5XCUeHR7VZ6noavE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqT0GHyuG2zK4BS16fXJT1whY/vjUQEOpZjfrQCA/DybquuSyI9D5JiOqI7/UPujS
         j6R4aobt9TzvQ+iFzQD1MGwPWNCbLnd1sN7w9UP2Ex5Kajun/BETCa7WZGErcu6zA8
         1jktZyhJgn5CfQbDeFU0Vh3EUfe/ykqdxFz9IkUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brice Goglin <brice.goglin@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 5.4 193/214] USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge
Date:   Tue,  1 Sep 2020 17:11:13 +0200
Message-Id: <20200901151002.194608271@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cyril Roelandt <tipecaml@gmail.com>

commit 9aa37788e7ebb3f489fb4b71ce07adadd444264a upstream.

This device does not support UAS properly and a similar entry already
exists in drivers/usb/storage/unusual_uas.h. Without this patch,
storage_probe() defers the handling of this device to UAS, which cannot
handle it either.

Tested-by: Brice Goglin <brice.goglin@gmail.com>
Fixes: bc3bdb12bbb3 ("usb-storage: Disable UAS on JMicron SATA enclosure")
Acked-by: Alan Stern <stern@rowland.harvard.edu>
CC: <stable@vger.kernel.org>
Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
Link: https://lore.kernel.org/r/20200825212231.46309-1-tipecaml@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/unusual_devs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2328,7 +2328,7 @@ UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_BROKEN_FUA ),
+		US_FL_BROKEN_FUA | US_FL_IGNORE_UAS ),
 
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,


