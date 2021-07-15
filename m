Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397663C98A2
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 08:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhGOGIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 02:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhGOGIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 02:08:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183E8C06175F;
        Wed, 14 Jul 2021 23:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=cDlqF8S6ChV6yjNpdP/3Zdy0rMuV9VvhrElTzLJdMA8=; b=BC1fQlfXce00Iy/0IY+O6VVg3C
        NOZdv0+/segOoof4YTh/Jf/5UCiV2t4GPc1xgr2oZ9D2AFZSVkdGloVgI/HZjQyyh4dN7QTx0DpTE
        vodclCXFLc5MNal+pNG1bphwT5Bg/A6Dzpzuy9/I9OPnua6gv4/sQ8c0NNW1nZz6crJlSnm584a9l
        0aDcZRh3E6GnowFZ41G/jMRCCO6rj/X2g8kcjrrd6Oc0JBpFdBqb6ksXc5x0YWNQKve3f0wbOq2eE
        vsG04rIY47XaFuDdQjGfES5MZ6fIjvasZFkPBMw4BSMGMHz4i1RMTEJPsJI32MI0ZT3oGhBPgJA8X
        obQOnN8g==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3uVB-00HEA7-UF; Thu, 15 Jul 2021 06:05:42 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-edac@vger.kernel.org,
        bowsingbetee <bowsingbetee@protonmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] EDAC/igen6: fix core dependency AGAIN
Date:   Wed, 14 Jul 2021 23:05:39 -0700
Message-Id: <20210715060539.28173-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

My previous patch had a typo/thinko which prevents this driver
from being enabled: change X64_64 to X86_64.

Fixes: 0a9ece9ba154 ("EDAC/igen6: fix core dependency")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-edac@vger.kernel.org
Cc: bowsingbetee <bowsingbetee@protonmail.com>
Cc: stable@vger.kernel.org
---
 drivers/edac/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20210714.orig/drivers/edac/Kconfig
+++ linux-next-20210714/drivers/edac/Kconfig
@@ -271,7 +271,7 @@ config EDAC_PND2
 config EDAC_IGEN6
 	tristate "Intel client SoC Integrated MC"
 	depends on PCI && PCI_MMCONFIG && ARCH_HAVE_NMI_SAFE_CMPXCHG
-	depends on X64_64 && X86_MCE_INTEL
+	depends on X86_64 && X86_MCE_INTEL
 	help
 	  Support for error detection and correction on the Intel
 	  client SoC Integrated Memory Controller using In-Band ECC IP.
