Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE54450B31
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237128AbhKORUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237280AbhKORTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7BF063253;
        Mon, 15 Nov 2021 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996430;
        bh=S4eZjmofbbRFPzlVUhD0Mtd+WK5Xv48gIJFieZMN9/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGsKc3soF6HvxQQCvVrD3hpYjBLVQh5A+aXiJjfKV3+npm+o5FUkgP5lHtQcHZnW3
         rmj6NfjQ6OfFLEP2kB/hjYqPgyvLa/225g3AQMv8x/gZ21lJM/Rf8jJbSNuRv3sa1P
         GpnMtX0rNSSaSo+7KcC7ig9LrFQJlnpVjLsvdxY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 103/355] PCI: aardvark: Fix return value of MSI domain .alloc() method
Date:   Mon, 15 Nov 2021 18:00:27 +0100
Message-Id: <20211115165317.139514343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit e4313be1599d397625c14fb7826996813622decf upstream.

MSI domain callback .alloc() (implemented by advk_msi_irq_domain_alloc()
function) should return zero on success, since non-zero value indicates
failure.

When the driver was converted to generic MSI API in commit f21a8b1b6837
("PCI: aardvark: Move to MSI handling using generic MSI support"), it
was converted so that it returns hwirq number.

Fix this.

Link: https://lore.kernel.org/r/20211028185659.20329-3-kabel@kernel.org
Fixes: f21a8b1b6837 ("PCI: aardvark: Move to MSI handling using generic MSI support")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -942,7 +942,7 @@ static int advk_msi_irq_domain_alloc(str
 				    domain->host_data, handle_simple_irq,
 				    NULL, NULL);
 
-	return hwirq;
+	return 0;
 }
 
 static void advk_msi_irq_domain_free(struct irq_domain *domain,


