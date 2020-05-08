Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B901CAB38
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgEHMle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgEHMld (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 568D12495F;
        Fri,  8 May 2020 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941692;
        bh=TWVZp//Y38gc0wX2cTOnRapUQ18gETsH64Rw0nidY3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pqu2TBbRKtdQLyRLJXak81fou9Ek+OsXg8F2d84AZ/7KbpMR1WoDcPufIehe0RWCC
         B5m4zQ0bJ3eX0RZWiu0FGWmR+TJvqqNOXvsSzApHTgGQoOr5oaAT/Z1d2gJeYBCvhw
         Qc9mwU5RLzcYLArVtRt9oKoMsd1Nep7xD4RXWwNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 4.4 133/312] mtd: nand: pxa3xx_nand: fix dmaengine initialization
Date:   Fri,  8 May 2020 14:32:04 +0200
Message-Id: <20200508123133.859362525@linuxfoundation.org>
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

From: Robert Jarzmik <robert.jarzmik@free.fr>

commit 9097103f06332d099c5ab06d1e7f22f4bcaca6e2 upstream.

When the driver is initialized in a pure device-tree platform, the
driver's probe fails allocating the dma channel :
[  525.624435] pxa3xx-nand 43100000.nand: no resource defined for data DMA
[  525.632088] pxa3xx-nand 43100000.nand: alloc nand resource failed

The reason is that the DMA IO resource is not acquired through platform
resources but by OF bindings.

Fix this by ensuring that DMA IO resources are only queried in the non
device-tree case.

Fixes: 8f5ba31aa565 ("mtd: nand: pxa3xx-nand: switch to dmaengine")
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Acked-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/pxa3xx_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1750,7 +1750,7 @@ static int alloc_nand_resource(struct pl
 	if (ret < 0)
 		return ret;
 
-	if (use_dma) {
+	if (!np && use_dma) {
 		r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 		if (r == NULL) {
 			dev_err(&pdev->dev,


