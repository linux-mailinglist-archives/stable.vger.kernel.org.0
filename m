Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825C227C67D
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgI2Lpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbgI2Lpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:45:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB9EB20702;
        Tue, 29 Sep 2020 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379935;
        bh=tLSyyFAiyrfCcpkggBtzpBYmew/kkvwnUWR/5N5vq6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0kndwVPy0T/nUYXL0ni5NKrNQVwuDvOL09AMzZuPFdPp2x38FAYK+Cst81nM2AFz
         RNCO2wVnsNYIGg0vL+BS0P9kw1pq2909yyhpa0WOvF8G/KiM1616/wqga/dXN9DueC
         n23J5I7EJGFo+4RzljNwqVAQuIK7wV6N9GJBiAH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 353/388] nvme-tcp: fix kconfig dependency warning when !CRYPTO
Date:   Tue, 29 Sep 2020 13:01:24 +0200
Message-Id: <20200929110027.552015229@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit af5ad17854f96a6d3c9775e776bd01ab262672a1 ]

When NVME_TCP is enabled and CRYPTO is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for CRYPTO_CRC32C
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - NVME_TCP [=y] && INET [=y] && BLK_DEV_NVME [=y]

The reason is that NVME_TCP selects CRYPTO_CRC32C without depending on or
selecting CRYPTO while CRYPTO_CRC32C is subordinate to CRYPTO.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: 79fd751d61aa ("nvme: tcp: selects CRYPTO_CRC32C for nvme-tcp")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index 2b36f052bfb91..7b3f6555e67ba 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -64,6 +64,7 @@ config NVME_TCP
 	depends on INET
 	depends on BLK_DEV_NVME
 	select NVME_FABRICS
+	select CRYPTO
 	select CRYPTO_CRC32C
 	help
 	  This provides support for the NVMe over Fabrics protocol using
-- 
2.25.1



