Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6A9431E0E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhJRN5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234183AbhJRNzU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:55:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6829A6137F;
        Mon, 18 Oct 2021 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564403;
        bh=IEVXBQ/6xZ+vbYCVhttAvoLjwdG6FbycEd4remA6ftM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/nyoIpLGZmyO4atlS1zxf6ZPcpq9p8w0tIEAFvyN4JcaMx67k/aG3oDQ8BWwnYXP
         sNyQBdx9+5U/RISrltn+iPQisXmqCAJl+z4cZmE6CAsigQQAisHkwJxTHwYJGVw6ho
         8zbFYqBevIC90RIyncwGJxjDI1zaksCj6T7bIBrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 077/151] iio: accel: fxls8962af: return IRQ_HANDLED when fifo is flushed
Date:   Mon, 18 Oct 2021 15:24:16 +0200
Message-Id: <20211018132343.186253685@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit 9033c7a357481fb5bcc1737bafa4aec572dca5c6 upstream.

fxls8962af_fifo_flush() will return the samples flushed.
So return IRQ_NONE only if an error is returned.

Fixes: 79e3a5bdd9ef ("iio: accel: fxls8962af: add hw buffered sampling")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20210817124336.1672169-1-sean@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/fxls8962af-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/fxls8962af-core.c
+++ b/drivers/iio/accel/fxls8962af-core.c
@@ -738,7 +738,7 @@ static irqreturn_t fxls8962af_interrupt(
 
 	if (reg & FXLS8962AF_INT_STATUS_SRC_BUF) {
 		ret = fxls8962af_fifo_flush(indio_dev);
-		if (ret)
+		if (ret < 0)
 			return IRQ_NONE;
 
 		return IRQ_HANDLED;


