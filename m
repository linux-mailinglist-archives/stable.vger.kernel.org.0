Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03CF1C8FD0
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgEGOfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:35:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbgEGO2r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6B84208DB;
        Thu,  7 May 2020 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861726;
        bh=vjM1O94rgx2tx7HK6gBqTpJ9GjaQq+alA5IdlOKPtJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2FMk5mOkmYwVySTCS9Q1BB8tH52b8+iAInF/vdHOWAegIFSgKc2j188WC9rSuvap
         cnZ4xLkHBPG0wn6AE7kR6B6yADvzewFFnEOZJioR94R5dmlW30/zBdmxngM8pSWif6
         afAKMRmoV5qMFN33xW/bVSlznIcpfYVvYzEb9sBM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lubomir Rintel <lkundrak@v3.sk>, Vinod Koul <vkoul@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/35] dmaengine: mmp_tdma: Do not ignore slave config validation errors
Date:   Thu,  7 May 2020 10:28:06 -0400
Message-Id: <20200507142830.26239-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
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
index e7d1e12bf4643..4d5b987e4841a 100644
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

