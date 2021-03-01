Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF49328628
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbhCARF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:05:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236681AbhCAQ6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE9B264FDF;
        Mon,  1 Mar 2021 16:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616626;
        bh=hakMxTD3W4MSZK40mEvtMtBQom0lgn5VXOlBPRG8f1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+VFlCjTcGxmKmtn6vCb5U0Br+ipvRNCZgM1G5T6LdrIOqmNk3zda2zm8y3zUUKZ1
         cBEf6z2KChfDhRqhtJHhxp5BjhKru2jCx2hS53QsgubPqX4fNUm+T6+E7r3K9TEVAD
         2q+p6kuOulih8oojhAxJ1Pk/KwbhLGKGZ50UjDvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/247] cpufreq: brcmstb-avs-cpufreq: Fix resource leaks in ->remove()
Date:   Mon,  1 Mar 2021 17:11:00 +0100
Message-Id: <20210301161033.645765924@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 1514c9846c5d5..a3c82f530d608 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -723,8 +723,7 @@ static int brcm_avs_cpufreq_remove(struct platform_device *pdev)
 	int ret;
 
 	ret = cpufreq_unregister_driver(&brcm_avs_driver);
-	if (ret)
-		return ret;
+	WARN_ON(ret);
 
 	brcm_avs_prepare_uninit(pdev);
 
-- 
2.27.0



