Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8EF420C64
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhJDNFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234604AbhJDNCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:02:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 105976140B;
        Mon,  4 Oct 2021 12:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352358;
        bh=tg/LdSw7r3e908Zm42bDYSimlqnlchmK7sNUofOb8Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TSWWLkooPI+YLs/2bmCCk8t1tNmlCzsTlr98dczEHu0gSOeHnByYFui3bLaR2NsQR
         s/ZyPUsA9sIPD5oRAHyvqioaic/B+UKPI9asN6FnCKAV+Ew20gqb69oAdhWuLLzwxf
         tGCmmjTfzO57lZe7W0XPLT8HUgLKZAnlLtUTaEBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.14 03/75] usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()
Date:   Mon,  4 Oct 2021 14:51:38 +0200
Message-Id: <20211004125031.645601957@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125031.530773667@linuxfoundation.org>
References: <20211004125031.530773667@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 517c7bf99bad3d6b9360558414aae634b7472d80 upstream.

This is writing to the first 1 - 3 bytes of "val" and then writing all
four bytes to musb_writel().  The last byte is always going to be
garbage.  Zero out the last bytes instead.

Fixes: 550a7375fe72 ("USB: Add MUSB and TUSB support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210916135737.GI25094@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/tusb6010.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -193,6 +193,7 @@ tusb_fifo_write_unaligned(void __iomem *
 	}
 	if (len > 0) {
 		/* Write the rest 1 - 3 bytes to FIFO */
+		val = 0;
 		memcpy(&val, buf, len);
 		musb_writel(fifo, 0, val);
 	}


