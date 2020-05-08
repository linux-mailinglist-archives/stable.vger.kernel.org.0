Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703941CAFD2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgEHNUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728738AbgEHMks (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F82B24973;
        Fri,  8 May 2020 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941647;
        bh=uYTutWpeFVx8U1uosvVPfF9K6SerEPchJOh+0W11+ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uTMu3o7JhsE6cRQ5JMzZDeEAzRQ7mm4MSEjqxI+e+jOmfRRGPPziEBTK7BeSz3Ru1
         c6t+SLa8HNyNuPS6Y78o2wQDX9GYYmF18DYxlazHsRWJz+qrTO7CLJVrB51U4stX3A
         PEbDsQGZJH3TYPjy63U0MUsicUfU8XNQ4omf6+R4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4.4 117/312] serial: samsung: Fix possible out of bounds access on non-DT platform
Date:   Fri,  8 May 2020 14:31:48 +0200
Message-Id: <20200508123132.697716151@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 926b7b5122c96e1f18cd20e85a286c7ec8d18c97 upstream.

On non-DeviceTree platforms, the index of serial device is a static
variable incremented on each probe.  It is incremented even if deferred
probe happens when getting the clock in s3c24xx_serial_init_port().

This index is used for referencing elements of statically allocated
s3c24xx_serial_ports array.  In case of re-probe, the index will point
outside of this array leading to memory corruption.

Increment the index only on successful probe.

Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Fixes: b497549a035c ("[ARM] S3C24XX: Split serial driver into core and per-cpu drivers")
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/samsung.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1841,8 +1841,6 @@ static int s3c24xx_serial_probe(struct p
 	ourport->min_dma_size = max_t(int, ourport->port.fifosize,
 				    dma_get_cache_alignment());
 
-	probe_index++;
-
 	dbg("%s: initialising port %p...\n", __func__, ourport);
 
 	ret = s3c24xx_serial_init_port(ourport, pdev);
@@ -1872,6 +1870,8 @@ static int s3c24xx_serial_probe(struct p
 	if (ret < 0)
 		dev_err(&pdev->dev, "failed to add cpufreq notifier\n");
 
+	probe_index++;
+
 	return 0;
 }
 


