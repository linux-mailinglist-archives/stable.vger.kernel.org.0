Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46DEA3284F0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhCAQpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234868AbhCAQih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:38:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6AE764F79;
        Mon,  1 Mar 2021 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616060;
        bh=d3YUXZztKby0D0Q3ZtM+QVD+Ro0KFageUqKkSOCjukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YYvkq55CT4zFZFxnpaomre+BepKpxEJCpLofrWZBpn+26TjHiVzZM0x88mXZOUoJd
         dTYjZpaVAocPRdcNNcfAJ72xMImnHcHuvq5WPQVIARQOlM7x3injQ9pt6XUxY/tJrW
         +paBBSsYYikx73f6UEemhd8NW6E6EFAu+M0SPGUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 020/176] cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()
Date:   Mon,  1 Mar 2021 17:11:33 +0100
Message-Id: <20210301161021.973430389@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 3657f729b6fb5f2c0bf693742de2dcd49c572aa1 ]

If 'cpufreq_unregister_driver()' fails, just WARN and continue, so that
other resources are freed.

Fixes: de322e085995 ("cpufreq: brcmstb-avs-cpufreq: AVS CPUfreq driver for Broadcom STB SoCs")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[ Viresh: Updated Subject ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/brcmstb-avs-cpufreq.c b/drivers/cpufreq/brcmstb-avs-cpufreq.c
index 39c462711eae0..815dd7c33e469 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -1033,8 +1033,7 @@ static int brcm_avs_cpufreq_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = cpufreq_unregister_driver(&brcm_avs_driver);
-	if (ret)
-		return ret;
+	WARN_ON(ret);
 
 	brcm_avs_cpufreq_debug_exit(pdev);
 
-- 
2.27.0



