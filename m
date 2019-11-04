Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4F32EECCB
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbfKDWAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:00:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388870AbfKDWAc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:00:32 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38223214D8;
        Mon,  4 Nov 2019 22:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904831;
        bh=bhnUTGAyaAASV4EfOnbQFrdIhxipFt4vC9r7havsXp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ECzfxEJL+bhSizwVlBxoXdT5KHgnLOAw9VycAfcRp3FE+GmesHt2Ewfluv1HWcJ2J
         o1WV5zifoRImfGyAZXcT94WNRCNErg830UptsOEyBnR5gKIGjrTCM8/utm9RdKumyc
         sHlpT4euEiXe5AUPKdNAP3nVeygAOl+Q6I5nVAWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Zhangshaokun <zhangshaokun@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 044/149] arm64: kpti: Whitelist HiSilicon Taishan v110 CPUs
Date:   Mon,  4 Nov 2019 22:43:57 +0100
Message-Id: <20191104212139.138086779@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanjun Guo <hanjun.guo@linaro.org>

[ Upstream commit 0ecc471a2cb7d4d386089445a727f47b59dc9b6e ]

HiSilicon Taishan v110 CPUs didn't implement CSV3 field of the
ID_AA64PFR0_EL1 and are not susceptible to Meltdown, so whitelist
the MIDR in kpti_safe_list[] table.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Zhangshaokun <zhangshaokun@hisilicon.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ff5beb59b3dc3..220ebfa0ece6e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -906,6 +906,7 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A72),
 		MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
+		MIDR_ALL_VERSIONS(MIDR_HISI_TSV110),
 		{ /* sentinel */ }
 	};
 	char const *str = "kpti command line option";
-- 
2.20.1



