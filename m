Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26296450E6D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhKOSPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240317AbhKOSHe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10EB56330C;
        Mon, 15 Nov 2021 17:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998275;
        bh=1zNvRbAmzmEwWsT4j4vDl2gW6vUm69UsjwpF0rjnpS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zimnvnwk7256/LoTPSIWDiUiJDOcauZc/7K4dNxoc2vXuG0nT0u2Kaxcjbcj1Eosv
         is9qbuE7NgPsQzHi9Ar84+dIEoO1ysEuP5eAdcHW2x5VGjIH02zwMUm+tquswh3JHx
         Wxy8qNm65qIfNpiPQK2QnOC35eD1vZs9Uw/z0eUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wan Jiabing <wanjiabing@vivo.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 451/575] soc: qcom: apr: Add of_node_put() before return
Date:   Mon, 15 Nov 2021 18:02:56 +0100
Message-Id: <20211115165359.348810786@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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



