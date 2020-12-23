Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3EE2E141C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730079AbgLWCiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:38:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbgLWCYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F692333B;
        Wed, 23 Dec 2020 02:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690236;
        bh=wJAXHu7zSNDaN3aC8gmRAMD2V4kupXCh6Z8grumo4Wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QN7RUSFOHe2UNDb6nEr80LBSAE97do2cgcxevRzS++g5WiueiqKK6anpoYajvlPGX
         rg+l2y9ankWzrx48sZ3YCdT/M4KW4WaQ2zY3PyPdHqFuJGmLCWN0KVIHmDUHR5VCve
         ud/pYfmdM2GxJ6mk8tw1oIL/NgTQ00/Mg0JG+bXAasNBA6T1JptqEPNc02mYmz11Q9
         TPE2fVztGKs3PeiJtk4zkMOwKyw+iuNpX9YvpV3mQylb+odS2sTLHgcKn7Ij2/gDse
         20CbuT2v1zcrWCNctJHKthfIqiI8iPXOGkB2fLVLqIJy/6BmCBeLDIl/C8ySp/buXi
         GyIoAl1rZ9hxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Yangtao Li <frank@allwinnertech.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 50/66] cpufreq: sti-cpufreq: fix mem leak in sti_cpufreq_set_opp_info()
Date:   Tue, 22 Dec 2020 21:22:36 -0500
Message-Id: <20201223022253.2793452-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 3a5e6732a74c44d7c78a764b9a7701135565df8f ]

Use dev_pm_opp_put_prop_name() to avoid mem leak, which free opp_table.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Yangtao Li <frank@allwinnertech.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index 6b5d241c30b70..01bf9e3a85772 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -226,7 +226,8 @@ static int sti_cpufreq_set_opp_info(void)
 	opp_table = dev_pm_opp_set_supported_hw(dev, version, VERSION_ELEMENTS);
 	if (IS_ERR(opp_table)) {
 		dev_err(dev, "Failed to set supported hardware\n");
-		return PTR_ERR(opp_table);
+		ret = PTR_ERR(opp_table);
+		goto err_put_prop_name;
 	}
 
 	dev_dbg(dev, "pcode: %d major: %d minor: %d substrate: %d\n",
@@ -235,6 +236,10 @@ static int sti_cpufreq_set_opp_info(void)
 		version[0], version[1], version[2]);
 
 	return 0;
+
+err_put_prop_name:
+	dev_pm_opp_put_prop_name(opp_table);
+	return ret;
 }
 
 static int sti_cpufreq_fetch_syscon_registers(void)
-- 
2.27.0

