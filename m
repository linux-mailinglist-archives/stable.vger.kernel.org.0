Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC00582CA0
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbiG0Qsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiG0QsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:48:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCFB606A2;
        Wed, 27 Jul 2022 09:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67306619FF;
        Wed, 27 Jul 2022 16:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B724C433C1;
        Wed, 27 Jul 2022 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939535;
        bh=CLfupA+ve829J+GGA8oCBo4IjFXt4oHO4dQK627Iol0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rg9ygTRYGpaGU09O3zvVOjTCHDj33qO8U2R8GQs69RGaARCNIiPKwCHdXVQiQtJjB
         ywjjQSptiCL51Wm6/OZkrK25r8IIPZddb9MjZLWpBqwP5MtAckE7Om7zj73GtgKck2
         k3JBbVwMIbq46hkyhfuPNDv4abAnAswc+RC+FwnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/105] Revert "m68knommu: only set CONFIG_ISA_DMA_API for ColdFire sub-arch"
Date:   Wed, 27 Jul 2022 18:10:02 +0200
Message-Id: <20220727161012.728484473@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 87ae522e467e17a13b796e2cb595f9c3943e4d5e which is
commit db87db65c1059f3be04506d122f8ec9b2fa3b05e upstream.

It is not needed in 5.10.y and causes problems.

Link: https://lore.kernel.org/r/CAK8P3a0vZrXxNp3YhrxFjFunHgxSZBKD9Y4darSODgeFAukCeQ@mail.gmail.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/m68k/Kconfig.bus |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/Kconfig.bus
+++ b/arch/m68k/Kconfig.bus
@@ -63,7 +63,7 @@ source "drivers/zorro/Kconfig"
 
 endif
 
-if COLDFIRE
+if !MMU
 
 config ISA_DMA_API
 	def_bool !M5272


