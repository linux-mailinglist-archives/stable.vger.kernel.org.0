Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1B1177DDB
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 18:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgCCRob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbgCCRob (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:44:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AD1C20870;
        Tue,  3 Mar 2020 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257470;
        bh=xJaPOEMtNwqvbSQdzQQceUOZ4lUwtok76L2WrtwFr6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNTc93C9ESTHapz8tgC8R1CPQNusxIRcAqTvfgpcAY7XffBbTJGzaGwxShiuae+NU
         disn7pWHbeBIfWjmaB82av2PJRV4tIDGC9GEW7tQUYRcSMdXRkE6NYtIIlghBd9fR8
         9J6sJhvrLpKV9q1mEzL0tLqtzgAZnaICTA8aQV3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aristeu Rozanski <aris@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 001/176] EDAC: skx_common: downgrade message importance on missing PCI device
Date:   Tue,  3 Mar 2020 18:41:05 +0100
Message-Id: <20200303174304.758365569@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

[ Upstream commit 854bb48018d5da261d438b2232fa683bdb553979 ]

Both skx_edac and i10nm_edac drivers are loaded based on the matching CPU being
available which leads the module to be automatically loaded in virtual machines
as well. That will fail due the missing PCI devices. In both drivers the first
function to make use of the PCI devices is skx_get_hi_lo() will simply print

	EDAC skx: Can't get tolm/tohm

for each CPU core, which is noisy. This patch makes it a debug message.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20191204212325.c4k47p5hrnn3vpb5@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 95662a4ff4c4f..99bbaf629b8d9 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -256,7 +256,7 @@ int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm)
 
 	pdev = pci_get_device(PCI_VENDOR_ID_INTEL, did, NULL);
 	if (!pdev) {
-		skx_printk(KERN_ERR, "Can't get tolm/tohm\n");
+		edac_dbg(2, "Can't get tolm/tohm\n");
 		return -ENODEV;
 	}
 
-- 
2.20.1



