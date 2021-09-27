Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3DA419AAE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhI0RLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235865AbhI0RJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A646120D;
        Mon, 27 Sep 2021 17:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762443;
        bh=93Hh6ibWsXSldPNCAhMKgvpyIb4yq5wWd0g+7SliDRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXA0VZRcVtzq/UznH72uA0DCAX5PcS3mFO+02gs6FTBylx9Vftn+y1PLjrmuqy+3Z
         2WdMBZLR8Nwm3bbEdJ2qfI+Te/lZL1QK2zTziAqv9i1ofRFJ3XyoM1w0j+qw87A6m6
         4o7aXih56CyoMYA4mF8FQnG9OBY7L9u7uCrIugMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 007/103] usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()
Date:   Mon, 27 Sep 2021 19:01:39 +0200
Message-Id: <20210927170225.961169218@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
@@ -190,6 +190,7 @@ tusb_fifo_write_unaligned(void __iomem *
 	}
 	if (len > 0) {
 		/* Write the rest 1 - 3 bytes to FIFO */
+		val = 0;
 		memcpy(&val, buf, len);
 		musb_writel(fifo, 0, val);
 	}


