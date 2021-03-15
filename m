Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD99E33BADC
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235748AbhCOOKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234157AbhCOODA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD0B64DAD;
        Mon, 15 Mar 2021 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816980;
        bh=53IlfbVNqOlyDdD4cFDUvx5We7nCRPWzMldJuRJZDQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=coaY0GtYrwzsDJXJzIMBMbR2tC1mXCYTsnj1/TTpwzRnpdw3rSAUR43emPQUkNWk3
         Ew85YJKD9y3lJhFCCx7Nxm7lqiH1YS3ThHpywvwGVqRV/Nfw9Sd7uZiuJqh5aB9REV
         zDc0x8OFLxXtNmhtuUJMB7lNLzOrt61+XbUx09rk=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 242/306] cpufreq: qcom-hw: fix dereferencing freed memory data
Date:   Mon, 15 Mar 2021 14:55:05 +0100
Message-Id: <20210315135515.824595904@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 02fc409540303801994d076fcdb7064bd634dbf3 ]

Commit 67fc209b527d ("cpufreq: qcom-hw: drop devm_xxx() calls from
init/exit hooks") introduces an issue of dereferencing freed memory
'data'.  Fix it.

Fixes: 67fc209b527d ("cpufreq: qcom-hw: drop devm_xxx() calls from init/exit hooks")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 2726e77c9e5a..5cdd20e38771 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -368,7 +368,7 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 error:
 	kfree(data);
 unmap_base:
-	iounmap(data->base);
+	iounmap(base);
 release_region:
 	release_mem_region(res->start, resource_size(res));
 	return ret;
-- 
2.30.1



