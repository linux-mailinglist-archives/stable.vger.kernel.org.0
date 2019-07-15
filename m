Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7307C6943A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404494AbfGOOq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbfGOOqz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:46:55 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2EF720861;
        Mon, 15 Jul 2019 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202014;
        bh=yY97Q8usz3MAv3QE6289ENyzAFPMNWWq3/ODOUam2bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i3c4UmDrgmlq5WCUNd33mcX/mrLag2leMvbScajjJeIwF41kLYL0G+3aK8U7F0Aft
         MQFTuHsHqmbrXiI5aE/Bva/t/a95GrkZGo62n7HYQHXUz5DzNZuLtMvp3f/2SHAVuF
         wmRgvA1irnIZ0+SaJjpNT1xDPjiqFWu194SOYgH0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Abhishek Goel <huntbag@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 21/53] cpupower : frequency-set -r option misses the last cpu in related cpu list
Date:   Mon, 15 Jul 2019 10:45:03 -0400
Message-Id: <20190715144535.11636-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abhishek Goel <huntbag@linux.vnet.ibm.com>

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
index 0fbd1a22c0a9..2f86935094ca 100644
--- a/tools/power/cpupower/utils/cpufreq-set.c
+++ b/tools/power/cpupower/utils/cpufreq-set.c
@@ -306,6 +306,8 @@ int cmd_freq_set(int argc, char **argv)
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

