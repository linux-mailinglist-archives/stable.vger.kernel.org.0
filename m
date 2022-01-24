Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC4749A5B5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371089AbiAYAG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2361415AbiAXXkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:40:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F78C078512;
        Mon, 24 Jan 2022 13:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5045861502;
        Mon, 24 Jan 2022 21:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFFBC340E4;
        Mon, 24 Jan 2022 21:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060309;
        bh=Ewihb/s7hmwafORVRqMeu0MC+lgGBymeShU96pQLBU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+FATGPBITqPMUPhLka/fClfX4WLZXuy8M7RZlqCWBjcAbyrL+d1um89CjkVyaT/H
         t214J0EVRGpjPoC3iT/1b59ej96trrntM0ovYR5SObOpYfi2AEJDMo3q59HHbkW4/i
         PECknk+sOTrWrpU9YBH4101rFXPZEApv/GRcqC68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH 5.16 0872/1039] PCI: xgene: Fix IB window setup
Date:   Mon, 24 Jan 2022 19:44:21 +0100
Message-Id: <20220124184154.612147474@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -465,7 +465,7 @@ static int xgene_pcie_select_ib_reg(u8 *
 		return 1;
 	}
 
-	if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
+	if ((size > SZ_1K) && (size < SZ_4G) && !(*ib_reg_mask & (1 << 0))) {
 		*ib_reg_mask |= (1 << 0);
 		return 0;
 	}


