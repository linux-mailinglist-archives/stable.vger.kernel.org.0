Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5E417518
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345282AbhIXNO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346490AbhIXNL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBF7D613A8;
        Fri, 24 Sep 2021 12:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488322;
        bh=Y0f0Pibw7SBJ8caTpqBP5W+WFggm45xiI3FSy4UACiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNYaJmM/ZkPkxRhxrdgSxHe5embVOh3MrCTgGBPzoVGgV0Knb+jItJwYlJqA8QHZx
         ZWxf9ZWV2j2/12nSdcdfAtAOKw1bcfaJWl7iTpd7ml07Ujhz6HMsxW75Uc/7Jd2jGn
         Ie0h45ygvfRVVzEht5bkne40tSOb5txKVSnf8yE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/63] dmaengine: idxd: depends on !UML
Date:   Fri, 24 Sep 2021 14:44:40 +0200
Message-Id: <20210924124335.648507936@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b2296eeac91555bd13f774efa7ab7d4b12fb71ef ]

Now that UML has PCI support, this driver must depend also on
!UML since it pokes at X86_64 architecture internals that don't
exist on ARCH=um.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://lore.kernel.org/r/20210625103810.fe877ae0aef4.If240438e3f50ae226f3f755fc46ea498c6858393@changeid
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f28bb2334e74..3a745e8a0f42 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -285,7 +285,7 @@ config INTEL_IDMA64
 
 config INTEL_IDXD
 	tristate "Intel Data Accelerators support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	depends on PCI_MSI
 	depends on SBITMAP
 	select DMA_ENGINE
-- 
2.33.0



