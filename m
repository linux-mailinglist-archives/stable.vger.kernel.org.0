Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A55C4172E6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344601AbhIXMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:45884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344605AbhIXMvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:51:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FD9B61267;
        Fri, 24 Sep 2021 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487721;
        bh=LAf6IzOOzjxdsLPg39cVEW/B3C6fNmMHAn+wXXxCdX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWnMKIn2TvtjXj3WRqGtUjTlxBCZu1eC7Tbp4nqwpVaJVorKP8kwaNkqh7AlGM5Qo
         vpH9dhuJh9rC0s9oOrfjrp75bsEebhY9v/OvcZ05SC/MscIF/oeo04qeqJ4muDoMqp
         69qilPwVHgs20HO1zVRrux8YV8/hs1a1f9xwNEqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/34] dmaengine: ioat: depends on !UML
Date:   Fri, 24 Sep 2021 14:44:15 +0200
Message-Id: <20210924124330.655265659@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbac7a92a46f0876e588722ebe552ddfe6fd790f ]

Now that UML has PCI support, this driver must depend also on
!UML since it pokes at X86_64 architecture internals that don't
exist on ARCH=um.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20210809112409.a3a0974874d2.I2ffe3d11ed37f735da2f39884a74c953b258b995@changeid
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 52dd4bd7c209..e5f31af65aab 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -266,7 +266,7 @@ config INTEL_IDMA64
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
-- 
2.33.0



