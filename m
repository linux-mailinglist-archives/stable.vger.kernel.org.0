Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDCE3291DB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbhCAUej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:34:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235126AbhCAU0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:26:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D53C565411;
        Mon,  1 Mar 2021 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622019;
        bh=Pm5Qd/vUJGfqfuzFL9tu69HEJlAfVbuJOcqpaTmj6Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfSdMgibi+Q6Ta6950PTx6rDRWZD7wDbM9bzPSty8D32VA8WhbLxCn5oN0bgIrF3p
         G3iRjji+vjGTOdHooztZgUNQne4RTPHfWcwvnCLuTEQ5t1H0JGFsxIzxVM50tdEM4F
         tuguE+u8jeEKFxocYCMP7WAsJUgsEGGA82tNMaPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.11 697/775] mtd: spi-nor: hisi-sfc: Put child node np on error path
Date:   Mon,  1 Mar 2021 17:14:25 +0100
Message-Id: <20210301161235.821605500@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit fe6653460ee7a7dbe0cd5fd322992af862ce5ab0 upstream.

Put the child node np when it fails to get or register device.

Fixes: e523f11141bd ("mtd: spi-nor: add hisilicon spi-nor flash controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Pan Bian <bianpan2016@163.com>
[ta: Add Fixes tag and Cc stable]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20210121091847.85362-1-bianpan2016@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/controllers/hisi-sfc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/controllers/hisi-sfc.c
+++ b/drivers/mtd/spi-nor/controllers/hisi-sfc.c
@@ -399,8 +399,10 @@ static int hisi_spi_nor_register_all(str
 
 	for_each_available_child_of_node(dev->of_node, np) {
 		ret = hisi_spi_nor_register(np, host);
-		if (ret)
+		if (ret) {
+			of_node_put(np);
 			goto fail;
+		}
 
 		if (host->num_chip == HIFMC_MAX_CHIP_NUM) {
 			dev_warn(dev, "Flash device number exceeds the maximum chipselect number\n");


