Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC02E408F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501935AbgL1OSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441570AbgL1OSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25FF220791;
        Mon, 28 Dec 2020 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165087;
        bh=mUGHk6r51IylLfP0yvXyk94WqmWSN719DKhiODtC8XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nS0yzGYIC8cuALlf5MqqLRvT+k1ghSS9FahYLEne+AriYNu5By/l9Uk49qIS/ujZv
         FPsbwX/FjR80XVwN5g9lbY7ZMv2N+hdLcGzsWk7teJOfvTjGHhAFKrwRA81ePnpli7
         k9UoafUwiVO1e4DDg6dFkqWZYSTS8B8PH9U0jZlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 405/717] remoteproc/mediatek: unprepare clk if scp_before_load fails
Date:   Mon, 28 Dec 2020 13:46:43 +0100
Message-Id: <20201228125040.393149541@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 22c3df6f5574c8d401ea431c7ce24e7c5c5e7ef3 ]

Fixes the error handling to unprepare clk if scp_before_load fails.

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: fd0b6c1ff85a ("remoteproc/mediatek: Add support for mt8192 SCP")
Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20201203155914.3844426-1-tzungbi@google.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index f74f22d4d1ffc..52fa01d67c18e 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -350,9 +350,10 @@ static int scp_load(struct rproc *rproc, const struct firmware *fw)
 
 	ret = scp->data->scp_before_load(scp);
 	if (ret < 0)
-		return ret;
+		goto leave;
 
 	ret = scp_elf_load_segments(rproc, fw);
+leave:
 	clk_disable_unprepare(scp->clk);
 
 	return ret;
-- 
2.27.0



