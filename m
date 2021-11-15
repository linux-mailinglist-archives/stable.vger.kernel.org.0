Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE06451445
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348998AbhKOUBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344296AbhKOTYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B37916347F;
        Mon, 15 Nov 2021 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002518;
        bh=A7ONtfqLDDGdWOHFw/M54AMLAu8eh7c6bPsT4placDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XowOLsj2ajv5KcF5CcWwyakjqhKt4OU2z0Mj8mWBMC37T6Zh8Y6+9xaRzZNsfUv7s
         XZKHaVG1u8UALsepCP7fbg7zD9OXwbuzCDIkGuBz2Ikq190SQskq785kF3Hrcw2yuJ
         CpuXIFsaq2kCmsXkTwGrJLT+PgVZhwkentGqF+eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Hector.Yuan" <hector.yuan@mediatek.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 565/917] cpufreq: Fix parameter in parse_perf_domain()
Date:   Mon, 15 Nov 2021 18:01:00 +0100
Message-Id: <20211115165447.951930652@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hector.Yuan <hector.yuan@mediatek.com>

[ Upstream commit 4a08e3271c55f8b5d56906a8aa5bd041911cf897 ]

Pass cpu to parse_perf_domain() instead of pcpu.

Fixes: 8486a32dd484 ("cpufreq: Add of_perf_domain_get_sharing_cpumask")
Signed-off-by: Hector.Yuan <hector.yuan@mediatek.com>
[ Viresh: Massaged changelog ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpufreq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ff88bb3e44fca..66a1f495f01a6 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1041,7 +1041,7 @@ static inline int of_perf_domain_get_sharing_cpumask(int pcpu, const char *list_
 		if (cpu == pcpu)
 			continue;
 
-		ret = parse_perf_domain(pcpu, list_name, cell_name);
+		ret = parse_perf_domain(cpu, list_name, cell_name);
 		if (ret < 0)
 			continue;
 
-- 
2.33.0



