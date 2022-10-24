Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5360A47C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiJXML0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiJXMKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79D27FE75;
        Mon, 24 Oct 2022 04:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B066B81134;
        Mon, 24 Oct 2022 11:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE69CC433D7;
        Mon, 24 Oct 2022 11:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612321;
        bh=sRESwLM37kyav1ZqzHsIQQZE1DF/iVdBz1Bgkyw1Cks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWAQ50bNlRCfMJ4Amc9d0nytI0dYYrIyAWfQYrBytPdf1MZth4773Wo8lg5Ucn+qa
         FtoBRYyzUxvXp/GVdbWqoFWgMrPh9E5lOaXgFmAQ4btBg9DHa+aSOyGMRPBTZcdW4u
         Oqcksvs1O32qx8yFKohxr57GL4zp9Kl50r6F2IwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 4.14 153/210] powerpc/sysdev/fsl_msi: Add missing of_node_put()
Date:   Mon, 24 Oct 2022 13:31:10 +0200
Message-Id: <20221024113001.943630984@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit def435c04ee984a5f9ed2711b2bfe946936c6a21 ]

In fsl_setup_msi_irqs(), use of_node_put() to drop the reference
returned by of_parse_phandle().

Fixes: 895d603f945ba ("powerpc/fsl_msi: add support for the fsl, msi property in PCI nodes")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220704145233.278539-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/fsl_msi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 44cbf4c12ea1..d43d3d1b27ed 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -216,8 +216,10 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 			dev_err(&pdev->dev,
 				"node %pOF has an invalid fsl,msi phandle %u\n",
 				hose->dn, np->phandle);
+			of_node_put(np);
 			return -EINVAL;
 		}
+		of_node_put(np);
 	}
 
 	for_each_pci_msi_entry(entry, pdev) {
-- 
2.35.1



