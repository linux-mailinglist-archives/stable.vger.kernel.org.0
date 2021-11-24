Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF0A45BCD7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245199AbhKXMcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:32:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244010AbhKXMa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60ABE61354;
        Wed, 24 Nov 2021 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756364;
        bh=MO9zNwTk5kQxaTP2e4taKjS1In9kHauVqQCdKI46FIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLCqu+psfz2sdf1MKfOeARv9HkvJSDt4GqY8NmgOwJ7tEN4vc2P0C+RTKth9wfVVL
         ptr3P7BElWOE47NwmhQDNTrPTPhVftgJ1sYF2PhYx7+UlFe4va3XKaSyutyMSlmWZu
         tZRLUzsXWytR4cSMWB/NjfxBBFaXj/mzkls4PcGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 4.14 060/251] PCI: aardvark: Fix return value of MSI domain .alloc() method
Date:   Wed, 24 Nov 2021 12:55:02 +0100
Message-Id: <20211124115712.331915465@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
 drivers/pci/host/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -662,7 +662,7 @@ static int advk_msi_irq_domain_alloc(str
 				    domain->host_data, handle_simple_irq,
 				    NULL, NULL);
 
-	return hwirq;
+	return 0;
 }
 
 static void advk_msi_irq_domain_free(struct irq_domain *domain,


