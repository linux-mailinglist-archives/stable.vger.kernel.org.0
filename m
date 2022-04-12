Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804244FD46A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352271AbiDLHXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353936AbiDLHQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:16:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775B42499;
        Mon, 11 Apr 2022 23:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6B7060EEB;
        Tue, 12 Apr 2022 06:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0214AC385A6;
        Tue, 12 Apr 2022 06:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746666;
        bh=rQ1sIUJmPcKMjONAfGVjnlPTe+lzGwpPriP4zODIReU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8/4x76xylE/UZ55zV4hJHp96TXrNDrr9zGXkDUg3jRoCLzrbQPhCFrwy1L0aRYOy
         uB0PT/l/8+y9WwhPTr/KwD/ap3+G/eMW8JEp4RVrMZCqDSTa+dlBXDbRCf3hJ/DXqk
         UOj8LhGrpt/8mrLWm41LTPtkk/eCSviEVeFUxqzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Chen <lchen@ambarella.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 088/285] PCI: endpoint: Fix misused goto label
Date:   Tue, 12 Apr 2022 08:29:05 +0200
Message-Id: <20220412062946.203200527@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Chen <lchen@ambarella.com>

[ Upstream commit bf8d87c076f55b8b4dfdb6bc6c6b6dc0c2ccb487 ]

Fix a misused goto label jump since that can result in a memory leak.

Link: https://lore.kernel.org/r/17e7b9b9ee6.c6d9c6a02564.4545388417402742326@zohomail.com
Signed-off-by: Li Chen <lchen@ambarella.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index c7e45633beaf..5b833f00e980 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -451,7 +451,7 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 		if (!epf_test->dma_supported) {
 			dev_err(dev, "Cannot transfer data using DMA\n");
 			ret = -EINVAL;
-			goto err_map_addr;
+			goto err_dma_map;
 		}
 
 		src_phys_addr = dma_map_single(dma_dev, buf, reg->size,
-- 
2.35.1



