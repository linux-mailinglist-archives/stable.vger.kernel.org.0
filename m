Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A7937C898
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234487AbhELQLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238635AbhELQFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7F0861CEF;
        Wed, 12 May 2021 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833681;
        bh=dJpGX4GxHwmRp3krpBZOf73bHOMUg3xCZAoUvie1Vv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEHXLZuWfMoHvD2LNnFXwew5O+cg1mvE2TZKoicUpfdoId5XBKOvXen+3Y8Bofl3F
         DkUqYTJTHAJpFLAUvx9b+pPNMKeSiKo6QnTIy7FB+Lmz6Unv4krtTuDAZj00NBrz6p
         kOz4gtHaEmnIfnYbN7oeUG4dWpnLaSshpB8nFho4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 245/601] soc: qcom: pdr: Fix error return code in pdr_register_listener
Date:   Wed, 12 May 2021 16:45:22 +0200
Message-Id: <20210512144835.901995483@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 769738fc49bb578e05d404b481a9241d18147d86 ]

Fix to return the error code -EREMOTEIO from pdr_register_listener
rather than 0.

Fixes: fbe639b44a82 ("soc: qcom: Introduce Protection Domain Restart helpers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Link: https://lore.kernel.org/r/20201125065034.154217-1-miaoqinglang@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pdr_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/pdr_interface.c b/drivers/soc/qcom/pdr_interface.c
index 209dcdca923f..915d5bc3d46e 100644
--- a/drivers/soc/qcom/pdr_interface.c
+++ b/drivers/soc/qcom/pdr_interface.c
@@ -153,7 +153,7 @@ static int pdr_register_listener(struct pdr_handle *pdr,
 	if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
 		pr_err("PDR: %s register listener failed: 0x%x\n",
 		       pds->service_path, resp.resp.error);
-		return ret;
+		return -EREMOTEIO;
 	}
 
 	pds->state = resp.curr_state;
-- 
2.30.2



