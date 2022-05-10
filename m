Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4349B521A05
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242291AbiEJNxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245035AbiEJNrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935CB1129;
        Tue, 10 May 2022 06:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52153B81DA8;
        Tue, 10 May 2022 13:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF25C385C6;
        Tue, 10 May 2022 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189635;
        bh=wanXBFBMvo4f6xsGrejBhU1faAyCKsaswbL92SCiLYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEwzqsXbNTGKB4758+b62yF8pxQI7JF1lKzqfudjA6ia1VQVXKSO0FP8EY00aCRB3
         Hp/FQxnroO/buQIYCpJutEVpEd1nrhkHiZjaw8pgJxE4BGp2Rd0xcFsm5A4QylSKS0
         0afRkffbnd6CCUM285Jpm9fZe7eFRmpylO7j0ss4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 113/135] PCI: aardvark: Fix memory leak in driver unbind
Date:   Tue, 10 May 2022 15:08:15 +0200
Message-Id: <20220510130743.644904693@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 2f040a17f5061457ae95035326d3159eddc1e5cc upstream.

Free config space for emulated root bridge when unbinding driver to fix
memory leak. Do it after disabling and masking all interrupts, since
aardvark interrupt handler accesses config space of emulated root
bridge.

Link: https://lore.kernel.org/r/20211130172913.9727-9-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1718,6 +1718,9 @@ static int advk_pcie_remove(struct platf
 	advk_pcie_remove_msi_irq_domain(pcie);
 	advk_pcie_remove_irq_domain(pcie);
 
+	/* Free config space for emulated root bridge */
+	pci_bridge_emul_cleanup(&pcie->bridge);
+
 	/* Disable outbound address windows mapping */
 	for (i = 0; i < OB_WIN_COUNT; i++)
 		advk_pcie_disable_ob_win(pcie, i);


