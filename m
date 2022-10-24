Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486A560B03F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiJXQD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiJXQCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:02:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279B8115413;
        Mon, 24 Oct 2022 07:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E596B811C4;
        Mon, 24 Oct 2022 12:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038DCC433C1;
        Mon, 24 Oct 2022 12:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614447;
        bh=FpXhnLqOG5Yvh/g9j3Y6llbNQVhcq7oq+QMST9zMdbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYEC5txFK/haofjp+RU6au5pStmmcZjh9p9GJCxrK+6aJmJ1F6i6dgzAbpYI0MfLb
         htLzCfe/OldawfMhhsOHXZ6dNA9U5QccpWdv/UBLETd05SNOBwy41nOF6/qTUHSzEt
         ttBoSC9580czCNyf423X2GEpYypm2jx8zZ/NWQKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.10 265/390] powerpc/sysdev/fsl_msi: Add missing of_node_put()
Date:   Mon, 24 Oct 2022 13:31:02 +0200
Message-Id: <20221024113034.188404880@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
index 808e7118abfc..d276c5e96445 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -211,8 +211,10 @@ static int fsl_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
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



