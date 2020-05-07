Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42651C9040
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgEGOiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgEGO1s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:27:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7761920936;
        Thu,  7 May 2020 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861668;
        bh=CiUqSGGZ/wftLj2uPpD1velB9FbEfAK86NJmC+dCe74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lipTYIHWbG5X2Zqg8Kk5Z7y/uerSBYPnV5n6Hik38MKzkei3oBaGmjH3jKOjhUwXg
         eba2+7vBXJNKpmbeHy0rU+/1Ky3KYCxdMWCCzKH0/KlyVQLTYLYIbDv+qkZ0n9YGVK
         XU0tVSAMP/6/o5bt7xk6Tk8+0ZuxOpK8OG4Av66k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 17/50] dmaengine: mmp_tdma: Do not ignore slave config validation errors
Date:   Thu,  7 May 2020 10:26:53 -0400
Message-Id: <20200507142726.25751-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142726.25751-1-sashal@kernel.org>
References: <20200507142726.25751-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 363c32701c7fdc8265a84b21a6a4f45d1202b9ca ]

With an invalid dma_slave_config set previously,
mmp_tdma_prep_dma_cyclic() would detect an error whilst configuring the
channel, but proceed happily on:

  [  120.756530] mmp-tdma d42a0800.adma: mmp_tdma: unknown burst size.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://lore.kernel.org/r/20200419164912.670973-2-lkundrak@v3.sk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_tdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index 10117f271b12b..51e08c16756ae 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -443,7 +443,8 @@ static struct dma_async_tx_descriptor *mmp_tdma_prep_dma_cyclic(
 	if (!desc)
 		goto err_out;
 
-	mmp_tdma_config_write(chan, direction, &tdmac->slave_config);
+	if (mmp_tdma_config_write(chan, direction, &tdmac->slave_config))
+		goto err_out;
 
 	while (buf < buf_len) {
 		desc = &tdmac->desc_arr[i];
-- 
2.20.1

