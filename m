Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5387037CC32
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhELQnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242898AbhELQgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5683761E0E;
        Wed, 12 May 2021 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835207;
        bh=NkI9tKsCjEBQ9DZg70ji3ChaVjpIDKEPc221Y9KcnEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvjfZlR3vQijyZwUhAPuFq8dVLxtKJ0PAk8n4Qay/NZtK6npypW0xsTipC+zBet3d
         Dvta5IjDzDIbWmQF/6NsmNYuiy2PQw0FydJyGhBz6Ll3yrmI9Fy8GNoJZ/H6k1DSnB
         54TEpuNtu0SvVfJYQ9rXO8FoIAK/LU/+vqP47A6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 251/677] nvmem: rmem: fix undefined reference to memremap
Date:   Wed, 12 May 2021 16:44:57 +0200
Message-Id: <20210512144845.571016014@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit cc1bc56fdc76a55bb8fae9a145a2e60bf22fb129 ]

Fix below error reporte by kernel test robot
rmem.c:(.text+0x14e): undefined reference to memremap
s390x-linux-gnu-ld: rmem.c:(.text+0x1b6): undefined reference to memunmap

Fixes: 5a3fa75a4d9c ("nvmem: Add driver to expose reserved memory as nvmem")
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210330111241.19401-9-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
index 75d2594c16e1..267a0d9e99ba 100644
--- a/drivers/nvmem/Kconfig
+++ b/drivers/nvmem/Kconfig
@@ -272,6 +272,7 @@ config SPRD_EFUSE
 
 config NVMEM_RMEM
 	tristate "Reserved Memory Based Driver Support"
+	depends on HAS_IOMEM
 	help
 	  This driver maps reserved memory into an nvmem device. It might be
 	  useful to expose information left by firmware in memory.
-- 
2.30.2



