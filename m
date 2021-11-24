Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8042145C599
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350562AbhKXN71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353091AbhKXN4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:56:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EC3B6338B;
        Wed, 24 Nov 2021 13:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759228;
        bh=VDGr8mG1mvdKL/VohV5GCHGEPqaZgeHXP+LwAow2Bi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWeUWS/z79mlyWRBTd64t1RuGWemRYC+L4Ucv5eox49mViEA5J/kql2IX3O0NP+3r
         T2uCXtbEPfs52kuzKSoFCtof1gXAp0nvh8wJAitmcNpwN5Iqs5E1G7HoRJDTUsJSH3
         KAPzlXNU3DHTzNBw/EAgcOewvBy3yaPASwhh9Q0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Marcin Wojtas <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/279] net: mvmdio: fix compilation warning
Date:   Wed, 24 Nov 2021 12:57:23 +0100
Message-Id: <20211124115724.158878159@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcin Wojtas <mw@semihalf.com>

[ Upstream commit 2460386bef0b9b98b71728d3c173e15558b78d82 ]

The kernel test robot reported a following issue:

>> drivers/net/ethernet/marvell/mvmdio.c:426:36: warning:
unused variable 'orion_mdio_acpi_match' [-Wunused-const-variable]
   static const struct acpi_device_id orion_mdio_acpi_match[] = {
                                      ^
   1 warning generated.

Fix that by surrounding the variable by appropriate ifdef.

Fixes: c54da4c1acb1 ("net: mvmdio: add ACPI support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Marcin Wojtas <mw@semihalf.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20211115153024.209083-1-mw@semihalf.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvmdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 62a97c46fba05..ef878973b8597 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -429,12 +429,14 @@ static const struct of_device_id orion_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, orion_mdio_match);
 
+#ifdef CONFIG_ACPI
 static const struct acpi_device_id orion_mdio_acpi_match[] = {
 	{ "MRVL0100", BUS_TYPE_SMI },
 	{ "MRVL0101", BUS_TYPE_XSMI },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, orion_mdio_acpi_match);
+#endif
 
 static struct platform_driver orion_mdio_driver = {
 	.probe = orion_mdio_probe,
-- 
2.33.0



