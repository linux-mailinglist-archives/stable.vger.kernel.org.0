Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA0DD79804
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389463AbfG2TmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389458AbfG2TmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:42:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6834A2054F;
        Mon, 29 Jul 2019 19:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429328;
        bh=rWYz9xo/WKu8NOvHjnTN4kXmB1g94dKxuNB+LbsP418=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KE82p25n4v6t66ORLfIJd+baxdno4ip9yyXUitlUJMWvSHb0buq8IkpuLVjyoKzE
         8VUGHeNO8+8lPZQbHiazn0l5OAvf6B4tKgWuPTdirWI+2KkrcSyuTjdtILBUIFtaU7
         O9cgkUmcZX4knpJDD/UOnnl/sXCVjqFuW59DHKDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Minghuan Lian <Minghuan.Lian@nxp.com>,
        Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/113] PCI: mobiveil: Fix PCI base address in MEM/IO outbound windows
Date:   Mon, 29 Jul 2019 21:22:29 +0200
Message-Id: <20190729190710.299999798@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f99536e9d2f55996038158a6559d4254a7cc1693 ]

The outbound memory windows PCI base addresses should be taken
from the 'ranges' property of DT node to setup MEM/IO outbound
windows decoding correctly instead of being hardcoded to zero.

Update the code to retrieve the PCI base address for each range
and use it to program the outbound windows address decoders

Fixes: 9af6bcb11e12 ("PCI: mobiveil: Add Mobiveil PCIe Host Bridge IP driver")
Signed-off-by: Hou Zhiqiang <Zhiqiang.Hou@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Minghuan Lian <Minghuan.Lian@nxp.com>
Reviewed-by: Subrahmanya Lingappa <l.subrahmanya@mobiveil.co.in>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mobiveil.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pcie-mobiveil.c b/drivers/pci/controller/pcie-mobiveil.c
index a939e8d31735..d9f2d0f2d602 100644
--- a/drivers/pci/controller/pcie-mobiveil.c
+++ b/drivers/pci/controller/pcie-mobiveil.c
@@ -559,8 +559,9 @@ static int mobiveil_host_init(struct mobiveil_pcie *pcie)
 		if (type) {
 			/* configure outbound translation window */
 			program_ob_windows(pcie, pcie->ob_wins_configured,
-				win->res->start, 0, type,
-				resource_size(win->res));
+					   win->res->start,
+					   win->res->start - win->offset,
+					   type, resource_size(win->res));
 		}
 	}
 
-- 
2.20.1



