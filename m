Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97700541E4B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381676AbiFGW2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385260AbiFGW0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F23270428;
        Tue,  7 Jun 2022 12:23:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B48FE60BA5;
        Tue,  7 Jun 2022 19:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEAFC385A2;
        Tue,  7 Jun 2022 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629786;
        bh=WXRcVCPP2UKRCYY2jK+D9kxdNOkgPnIo2N2sDgEC/Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAfe5ZSyX26BqPN09JgplT2Bhy1gxxcaBE9hryuVNo+ApUHDE2fiqW9gLzdK0pHjM
         VjNz6VkSQrwY2wZlWxWr/OOz5YVkHEx9LXEeCcQxfAuHknNeMZk0pftvA/gPq52zpW
         JYytd31U2fKtJKGZU0dGf+/TywX350vovQmBe7ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.18 817/879] um: Use asm-generic/dma-mapping.h
Date:   Tue,  7 Jun 2022 19:05:35 +0200
Message-Id: <20220607165026.568459082@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 365719035526e8eda214a1cedb2e1c96e969a0d7 upstream.

If DMA (PCI over virtio) is enabled, then some drivers may
enable CONFIG_DMA_OPS as well, and then we pull in the x86
definition of get_arch_dma_ops(), which uses the dma_ops
symbol, which isn't defined.

Since we don't have real DMA ops nor any kind of IOMMU fix
this in the simplest possible way: pull in the asm-generic
file instead of inheriting the x86 one. It's not clear why
those drivers that do (e.g. VDPA) "select DMA_OPS", and if
they'd even work with this, but chances are nobody will be
wanting to do that anyway, so fixing the build failure is
good enough.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/asm/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += bug.h
 generic-y += compat.h
 generic-y += current.h
 generic-y += device.h
+generic-y += dma-mapping.h
 generic-y += emergency-restart.h
 generic-y += exec.h
 generic-y += extable.h


