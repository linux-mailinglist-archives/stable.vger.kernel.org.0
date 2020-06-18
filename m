Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ECC1FE154
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732596AbgFRBxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730648AbgFRB0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:26:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62B22088E;
        Thu, 18 Jun 2020 01:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443572;
        bh=K8lY8WWpQEzL/M2JXmgJzQ7DejJQt21GSbyKMBj1fUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V7dCFDQBqEVi4XmBsx7h/U4ZGB9cfgCZeOA+PuA/vBcvGbjnzVjYsyDHztmIfoHSi
         aUa0Q9Agb0p1eFntCbIaA0zsrdIJFZkjpfayc0tOliAEw6DNSsPq9/0CqEcS+YIue3
         CSPkISIe4CaIFCPqIAnE7PdfW+y8u7bDa1nIDciE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.14 009/108] ASoC: davinci-mcasp: Fix dma_chan refcnt leak when getting dma type
Date:   Wed, 17 Jun 2020 21:24:21 -0400
Message-Id: <20200618012600.608744-9-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit a697ae6ea56e23397341b027098c1b11d9ab13da ]

davinci_mcasp_get_dma_type() invokes dma_request_chan(), which returns a
reference of the specified dma_chan object to "chan" with increased
refcnt.

When davinci_mcasp_get_dma_type() returns, local variable "chan" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
davinci_mcasp_get_dma_type(). When chan device is NULL, the function
forgets to decrease the refcnt increased by dma_request_chan(), causing
a refcnt leak.

Fix this issue by calling dma_release_channel() when chan device is
NULL.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/1587818916-38730-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/davinci/davinci-mcasp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index e10e03800cce..6991718d7c8a 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -1747,8 +1747,10 @@ static int davinci_mcasp_get_dma_type(struct davinci_mcasp *mcasp)
 				PTR_ERR(chan));
 		return PTR_ERR(chan);
 	}
-	if (WARN_ON(!chan->device || !chan->device->dev))
+	if (WARN_ON(!chan->device || !chan->device->dev)) {
+		dma_release_channel(chan);
 		return -EINVAL;
+	}
 
 	if (chan->device->dev->of_node)
 		ret = of_property_read_string(chan->device->dev->of_node,
-- 
2.25.1

