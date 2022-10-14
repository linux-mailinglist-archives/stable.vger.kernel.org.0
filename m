Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0F45FEF8F
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiJNOCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiJNOBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:01:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1777E8C6B;
        Fri, 14 Oct 2022 07:01:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63EED61B16;
        Fri, 14 Oct 2022 13:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C05FC433D6;
        Fri, 14 Oct 2022 13:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755694;
        bh=N7qjOu8AM4o2tEFVFWLtqsDSfSJXOTnsmwUIOChiYk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNDJOAoAAm8+hOfY2uYyAJujEnSDwITjQfjReVQzoC0yEaU6cffnc6OGzpdwVkjQX
         DCSckziW71BnQL8mmbJwFqTzXfUOfDolkQSbPdPi7QB4ktToOrgcASEV6oH2IDWg7x
         wwrcSUbg6vpHa81dwpa+uDNDG5ROBIEUzH5kIK33L1fPxjoHB+E2+bqjvhvmnReCj/
         blNJBbiieF9bqeaDhjNvUASzU2NVDqPVfKidQEBHL7gphwppPjVcwAl5B+wM7aEFA1
         zd+/z9Mx3Ge+rPexs8TFfKK6LSp7mBG7btfabY9mjTdj5XIh30ZSxFyvrV9ILapOBK
         ZADyIvFwvHm1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, oss@buserror.net,
        nathan@kernel.org, ndesaulniers@google.com,
        christophe.leroy@csgroup.eu, Julia.Lawall@inria.fr,
        nick.child@ibm.com, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.14 2/4] powerpc/85xx: Fix fall-through warning for Clang
Date:   Fri, 14 Oct 2022 09:54:45 -0400
Message-Id: <20221014135448.2110152-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135448.2110152-1-sashal@kernel.org>
References: <20221014135448.2110152-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit d4d944ff68cb1f896d3f3b1af0bc656949dc626a ]

Fix the following fallthrough warning:

arch/powerpc/platforms/85xx/mpc85xx_cds.c:161:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/KSPP/linux/issues/198
Link: https://lore.kernel.org/lkml/202209061224.KxORRGVg-lkp@intel.com/
Link: https://lore.kernel.org/r/Yxe8XTY5C9qJLd0Z@work
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/85xx/mpc85xx_cds.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 224db30c497b..b3736b835c10 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -162,6 +162,7 @@ static void __init mpc85xx_cds_pci_irq_fixup(struct pci_dev *dev)
 			else
 				dev->irq = 10;
 			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
+			break;
 		default:
 			break;
 		}
-- 
2.35.1

