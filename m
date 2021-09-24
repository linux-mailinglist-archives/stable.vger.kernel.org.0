Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4A641735B
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344763AbhIXMzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344348AbhIXMxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB98C6125F;
        Fri, 24 Sep 2021 12:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487807;
        bh=FTSieDLIx4pWhtpyFigIceGSIy9UU14W5h8qi8fPuus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XU0+FGJGAB73DQSv+TVwDdIHeLd2FI9db0KwBMEsXLZCOCNxotT2aliqkBampXvQF
         5ibZinHTtVYMTAr39Rci6Hqr22l34h+U/xqNHJWuPNXz1U0oCTwYjhJJCdyFFkX6j4
         1IgC6aqg9gFjTAgoOYP3EGeALxjwink3V3rTRAIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.4 02/50] PCI: aardvark: Indicate error in val when config read fails
Date:   Fri, 24 Sep 2021 14:43:51 +0200
Message-Id: <20210924124332.311007753@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124332.229289734@linuxfoundation.org>
References: <20210924124332.229289734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b1bd5714472cc72e14409f5659b154c765a76c65 upstream.

Most callers of config read do not check for return value. But most of the
ones that do, checks for error indication in 'val' variable.

This patch updates error handling in advk_pcie_rd_conf() function. If PIO
transfer fails then 'val' variable is set to 0xffffffff which indicates
failture.

Link: https://lore.kernel.org/r/20200528162604.GA323482@bjorn-Precision-5520
Link: https://lore.kernel.org/r/20200601130315.18895-1-pali@kernel.org
Reported-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -664,8 +664,10 @@ static int advk_pcie_rd_conf(struct pci_
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0)
+	if (ret < 0) {
+		*val = 0xffffffff;
 		return PCIBIOS_SET_FAILED;
+	}
 
 	/* Check PIO status and get the read result */
 	ret = advk_pcie_check_pio_status(pcie, val);


