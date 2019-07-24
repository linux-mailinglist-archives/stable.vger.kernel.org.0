Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5F973FCE
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387695AbfGXUfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbfGXTZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C363F22387;
        Wed, 24 Jul 2019 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996345;
        bh=LLsn1vSm6soRTfCSedJcFt0xyr09Q9XPovx2QhngdIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6OlBe6stm/lsFxvxCpyLx7X76BS8vIfhXPaBjySbHit6u9oDwmDl7adcrJMXzf6e
         p+t82a77TgTWNJIjy28D/ZoDozXeGQarV6jjW/v2+5HVhhaw+d+hxA19d7e68Xd3tx
         wOftXN8gGgmD6aqLGsHlKduqNpmWgDer4PlfR4Co=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abhishek Goel <huntbag@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 063/413] cpupower : frequency-set -r option misses the last cpu in related cpu list
Date:   Wed, 24 Jul 2019 21:15:54 +0200
Message-Id: <20190724191739.744017758@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 04507c0a9385cc8280f794a36bfff567c8cc1042 ]

To set frequency on specific cpus using cpupower, following syntax can
be used :
cpupower -c #i frequency-set -f #f -r

While setting frequency using cpupower frequency-set command, if we use
'-r' option, it is expected to set frequency for all cpus related to
cpu #i. But it is observed to be missing the last cpu in related cpu
list. This patch fixes the problem.

Signed-off-by: Abhishek Goel <huntbag@linux.vnet.ibm.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/utils/cpufreq-set.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/power/cpupower/utils/cpufreq-set.c b/tools/power/cpupower/utils/cpufreq-set.c
index f49bc4aa2a08..6ed82fba5aaa 100644
--- a/tools/power/cpupower/utils/cpufreq-set.c
+++ b/tools/power/cpupower/utils/cpufreq-set.c
@@ -305,6 +305,8 @@ int cmd_freq_set(int argc, char **argv)
 				bitmask_setbit(cpus_chosen, cpus->cpu);
 				cpus = cpus->next;
 			}
+			/* Set the last cpu in related cpus list */
+			bitmask_setbit(cpus_chosen, cpus->cpu);
 			cpufreq_put_related_cpus(cpus);
 		}
 	}
-- 
2.20.1



