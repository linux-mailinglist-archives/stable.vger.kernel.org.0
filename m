Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFDE51A9CC
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357458AbiEDRTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357988AbiEDRPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66837562C9
        for <stable@vger.kernel.org>; Wed,  4 May 2022 09:59:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAFCB61929
        for <stable@vger.kernel.org>; Wed,  4 May 2022 16:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3D9C385B2;
        Wed,  4 May 2022 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651683552;
        bh=LT96guuNvg152REfzRu4VuWsYucKXbF2GmLTt3HTTC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhXtnF7fPwIMxWEVRax+oowziLSf/aHxF9G6b8hPTTQs0/5qhDCOrwE/NtU9gVtqy
         FmuidiHXGV+dxJoPFhLlrgZX4prGStdi8UrZ6fd3UZbkV+ZaBm9oNymhe4fpE+FUTR
         KoGrtjSnjDi+y3vJwugCII05Njsbh9hB07bLhgNnkU5XFJpuNm9dv12y3tR5o6heia
         2dmIxYsDZpEg2ZBP1TKCxtiMfhWMf/v5rdlgzeChAXrNLxJaDSaZGKqqeVJZyPlUHB
         z1ALwgzfpBZal3mp8JlXYzvEgdhzkP9aUqmf/X7CHZqYmdcG2VPoKF4XIxVgSYjX+j
         0MN1ItrvB+OCw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.17 10/19] PCI: aardvark: Enable MSI-X support
Date:   Wed,  4 May 2022 18:58:43 +0200
Message-Id: <20220504165852.30089-11-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504165852.30089-1-kabel@kernel.org>
References: <20220504165852.30089-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 754e449889b22fc3c34235e8836f08f51121d307 upstream.

According to PCI 3.0 specification, sending both MSI and MSI-X interrupts
is done by DWORD memory write operation to doorbell message address. The
write operation for MSI has zero upper 16 bits and the MSI interrupt number
in the lower 16 bits, while the write operation for MSI-X contains a 32-bit
value from MSI-X table.

Since the driver only uses interrupt numbers from range 0..31, the upper
16 bits of the DWORD memory write operation to doorbell message address
are zero even for MSI-X interrupts. Thus we can enable MSI-X interrupts.

Testing proves that kernel can correctly receive MSI-X interrupts from PCIe
cards which supports both MSI and MSI-X interrupts.

Link: https://lore.kernel.org/r/20220110015018.26359-13-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 335655f0c43e..97f50014047a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1337,7 +1337,7 @@ static struct irq_chip advk_msi_irq_chip = {
 
 static struct msi_domain_info advk_msi_domain_info = {
 	.flags	= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-		  MSI_FLAG_MULTI_PCI_MSI,
+		  MSI_FLAG_MULTI_PCI_MSI | MSI_FLAG_PCI_MSIX,
 	.chip	= &advk_msi_irq_chip,
 };
 
-- 
2.35.1

