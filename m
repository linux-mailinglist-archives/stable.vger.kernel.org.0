Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE613CE3DC
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236405AbhGSPkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344014AbhGSPeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:34:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851D261448;
        Mon, 19 Jul 2021 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711108;
        bh=eOGk8YDpWuQYhIoUBK3Mkqt0wqJwgjmOt+sz2ZIs3Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4MQBF0x/vj1+0LSb66ys0xyv1lMXeRs//wWR0sX6ZPqah/KRGk3N2LJbHByXI7E8
         qHxyxCWN+rfD4jYgdrTg29t+GrGOdf421Ed7V/firAQYkfsZdIet0Am8zjRo05UzRn
         tK7tU5MmKsiyBwKt5YIIkAKLXE8DXmNyLOYzZRfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 203/351] cpufreq: scmi: Fix an error message
Date:   Mon, 19 Jul 2021 16:52:29 +0200
Message-Id: <20210719144951.685820454@linuxfoundation.org>
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

[ Upstream commit b791c7f94680ba9b60b0c0786b1d0eb4393053d6 ]

'ret' is known to be 0 here.
The last error code is stored in 'nr_opp', so use it in the error message.

Fixes: 71a37cd6a59d ("scmi-cpufreq: Remove deferred probe")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index c8a4364ad3c2..ec9a87ca2dbb 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -174,7 +174,7 @@ static int scmi_cpufreq_init(struct cpufreq_policy *policy)
 		nr_opp = dev_pm_opp_get_opp_count(cpu_dev);
 		if (nr_opp <= 0) {
 			dev_err(cpu_dev, "%s: No OPPs for this device: %d\n",
-				__func__, ret);
+				__func__, nr_opp);
 
 			ret = -ENODEV;
 			goto out_free_opp;
-- 
2.30.2



