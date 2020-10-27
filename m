Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C148629BE3B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794277AbgJ0PK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794268AbgJ0PKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E76D206F4;
        Tue, 27 Oct 2020 15:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811453;
        bh=SALvipUyi/DTcpnTAlrDJ4xTwDPWeOVyPH4/y45TCuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCHqNKR6+2DRsVptbTRSJppAs7we16lteRGYHYtw3xLIqJOQPTJXGv+NyLEsSLhWe
         sU2iUCUERLwOcK+vxe7CRNSsOYEUoZVlx4p0he9Ctn/RZH359MfC408ly02sEywDmM
         MxOBMNttvKhAopjX2n6uTyWeIynJe5IzhRc6VqFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 498/633] soc: qcom: apr: Fixup the error displayed on lookup failure
Date:   Tue, 27 Oct 2020 14:54:01 +0100
Message-Id: <20201027135546.088523548@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit ba34f977c333f96c8acd37ec30e232220399f5a5 ]

APR client incorrectly prints out "ret" variable on pdr_add_lookup failure,
it should be printing the error value returned by the lookup instead.

Fixes: 8347356626028 ("soc: qcom: apr: Add avs/audio tracking functionality")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Link: https://lore.kernel.org/r/20200915154232.27523-1-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/apr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 1f35b097c6356..7abfc8c4fdc72 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -328,7 +328,7 @@ static int of_apr_add_pd_lookups(struct device *dev)
 
 		pds = pdr_add_lookup(apr->pdr, service_name, service_path);
 		if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
-			dev_err(dev, "pdr add lookup failed: %d\n", ret);
+			dev_err(dev, "pdr add lookup failed: %ld\n", PTR_ERR(pds));
 			return PTR_ERR(pds);
 		}
 	}
-- 
2.25.1



