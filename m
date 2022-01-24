Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8CF499539
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392461AbiAXUvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:51:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46062 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390191AbiAXUpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:45:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15CC6B81218;
        Mon, 24 Jan 2022 20:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A500C340E5;
        Mon, 24 Jan 2022 20:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057096;
        bh=ucs4b6QzXOxOc1YICXU0kEQvXUrqmGp6H4umnOvh/+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozD0Z8Nz6hFjbp996eVDqvwxP53beMTdjZZZ0pwJLRiEOkOvMAN7xfVSTtvWx8rP3
         nGRbNZb+MaDFDkvYS9uTmM26+9vQTSvsyPLoVR+CMBr5elkMvv9kiYvCmVfGh2suJN
         YwXo5PFkJSXXW5yyAUz8JWJWTf5TD+KvL0cxHF1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH 5.15 700/846] PCI: xgene: Fix IB window setup
Date:   Mon, 24 Jan 2022 19:43:37 +0100
Message-Id: <20220124184125.203088385@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

commit c7a75d07827a1f33d566e18e6098379cc2a0c2b2 upstream.

Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
broke PCI support on XGene. The cause is the IB resources are now sorted
in address order instead of being in DT dma-ranges order. The result is
which inbound registers are used for each region are swapped. I don't
know the details about this h/w, but it appears that IB region 0
registers can't handle a size greater than 4GB. In any case, limiting
the size for region 0 is enough to get back to the original assignment
of dma-ranges to regions.

Link: https://lore.kernel.org/all/CA+enf=v9rY_xnZML01oEgKLmvY1NGBUUhnSJaETmXtDtXfaczA@mail.gmail.com/
Link: https://lore.kernel.org/r/20211129173637.303201-1-robh@kernel.org
Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
Reported-by: Stéphane Graber <stgraber@ubuntu.com>
Tested-by: Stéphane Graber <stgraber@ubuntu.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-xgene.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -466,7 +466,7 @@ static int xgene_pcie_select_ib_reg(u8 *
 		return 1;
 	}
 
-	if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
+	if ((size > SZ_1K) && (size < SZ_4G) && !(*ib_reg_mask & (1 << 0))) {
 		*ib_reg_mask |= (1 << 0);
 		return 0;
 	}


