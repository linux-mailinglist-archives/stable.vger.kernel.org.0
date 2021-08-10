Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02473E80A5
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhHJRvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236762AbhHJRtm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:49:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C91D461209;
        Tue, 10 Aug 2021 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617317;
        bh=Jha8fhg1mL/utIyZdziZC4Sv7ThFgnNodpeJY1iJvf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jn0qbr0BzXP62uyuitqQcGPt2pZY+kLueYztYUN33ESgcSHu8Vpflnf0E9aDwXJ/Y
         DtAwfpwN3ObYtFUDxqKy1I4BmD6CWf7xX0uCOkgNYZaVjojO8iuhmlJj0lZgupgOmV
         CuwL1+xjj4yc24qCCId7hSk+VAudlUGYxTj74f9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 114/135] soc: ixp4xx: fix printing resources
Date:   Tue, 10 Aug 2021 19:30:48 +0200
Message-Id: <20210810172959.671094025@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 8861452b2097bb0b5d0081a1c137fb3870b0a31f upstream.

When compile-testing with 64-bit resource_size_t, gcc reports an invalid
printk format string:

In file included from include/linux/dma-mapping.h:7,
                 from drivers/soc/ixp4xx/ixp4xx-npe.c:15:
drivers/soc/ixp4xx/ixp4xx-npe.c: In function 'ixp4xx_npe_probe':
drivers/soc/ixp4xx/ixp4xx-npe.c:694:18: error: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Werror=format=]
    dev_info(dev, "NPE%d at 0x%08x-0x%08x not available\n",

Use the special %pR format string to print the resources.

Fixes: 0b458d7b10f8 ("soc: ixp4xx: npe: Pass addresses as resources")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/ixp4xx/ixp4xx-npe.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/soc/ixp4xx/ixp4xx-npe.c
+++ b/drivers/soc/ixp4xx/ixp4xx-npe.c
@@ -690,8 +690,8 @@ static int ixp4xx_npe_probe(struct platf
 
 		if (!(ixp4xx_read_feature_bits() &
 		      (IXP4XX_FEATURE_RESET_NPEA << i))) {
-			dev_info(dev, "NPE%d at 0x%08x-0x%08x not available\n",
-				 i, res->start, res->end);
+			dev_info(dev, "NPE%d at %pR not available\n",
+				 i, res);
 			continue; /* NPE already disabled or not present */
 		}
 		npe->regs = devm_ioremap_resource(dev, res);
@@ -699,13 +699,12 @@ static int ixp4xx_npe_probe(struct platf
 			return PTR_ERR(npe->regs);
 
 		if (npe_reset(npe)) {
-			dev_info(dev, "NPE%d at 0x%08x-0x%08x does not reset\n",
-				 i, res->start, res->end);
+			dev_info(dev, "NPE%d at %pR does not reset\n",
+				 i, res);
 			continue;
 		}
 		npe->valid = 1;
-		dev_info(dev, "NPE%d at 0x%08x-0x%08x registered\n",
-			 i, res->start, res->end);
+		dev_info(dev, "NPE%d at %pR registered\n", i, res);
 		found++;
 	}
 


