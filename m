Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49FD1AC256
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895429AbgDPN1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895423AbgDPN1N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:27:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0466B217D8;
        Thu, 16 Apr 2020 13:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043632;
        bh=VjOqGkCEHfNRK8F13RVyzKzLhBVoJarF1/KtDo/igqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlZOq8Q5ZvoUNeOkAOfNQp/YLyj0MQn59eqcqmBMwbyGmdjiM+4Jd1QukeFlrMmte
         z62PeInMi1yAwUTTkGEfPfX0HyAvCr2Anx78Br7YKTz4Po/fdkihjfl+Nu41YaH2wH
         c0mfYRd5OI2iyJJ6qxNXRaUHcbUH3v4kzVGYupXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/146] cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL
Date:   Thu, 16 Apr 2020 15:22:31 +0200
Message-Id: <20200416131243.952408577@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit 36eb7dc1bd42fe5f850329c893768ff89b696fba ]

imx6ul_opp_check_speed_grading is called for both i.MX6UL and i.MX6ULL.
Since the i.MX6ULL was introduced to a separate ocotp compatible node
later, it is possible that the i.MX6ULL has also dtbs with
"fsl,imx6ull-ocotp". On a system without nvmem-cell speed grade a
missing check on this node causes a driver fail without considering
the cpu speed grade.

This patch prevents unwanted cpu overclocking on i.MX6ULL with compatible
node "fsl,imx6ull-ocotp" in old dtbs without nvmem-cell speed grade.

Fixes: 2733fb0d0699 ("cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull")
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index d8c3595e90236..a0cbbdfc77359 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -310,6 +310,9 @@ static int imx6ul_opp_check_speed_grading(struct device *dev)
 		void __iomem *base;
 
 		np = of_find_compatible_node(NULL, NULL, "fsl,imx6ul-ocotp");
+		if (!np)
+			np = of_find_compatible_node(NULL, NULL,
+						     "fsl,imx6ull-ocotp");
 		if (!np)
 			return -ENOENT;
 
-- 
2.20.1



