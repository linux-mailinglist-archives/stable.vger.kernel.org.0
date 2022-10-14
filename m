Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DD55FEFBF
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiJNOHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiJNOHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:07:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AEC647F0;
        Fri, 14 Oct 2022 07:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D90A4B82356;
        Fri, 14 Oct 2022 13:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456E2C4347C;
        Fri, 14 Oct 2022 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755708;
        bh=N7qjOu8AM4o2tEFVFWLtqsDSfSJXOTnsmwUIOChiYk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkTrXLYUALuU6/9hlVAxeteCsotkWKIIc4NQXf5qRQn/7mAnTvwifd3Kuczr9oIU+
         aM2f2vRy2wQGU4NFG87BLraK05CQDfzGfn45iQ4rbRyal/w3f5SnWG6hK4cKwWi0no
         2tItU2V4wg+9tbwIuBZ8WxUfO7v8CifF7/2R22uVDYEqmyagTZNerxwv5cGXPzRgZF
         xqp4b0jNW92jf5b7hF7KyZ+zEfMv7aUnpyK4WgbhXFn64JicYfEJOk3kP/HuH9OCJN
         XkTL0HifctEjU8PL2jki4welqKb/u/iPqJ6MmGGmUhJwi3pmdhnbpp1EEj8G5jCBYU
         Y6wKimWxeDxKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, oss@buserror.net,
        nathan@kernel.org, ndesaulniers@google.com, Julia.Lawall@inria.fr,
        christophe.leroy@csgroup.eu, nick.child@ibm.com,
        linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 2/3] powerpc/85xx: Fix fall-through warning for Clang
Date:   Fri, 14 Oct 2022 09:54:59 -0400
Message-Id: <20221014135502.2110218-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135502.2110218-1-sashal@kernel.org>
References: <20221014135502.2110218-1-sashal@kernel.org>
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

