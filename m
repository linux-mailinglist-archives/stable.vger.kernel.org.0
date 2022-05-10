Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29325521995
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiEJNtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245045AbiEJNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A432F38D;
        Tue, 10 May 2022 06:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE64615C8;
        Tue, 10 May 2022 13:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1066EC385A6;
        Tue, 10 May 2022 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189654;
        bh=WppGhgcPB+6oY6QJ8p+yvs4P6oEjc6aM7RIGjBre9Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2k1cwXWIwixpC9nV8dLlKRIvRlglzc1+ei2RrgTaD6gsm5y8746bwdUvxjuSVsWU2
         GfYJ5UwPk7i4OqoQmNIQF8IOjnrsSfWrrsK0Puoc4cb3r/ZG085KKLu+/RsVo3oe55
         GqGpR94bD5U6qrn0uUpPQF4WKCs53L0GM4rD0Kq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, pali@kernel.org,
        =?UTF-8?q?Marek=20Beh=FAn?= <kabel@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: [PATCH 5.15 119/135] PCI: aardvark: Check return value of generic_handle_domain_irq() when processing INTx IRQ
Date:   Tue, 10 May 2022 15:08:21 +0200
Message-Id: <20220510130743.812198606@linuxfoundation.org>
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

commit 51f96e287c6f003d3bb29672811c757c5fbf0028 upstream.

It is possible that we receive spurious INTx interrupt. Check for the
return value of generic_handle_domain_irq() when processing INTx IRQ.

Link: https://lore.kernel.org/r/20220110015018.26359-6-kabel@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1429,7 +1429,9 @@ static void advk_pcie_handle_int(struct
 		advk_writel(pcie, PCIE_ISR1_INTX_ASSERT(i),
 			    PCIE_ISR1_REG);
 
-		generic_handle_domain_irq(pcie->irq_domain, i);
+		if (generic_handle_domain_irq(pcie->irq_domain, i) == -EINVAL)
+			dev_err_ratelimited(&pcie->pdev->dev, "unexpected INT%c IRQ\n",
+					    (char)i + 'A');
 	}
 }
 


