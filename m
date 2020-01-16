Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68F5313F070
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392505AbgAPR1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392500AbgAPR1o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA04246E0;
        Thu, 16 Jan 2020 17:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195663;
        bh=nTPmWZG5QsXK9I/nWtJnDvDqWkReAjvAHtCTuXPCuMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPUQRFVrsX17NYzy/tUdfv6YOlZj3LZulqG+ef682TStwu73Gd+DWX+1ZX1ea5Z1y
         xcdc8i8A33o5Wasq4hX77UKKbepAOeqdROBtG3/K5IbkoIAPfmVx9NRr651q1WbpzM
         /tQSH6NAUypjMG0VLDHHqkrKqlOuhGkzgtMHuDzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Markus Mayer <mmayer@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 222/371] cpufreq: brcmstb-avs-cpufreq: Fix initial command check
Date:   Thu, 16 Jan 2020 12:21:34 -0500
Message-Id: <20200116172403.18149-165-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 22a26cc6a51ef73dcfeb64c50513903f6b2d53d8 ]

There is a logical error in brcm_avs_is_firmware_loaded() whereby if the
firmware returns -EINVAL, we will be reporting this as an error. The
comment is correct, the code was not.

Fixes: de322e085995 ("cpufreq: brcmstb-avs-cpufreq: AVS CPUfreq driver for Broadcom STB SoCs")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Markus Mayer <mmayer@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/brcmstb-avs-cpufreq.c b/drivers/cpufreq/brcmstb-avs-cpufreq.c
index 7281a2c19c36..bae319037658 100644
--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -762,8 +762,8 @@ static bool brcm_avs_is_firmware_loaded(struct private_data *priv)
 	rc = brcm_avs_get_pmap(priv, NULL);
 	magic = readl(priv->base + AVS_MBOX_MAGIC);
 
-	return (magic == AVS_FIRMWARE_MAGIC) && (rc != -ENOTSUPP) &&
-		(rc != -EINVAL);
+	return (magic == AVS_FIRMWARE_MAGIC) && ((rc != -ENOTSUPP) ||
+		(rc != -EINVAL));
 }
 
 static unsigned int brcm_avs_cpufreq_get(unsigned int cpu)
-- 
2.20.1

