Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19D3CE3E3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhGSPku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347332AbhGSPfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3AD961459;
        Mon, 19 Jul 2021 16:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711140;
        bh=Jzpkyz+4gRX2J8EwvT64vJjTZYiKVCoUS32H0NePBjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FP8/XRRhNLhfTYckAn8ZFmYBpsf7C1SQnlEZFFlOaPMWvxvOq2SN7ngZNtuPUJT87
         1mowaYFJAU+mK4P36Geh7t6BmuwR1FDQxw6DaruPlxLiqYX6g03XvuOV7mq5g4wQw+
         tSLsHLY6+IZO6IMJRYzjCpBeHvKoZJmpFp1H/Iqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suman Anna <s-anna@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 209/351] remoteproc: k3-r5: Fix an error message
Date:   Mon, 19 Jul 2021 16:52:35 +0200
Message-Id: <20210719144951.879223991@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 5cf8d030a1f0..4104e4846dbf 100644
--- a/drivers/remoteproc/ti_k3_r5_remoteproc.c
+++ b/drivers/remoteproc/ti_k3_r5_remoteproc.c
@@ -1272,9 +1272,9 @@ static int k3_r5_core_of_init(struct platform_device *pdev)
 
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



