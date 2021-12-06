Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D52D469B81
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356545AbhLFPRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348556AbhLFPOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB066C0698D3;
        Mon,  6 Dec 2021 07:07:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6EBBB810AC;
        Mon,  6 Dec 2021 15:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A77C341C2;
        Mon,  6 Dec 2021 15:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803247;
        bh=psyYCgaz3mYIq74qUOngbwEXYOO0DXwDhAb5gbjl8ow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANvZWJ2c3++lww1Bmnvp1jpGMlW68Z3mqArIhVsSRgzC1gHFF0oTqHC1faJoS3XyK
         FoYQFJqyCTrJ08YEjLv25i+1iCy+EdRAK0EEV7ZN7OH1pXGXQcMa+5B+uqU2pUxLrf
         AtIQQ1oGKJ9pYqc7mF8UA+rZXhTbZxNghd1RU0y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 039/106] PCI: aardvark: Indicate error in val when config read fails
Date:   Mon,  6 Dec 2021 15:55:47 +0100
Message-Id: <20211206145556.732430125@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -631,8 +631,10 @@ static int advk_pcie_rd_conf(struct pci_
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0)
+	if (ret < 0) {
+		*val = 0xffffffff;
 		return PCIBIOS_SET_FAILED;
+	}
 
 	/* Check PIO status and get the read result */
 	ret = advk_pcie_check_pio_status(pcie, val);


