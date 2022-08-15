Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D925946AF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiHOXAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352535AbiHOW6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0770474DD;
        Mon, 15 Aug 2022 12:57:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E38C6113B;
        Mon, 15 Aug 2022 19:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D98CC433C1;
        Mon, 15 Aug 2022 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593430;
        bh=HkyYOrUZNw75qiukQT9RI/l054amCsbfshAfs8CsLRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCjE4EVhVL7f/3Hh8TujHuozfA3iAd4Wr6ML7bFjsJVH6QBWrQ6jnNCNuDM86p8Zk
         Ck9MWNwpHxACMxwy5+CPyrRWl+tvD/JpLfjRMRggyIBPYgNQO43l+q8Gz0dKPO2fuj
         J7euA8ABUnvHs/i8GqBT7j9aNTh27Kvn7bYZ3IRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0945/1095] powerpc/64e: Fix kexec build error
Date:   Mon, 15 Aug 2022 20:05:44 +0200
Message-Id: <20220815180508.249952130@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 4cfa6ff24a9744ba484521c38bea613134fbfcb3 ]

When building ppc64_book3e_allmodconfig the build fails with:

  arch/powerpc/kexec/file_load_64.c:1063:14: error: implicit declaration of function ‘firmware_has_feature’
   1063 |         if (!firmware_has_feature(FW_FEATURE_LPAR))
        |              ^~~~~~~~~~~~~~~~~~~~

Add a direct include of asm/firmware.h to fix the error.

Fixes: b1fc44eaa9ba ("pseries/iommu/ddw: Fix kdump to work in absence of ibm,dma-window")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220803063152.1249270-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 5d2c22aa34fb..683462e4556b 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -23,6 +23,7 @@
 #include <linux/vmalloc.h>
 #include <asm/setup.h>
 #include <asm/drmem.h>
+#include <asm/firmware.h>
 #include <asm/kexec_ranges.h>
 #include <asm/crashdump-ppc64.h>
 
-- 
2.35.1



