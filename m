Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04E54522A6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349911AbhKPBPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244243AbhKOTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE41C634A6;
        Mon, 15 Nov 2021 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000366;
        bh=1zNvRbAmzmEwWsT4j4vDl2gW6vUm69UsjwpF0rjnpS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBVdrCM1EGdCy7xMpBdsvSHMGigej4nkiMzaXFGGPmLcZ2q+pCJqw1b473mSu6Pp2
         q6BzDD4dLRv/dzr1/quPxY97Wb8DP0FXr+9yB0JpW3awFC7IJ5HVuo36F7AHcpsfgM
         rm+aYH6S0hBgjoUlABDZgb+4lhjl4rPYIFm26+cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 633/849] soc: qcom: apr: Add of_node_put() before return
Date:   Mon, 15 Nov 2021 18:01:56 +0100
Message-Id: <20211115165441.688118877@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit 72f1aa6205d84337b90b065f602a8fe190821781 ]

Fix following coccicheck warning:

./drivers/soc/qcom/apr.c:485:1-23: WARNING: Function
for_each_child_of_node should have of_node_put() before return

Early exits from for_each_child_of_node should decrement the
node reference counter.

Fixes: 834735662602 ("soc: qcom: apr: Add avs/audio tracking functionality")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211014083017.19714-1-wanjiabing@vivo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/apr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 7abfc8c4fdc72..f736d208362c9 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -323,12 +323,14 @@ static int of_apr_add_pd_lookups(struct device *dev)
 						    1, &service_path);
 		if (ret < 0) {
 			dev_err(dev, "pdr service path missing: %d\n", ret);
+			of_node_put(node);
 			return ret;
 		}
 
 		pds = pdr_add_lookup(apr->pdr, service_name, service_path);
 		if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
 			dev_err(dev, "pdr add lookup failed: %ld\n", PTR_ERR(pds));
+			of_node_put(node);
 			return PTR_ERR(pds);
 		}
 	}
-- 
2.33.0



