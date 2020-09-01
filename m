Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFE9259C9E
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgIARRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729012AbgIAPOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:14:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47731206EB;
        Tue,  1 Sep 2020 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973244;
        bh=QUuJAmNLz3po6UFp0oXzAfDS2Wu+mrghwrPnl0fVEs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0GtGD3sM7oF6pNrFTpedFKDnIyWyyv1kNvpDSrFjOHXA/EwT+ZtcV7rEc7Atok8n
         I3K94IhsJGEHJ3YfirDbsCz/aYinNNq67ZEnX+VMiYlWe81aZHhMg4SV50iENkq/wC
         gKZwfVCzL4IX4pec9W8wT6H3ispS2ZdCuyNWTfS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brice Goglin <brice.goglin@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 4.4 57/62] USB: Ignore UAS for JMicron JMS567 ATA/ATAPI Bridge
Date:   Tue,  1 Sep 2020 17:10:40 +0200
Message-Id: <20200901150923.607361490@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
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
@@ -2213,7 +2213,7 @@ UNUSUAL_DEV(  0x357d, 0x7788, 0x0114, 0x
 		"JMicron",
 		"USB to ATA/ATAPI Bridge",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_BROKEN_FUA ),
+		US_FL_BROKEN_FUA | US_FL_IGNORE_UAS ),
 
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,


