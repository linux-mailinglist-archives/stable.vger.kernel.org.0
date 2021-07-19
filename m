Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ADF3CE173
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346882AbhGSP0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347835AbhGSPVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:21:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACCD46143B;
        Mon, 19 Jul 2021 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710364;
        bh=H8qgTPdhyT1Kx8rXCvJiWcyjj55kRUNtbwE8zaJvcYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTXIBfO6cupIUGGELpYyy+rC0hI4gqZNIrRm2S3BtutOR14GtIWKrDqbgBW3yTEWa
         iynEd3uTxrbnvM6zZVFCRsc8UPckpuGjrhfEl2e1Um9owP8UAPs6ooFwPMiggZIOCZ
         a3KyUGIp6C9t/42cjWV4Ml8XfYlNZ6UmujFWKHNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/243] remoteproc: k3-r5: Fix an error message
Date:   Mon, 19 Jul 2021 16:53:00 +0200
Message-Id: <20210719144945.788956203@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 34c4da6d5dfba48f49f891ebd75bb55999f0c538 ]

'ret' is known to be 0 here.
Reorder the code so that the expected error code is printed.

Acked-by: Suman Anna <s-anna@ti.com>
Fixes: 6dedbd1d5443 ("remoteproc: k3-r5: Add a remoteproc driver for R5F subsystem")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/d6e29d903b48957bf59c67229d54b0fc215e31ae.1620333870.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/ti_k3_r5_remoteproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/ti_k3_r5_remoteproc.c b/drivers/remoteproc/ti_k3_r5_remoteproc.c
index d9307935441d..afeb9d6e4313 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1202,9 +1202,9 @@ static int k3_r5_core_of_init(struct platform_device *pdev)
 
 	core->tsp = k3_r5_core_of_get_tsp(dev, core->ti_sci);
 	if (IS_ERR(core->tsp)) {
+		ret = PTR_ERR(core->tsp);
 		dev_err(dev, "failed to construct ti-sci proc control, ret = %d\n",
 			ret);
-		ret = PTR_ERR(core->tsp);
 		goto err;
 	}
 
-- 
2.30.2



