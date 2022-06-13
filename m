Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0F75490E8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352654AbiFMLSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352406AbiFMLQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5133513FB2;
        Mon, 13 Jun 2022 03:40:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3EDE611AD;
        Mon, 13 Jun 2022 10:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E51C36B00;
        Mon, 13 Jun 2022 10:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116802;
        bh=/KA418GLVD+9TzUQqWQ1Xutqsaeu0rJn2Am7XBzKav8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sstcZuv/exFYagTJyQKo4drym8HjpQhl3kBG+m8tpQdkiHnX5/ZotYtfGr4HEAD2e
         Qc33j0kwrwlZqyAD9mQOwOchqjUItQ0kguZ8cE5grPrUJ1qD4fzGIpTibOtqbFWmwR
         iXR76d9RhAjYzFrsKzXzDllGtCxaj4KdRr7zeoYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/411] macintosh: via-pmu and via-cuda need RTC_LIB
Date:   Mon, 13 Jun 2022 12:07:43 +0200
Message-Id: <20220613094934.358068710@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9a9c5ff5fff87eb1a43db0d899473554e408fd7b ]

Fix build when RTC_LIB is not set/enabled.
Eliminates these build errors:

m68k-linux-ld: drivers/macintosh/via-pmu.o: in function `pmu_set_rtc_time':
drivers/macintosh/via-pmu.c:1769: undefined reference to `rtc_tm_to_time64'
m68k-linux-ld: drivers/macintosh/via-cuda.o: in function `cuda_set_rtc_time':
drivers/macintosh/via-cuda.c:797: undefined reference to `rtc_tm_to_time64'

Fixes: 0792a2c8e0bb ("macintosh: Use common code to access RTC")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220410161035.592-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/macintosh/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index abaf1401cca6..b5a534206edd 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -44,6 +44,7 @@ config ADB_IOP
 config ADB_CUDA
 	bool "Support for Cuda/Egret based Macs and PowerMacs"
 	depends on (ADB || PPC_PMAC) && !PPC_PMAC64
+	select RTC_LIB
 	help
 	  This provides support for Cuda/Egret based Macintosh and
 	  Power Macintosh systems. This includes most m68k based Macs,
@@ -57,6 +58,7 @@ config ADB_CUDA
 config ADB_PMU
 	bool "Support for PMU based PowerMacs and PowerBooks"
 	depends on PPC_PMAC || MAC
+	select RTC_LIB
 	help
 	  On PowerBooks, iBooks, and recent iMacs and Power Macintoshes, the
 	  PMU is an embedded microprocessor whose primary function is to
-- 
2.35.1



